import sys
import unittest
from pathlib import Path
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from upload import validate, upload

class Serial:
    def __init__(self, corrupt=False, dead=False, reject=False):
        self.mem={}; self.addr=0; self.commands=[]
        self.corrupt=corrupt; self.dead=dead; self.reject=reject
    def reset_input_buffer(self): pass
    def flush(self): pass
    def write(self,b):
        self.commands.append(b)
        if b[:1]==b'R': self.addr=int(b[1:],16)
        else:
            if not self.reject:self.mem[self.addr]=int(b[1:],16)
            if self.corrupt and self.addr==49:self.mem[48]=0
    def read(self,n):
        return b'' if self.dead else f'{self.mem.get(self.addr,0):08X}'.encode()

class Tests(unittest.TestCase):
    @patch('upload.time.sleep')
    def test_sparse_write_and_full_readback(self,_):
        s=Serial();upload(s,validate([{'address':48,'word':1234},{'address':0,'word':0x900c04d2}],'cm'))
        self.assertEqual(s.mem,{0:0x900c04d2,48:1234})
        self.assertEqual(s.commands[-2:],[b'R0000',b'R0030'])
    @patch('upload.time.sleep')
    def test_late_corruption_is_caught(self,_):
        with self.assertRaisesRegex(IOError,'Final readback'):
            upload(Serial(corrupt=True),[{'address':48,'word':1234},{'address':49,'word':1}])
    def test_no_reply_never_writes(self):
        s=Serial(dead=True)
        with self.assertRaises(IOError): upload(s,[{'address':0,'word':1}])
        self.assertTrue(all(b.startswith(b'R') for b in s.commands))
    @patch('upload.time.sleep')
    def test_failed_write_has_finite_retries(self,_):
        s=Serial(reject=True)
        with self.assertRaises(IOError): upload(s,[{'address':0,'word':1}])
        self.assertEqual(sum(b.startswith(b'W') for b in s.commands),10)
    def test_bad_images_rejected(self):
        for image in [[],[{'address':2048,'word':0}],[{'address':0,'word':-1}],[{'address':0,'word':1}]*2]:
            with self.assertRaises(ValueError):validate(image,'cm')

if __name__=='__main__':unittest.main()
