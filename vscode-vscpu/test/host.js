const assert=require('node:assert/strict');
const vscode=require('vscode');
exports.run=async()=>{
 const extension=vscode.extensions.getExtension('vscpu-local.vscpu-tools');
 assert.ok(extension,'Extension registered');await extension.activate();
 const commands=await vscode.commands.getCommands(true);
 for(const c of ['vscpu.assemble','vscpu.upload','vscpu.selectCore'])assert.ok(commands.includes(c),c);
 const valid=await vscode.workspace.openTextDocument({language:'vscpu',content:'0: CPi 8254 15\n1: BZJi 32 0\n32: 1'});
 await new Promise(r=>setTimeout(r,300));
 assert.equal(vscode.languages.getDiagnostics(valid.uri).length,0);
 const bad=await vscode.workspace.openTextDocument({language:'vscpu',content:'0: CPi 20000 1'});
 await new Promise(r=>setTimeout(r,300));
 assert.equal(vscode.languages.getDiagnostics(bad.uri).length,1);
 const h=await vscode.commands.executeCommand('vscode.executeHoverProvider',valid.uri,new vscode.Position(0,5));
 assert.ok(h.length>0,'Instruction hover');
 const comp=await vscode.commands.executeCommand('vscode.executeCompletionItemProvider',valid.uri,new vscode.Position(0,3));
 assert.ok(comp.items.some(i=>i.label==='CPi'),'Instruction completion');
 console.log('PASS: VS Code activation, commands, diagnostics, hover and completion');
};
