'use strict';
const OPS = ['ADD','ADDi','NAND','NANDi','SRL','SRLi','LT','LTi','CP','CPi','CPI','CPIi','BZJ','BZJi','MUL','MULi'];
const CORES = {cm: {words:2048, mode:'01'}, ct:{words:2560, mode:'10'}, a0:{words:1536, mode:'11'}};
const HELP = {
 ADD:'M[A] = M[A] + M[B]', ADDi:'M[A] = M[A] + B',
 NAND:'M[A] = ~(M[A] & M[B])', NANDi:'M[A] = ~(M[A] & B)',
 SRL:'M[A] shifts by M[B]: right for 0..31; left by amount−32 for 32..63',
 SRLi:'M[A] shifts by B: right for 0..31; left by B−32 for 32..63',
 LT:'M[A] = unsigned(M[A] < M[B])', LTi:'M[A] = unsigned(M[A] < B)',
 CP:'M[A] = M[B]', CPi:'M[A] = B', CPI:'M[A] = M[M[B] & 0x3FFF]',
 CPIi:'M[M[A] & 0x3FFF] = M[B]', BZJ:'If M[B] == 0: PC = M[A] & 0x3FFF',
 BZJi:'PC = (M[A] + B) & 0x3FFF', MUL:'M[A] = M[A] × M[B]', MULi:'M[A] = M[A] × B'
};
function number(s) {return /^(?:0[xX][0-9a-fA-F]+|0[bB][01]+|[0-9]+)$/.test(s) ? Number(s) : NaN;}
function assemble(source, limit=16384) {
 const errors=[], records=[], seen=new Set();
 source.split(/\r?\n/).forEach((line,i)=>{
  const body=line.split('//')[0].trim(); if(!body)return;
  const fail=message=>errors.push({line:i,message});
  const m=/^(\S+)\s*:\s*(.*?)\s*$/.exec(body);
  if(!m){fail('Expected word-address: instruction A B, or word-address: data.');return;}
  const address=number(m[1]);
  if(!Number.isInteger(address)||address<0||address>=limit){fail(`Image address must be 0..${limit-1}.`);return;}
  if(seen.has(address)){fail(`Duplicate image address ${address}.`);return;}seen.add(address);
  const value=m[2]; const data=number(value); let word;
  if(Number.isFinite(data)) {
   if(!Number.isInteger(data)||data>0xffffffff){fail('Data must be an unsigned 32-bit word (0..4294967295).');return;}word=data;
  } else {
   const ins=/^([A-Za-z]+)\s+(\S+?)(?:\s*,\s*|\s+)(\S+)\s*$/.exec(value);
   if(!ins||!OPS.includes(ins[1])){fail('Unknown instruction or invalid operands. Mnemonics are case-sensitive; use two operands.');return;}
   const a=number(ins[2]),b=number(ins[3]);
   if(![a,b].every(v=>Number.isInteger(v)&&v>=0&&v<16384)){fail('Both instruction operands must fit 14 bits (0..16383).');return;}
   word=OPS.indexOf(ins[1])*0x10000000+a*16384+b;
  }
  records.push({address,word,line:i});
 });
 records.sort((a,b)=>a.address-b.address);
 let mem='',prev=-2;
 for(const r of records){if(r.address!==prev+1)mem+=`@${r.address}\n`;mem+=r.word.toString(16).toUpperCase().padStart(8,'0')+'\n';prev=r.address;}
 return {records, errors, mem, words:records.length, span:records.length?records.at(-1).address+1:0};
}
module.exports={OPS,CORES,HELP,assemble};
