'use strict';
const vscode=require('vscode');
const fs=require('node:fs/promises');
const path=require('node:path');
const os=require('node:os');
const {spawn}=require('node:child_process');
const {OPS,CORES,HELP,assemble}=require('./assembler');
const {selectSerialPort}=require('./serialPorts');
let child, busy=false;
function activate(context) {
 const output=vscode.window.createOutputChannel('VSCPU');
 const diagnostics=vscode.languages.createDiagnosticCollection('vscpu');
 context.subscriptions.push(output,diagnostics);
 const config=uri=>vscode.workspace.getConfiguration('vscpu',uri);
 const coreFor=uri=>config(uri).get('core','cm');
 function check(doc) {
  if(doc.languageId!=='vscpu')return;
  const r=assemble(doc.getText(),CORES[coreFor(doc.uri)].words);
  diagnostics.set(doc.uri,r.errors.map(x=>new vscode.Diagnostic(doc.lineAt(x.line).range,x.message,vscode.DiagnosticSeverity.Error)));
  return r;
 }
 context.subscriptions.push(vscode.workspace.onDidOpenTextDocument(check),vscode.workspace.onDidChangeTextDocument(e=>check(e.document)),vscode.workspace.onDidCloseTextDocument(d=>diagnostics.delete(d.uri)),vscode.workspace.onDidChangeConfiguration(e=>{if(e.affectsConfiguration('vscpu'))vscode.workspace.textDocuments.forEach(check);}));
 vscode.workspace.textDocuments.forEach(check);
 async function current() {
  const doc=vscode.window.activeTextEditor?.document;
  if(!doc||doc.languageId!=='vscpu')throw Error('Open a .asm file in VSCPU Assembly language mode first.');
  if(doc.isUntitled||doc.uri.scheme!=='file')throw Error('Save the assembly to a local .asm file first.');
  if(doc.isDirty && !await doc.save())throw Error('Save cancelled.');
  const result=check(doc);
  if(result.errors.length)throw Error('Assembly has errors. See the Problems panel; nothing was generated or uploaded.');
  if(!result.words)throw Error('The assembly contains no words.');
  return {doc,result,core:coreFor(doc.uri)};
 }
 function command(id,fn){context.subscriptions.push(vscode.commands.registerCommand(id,async()=>{try{await fn();}catch(e){output.appendLine(String(e.message||e));vscode.window.showErrorMessage(String(e.message||e));}}));}
 command('vscpu.selectCore',async()=>{
  const chosen=await vscode.window.showQuickPick(Object.entries(CORES).map(([core,c])=>({label:core.toUpperCase(),description:`${c.words} words · programming mode ${c.mode}`,core})),{title:'Select VSCPU target core'});
  if(chosen){
   const uri=vscode.window.activeTextEditor?.document.uri;
   const target=uri&&vscode.workspace.getWorkspaceFolder(uri)?vscode.ConfigurationTarget.WorkspaceFolder:vscode.ConfigurationTarget.Global;
   await config(uri).update('core',chosen.core,target);
  }
 });
 command('vscpu.assemble',async()=>{
  const {doc,result,core}=await current();
  const target=await vscode.window.showSaveDialog({defaultUri:doc.uri.with({path:doc.uri.path.replace(/\.[^/.]+$/,'')+'.mem'}),filters:{'VSCPU memory image':['mem']}});
  if(!target)return;
  if(target.toString()===doc.uri.toString())throw Error('Choose a different path; the assembly source cannot be overwritten.');
  await vscode.workspace.fs.writeFile(target,Buffer.from(result.mem));
  vscode.window.showInformationMessage(`Assembled ${result.words} words; address span ${result.span}/${CORES[core].words} (${core.toUpperCase()}).`);
 });
 command('vscpu.upload',async()=>{
  if(!vscode.workspace.isTrusted)throw Error('UART upload requires a trusted workspace.');
  if(busy)throw Error('A VSCPU upload is already in progress.');
  busy=true;
  let dir;
  try {
   const {doc,result,core}=await current();
   const port=await selectSerialPort(vscode,config(doc.uri).get('pythonPath','python3'),context.asAbsolutePath('scripts/list_ports.py'),config(doc.uri).get('serialPort','/dev/ttyUSB0'));
   if(!port)return;
   const ready=await vscode.window.showInformationMessage(`Upload ${path.basename(doc.uri.fsPath)} (${result.words} words) to ${core.toUpperCase()} on ${port.trim()}. Select mode ${CORES[core].mode}, wait for it to settle, and keep it selected until verification finishes. The device cannot identify the selected core.`,{modal:true},'Ready — Upload');
   if(!ready)return;
   dir=await fs.mkdtemp(path.join(os.tmpdir(),'vscpu-upload-'));
   const image=path.join(dir,'image.json');
   await fs.writeFile(image,JSON.stringify(result.records));
   const python=config(doc.uri).get('pythonPath','python3');
   output.show(true);output.appendLine(`Uploading ${doc.uri.fsPath} → ${port.trim()} / ${core}; mode ${CORES[core].mode}.`);
   await vscode.window.withProgress({location:vscode.ProgressLocation.Notification,title:'VSCPU upload',cancellable:true},(progress,token)=>new Promise((resolve,reject)=>{
    let stderr='',pending='',cancelled=false,complete=false,last=0;
    child=spawn(python,[context.asAbsolutePath('scripts/upload.py'),'--image',image,'--port',port.trim(),'--core',core],{shell:false,windowsHide:true});
    const cancel=token.onCancellationRequested(()=>{cancelled=true;child?.kill();});
    child.stdout.on('data',b=>{
     pending+=b.toString();let end;
     while((end=pending.indexOf('\n'))>=0){
      const line=pending.slice(0,end);pending=pending.slice(end+1);
      try {const r=JSON.parse(line);if(r.phase==='complete')complete=true;
       else {const percent=(r.phase==='verify'?50:0)+50*r.done/r.total;progress.report({increment:Math.max(0,percent-last),message:`${r.phase}: ${r.done}/${r.total}`});last=percent;}
      }catch{output.appendLine(line);}
     }
    });
    child.stderr.on('data',b=>{stderr=(stderr+b.toString()).slice(-12000);});
    child.on('error',e=>{cancel.dispose();reject(e);});
    child.on('close',code=>{child=undefined;cancel.dispose();
     if(cancelled)reject(Error('Upload cancelled. SRAM may contain a partial image; re-upload before running.'));
     else if(code!==0||!complete)reject(Error(stderr.trim()||`Uploader exited without verification (code ${code}). Keep programming mode selected.`));
     else resolve();
    });
   }));
   output.appendLine('Full image readback passed. Select 00 to run; keep power on. Physical execution is not checked.');
   vscode.window.showInformationMessage('Upload verified. Select mode 00 to run. Physical execution/GPIO outputs have not been checked.');
  } finally {busy=false;if(dir)await fs.rm(dir,{recursive:true,force:true});}
 });
 context.subscriptions.push(vscode.languages.registerCompletionItemProvider('vscpu',{provideCompletionItems(){return OPS.map(op=>{const i=new vscode.CompletionItem(op,vscode.CompletionItemKind.Keyword);i.detail=HELP[op];return i;});}}));
 context.subscriptions.push(vscode.languages.registerHoverProvider('vscpu',{provideHover(doc,pos){const range=doc.getWordRangeAtPosition(pos);if(!range)return;const w=doc.getText(range);if(HELP[w])return new vscode.Hover(`**${w} A B**\n\n${HELP[w]}\n\nWord addresses; 32-bit arithmetic.`,range);if(w==='8254'||w==='8255')return new vscode.Hover(w==='8254'?'GPIO output register (IO27..37).':'GPIO input register (IO16..26).',range);}}));
}
function deactivate(){child?.kill();}
module.exports={activate,deactivate};
