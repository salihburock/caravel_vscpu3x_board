'use strict';
const {execFile}=require('node:child_process');

function selectSerialPort(vscode, python, script, preferred) {
 return new Promise((resolve,reject)=>{
  const picker=vscode.window.createQuickPick();
  picker.title='VSCPU UART port';
  picker.placeholder='Looking for serial devices…';
  picker.matchOnDescription=true;
  picker.matchOnDetail=true;
  let closed=false, timer, process, signature;
  const subscriptions=[];
  function finish(port,error) {
   if(closed)return;
   closed=true;
   clearTimeout(timer);
   process?.kill();
   subscriptions.forEach(s=>s.dispose());
   picker.dispose();
   if(error)reject(error);else resolve(port);
  }
  function refresh() {
   if(closed)return;
   picker.busy=true;
   process=execFile(python,[script],{windowsHide:true,timeout:5000,maxBuffer:1024*1024},(error,stdout,stderr)=>{
    process=undefined;
    if(closed)return;
    picker.busy=false;
    if(error){finish(undefined,Error(`Cannot list serial ports: ${stderr.trim()||error.message}`));return;}
    let ports;
    try {ports=JSON.parse(stdout);if(!Array.isArray(ports))throw Error('Expected a port list');}
    catch(e){finish(undefined,Error(`Invalid serial discovery response: ${e.message}`));return;}
    const next=JSON.stringify(ports);
    if(next!==signature){
     const active=picker.activeItems[0]?.label || preferred;
     picker.items=ports;
     const item=ports.find(p=>p.label===active);
     picker.activeItems=item?[item]:[];
     signature=next;
    }
    picker.placeholder=ports.length?'Select a serial device':'No serial devices found — plug in your board';
    timer=setTimeout(refresh,1000);
   });
  }
  subscriptions.push(picker.onDidAccept(()=>{
   const selected=picker.selectedItems[0];
   if(selected && picker.items.some(p=>p.label===selected.label))finish(selected.label);
  }),picker.onDidHide(()=>finish()));
  picker.show();
  refresh();
 });
}
module.exports={selectSerialPort};
