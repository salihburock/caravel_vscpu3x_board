'use strict';
const assert=require('node:assert/strict');
const vm=require('node:vm');
const fs=require('node:fs');
const path=require('node:path');
(async()=>{
 let callback, tick, accept, hide, killed=false, disposed=false;
 const picker={activeItems:[],selectedItems:[],items:[],show(){},dispose(){disposed=true;},
  onDidAccept(fn){accept=fn;return {dispose(){}};},onDidHide(fn){hide=fn;return {dispose(){}};}};
 const context={module:{exports:{}},require:()=>({execFile:(python,args,options,cb)=>{
  callback=cb;return {kill(){killed=true;}};
 }}),setTimeout:fn=>{tick=fn;return 1;},clearTimeout:()=>{tick=undefined;}};
 vm.runInNewContext(fs.readFileSync(path.join(__dirname,'../src/serialPorts.js'),'utf8'),context);
 const select=context.module.exports.selectSerialPort;
 const vscode={window:{createQuickPick:()=>picker}};
 const pending=select(vscode,'python','list_ports.py','COM3');
 callback(null,'[]','');
 assert.match(picker.placeholder,/No serial/);
 tick();callback(null,JSON.stringify([{label:'COM3',description:'CH340'}]),'');
 assert.equal(picker.activeItems[0].label,'COM3');
 tick();callback(null,'[]','');
 assert.equal(picker.items.length,0);
 assert.equal(picker.activeItems.length,0);
 tick();callback(null,JSON.stringify([{label:'COM4',description:'CH340'}]),'');
 picker.selectedItems=[picker.items[0]];accept();
 assert.equal(await pending,'COM4');assert.ok(disposed);assert.equal(tick,undefined);
 const cancelled=select(vscode,'python','list_ports.py','COM4');hide();
 assert.equal(await cancelled,undefined);assert.ok(killed);
 callback(null,'[]',''); // Late subprocess response must not reopen/update picker.
 const failure=select(vscode,'python','list_ports.py','COM4');
 callback(Error('exit 1'),'','Install pyserial');
 await assert.rejects(failure,/Install pyserial/);
 console.log('Serial picker: discovery, hotplug, unplug, selection, cancellation and errors passed.');
})().catch(e=>{console.error(e);process.exitCode=1;});
