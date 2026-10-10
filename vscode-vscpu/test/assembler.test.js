const {test}=require('node:test');const assert=require('node:assert/strict');const fs=require('node:fs');const path=require('node:path');
const {assemble,CORES}=require('../src/assembler');
test('Known board instructions encode exactly',()=>{
 assert.equal(assemble('0: CPi 48 1234\n1: CPi 8254 15\n2: BZJi 0 0').mem,'@0\n900C04D2\n980F800F\nD0000000\n');
});
test('Sparse directives retain uploader decimal convention',()=>{
 assert.equal(assemble('0: 0\n48: 4294967295').mem,'@0\n00000000\n@48\nFFFFFFFF\n');
});
test('Existing board images match byte-for-byte',()=>{
 for(const app of ['knightrider/knightrider_cm','gpio_quadrature/gpio_quadrature_cm','run_marker/run_marker_cm']){
 const base=path.join(__dirname,'../../vscpu3x_apps',app);
 const r=assemble(fs.readFileSync(base+'.asm','utf8'),2048);
 assert.deepEqual(r.errors,[]);assert.equal(r.mem,fs.readFileSync(base+'.mem','utf8').replace(/\r\n/g,'\n'));
 }
});
test('Reject truncated operands, junk, signed data, unknown op, duplicates and overflow',()=>{
 for(const s of ['0: CPi 1','0: CPi 1 2 junk','0: -1','0: add 1 2','0: 0\n0: 1','0: 4294967296','0: CPi 16384 0','garbage','0: CPi 1,,2'])assert.ok(assemble(s).errors.length,s);
});
test('Image SRAM bounds do not restrict MMIO operands',()=>{
 for(const c of Object.values(CORES)){
 assert.equal(assemble(`${c.words-1}: CPi 8254 15`,c.words).errors.length,0);
 assert.equal(assemble(`${c.words}: 0`,c.words).errors.length,1);
 }
});
test('Hex/binary source, comma separators and comments',()=>{
 assert.equal(assemble('0x0: CPi 0b110000, 0x4d2 // marker').mem,'@0\n900C04D2\n');
});
