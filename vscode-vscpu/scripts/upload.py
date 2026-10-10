"""Standalone VSCPU UART uploader. Input JSON is produced by the extension.
Requires pyserial. No flash access, memory clearing, or automatic core switching.
"""
import argparse
import json
import re
import sys
import time
from pathlib import Path

CORES = {'cm': 2048, 'ct': 2560, 'a0': 1536}

def validate(image, core):
    if not isinstance(image, list) or not image:
        raise ValueError('Image is empty or invalid')
    seen = set()
    for row in image:
        a, w = row.get('address'), row.get('word')
        if type(a) is not int or not 0 <= a < CORES[core]:
            raise ValueError(f'Address outside {core} SRAM: {a}')
        if type(w) is not int or not 0 <= w <= 0xffffffff or a in seen:
            raise ValueError(f'Invalid word or duplicate address: {a}')
        seen.add(a)
    return sorted(image, key=lambda r: r['address'])

def read_word(port, address):
    last = b''
    for _ in range(3):
        port.reset_input_buffer()
        port.write(f'R{address:04X}'.encode('ascii'))
        port.flush()
        last = port.read(8)
        if re.fullmatch(rb'[0-9a-fA-F]{8}', last):
            return int(last, 16)
    raise IOError(f'No valid reply at address {address}: {last!r}. Check programming mode and UART connection.')

def upload(port, records, report=lambda *_: None):
    for i, row in enumerate(records):
        a, w = row['address'], row['word']
        # R selects the address for W. Re-select it on every retry.
        for attempt in range(10):
            if read_word(port, a) == w:
                break
            port.write(f'W{w:08X}'.encode('ascii'))
            port.flush()
            time.sleep(.005)
        else:
            if read_word(port, a) != w:
                raise IOError(f'Write verification failed at address {a}; upload stopped.')
        report('write', i+1, len(records))
    # Detect corruption of earlier words caused by later writes.
    for i, row in enumerate(records):
        actual = read_word(port, row['address'])
        if actual != row['word']:
            raise IOError(f"Final readback failed at address {row['address']}: expected {row['word']:08X}, got {actual:08X}")
        report('verify', i+1, len(records))

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--image', required=True, type=Path)
    p.add_argument('--port', required=True)
    p.add_argument('--core', required=True, choices=CORES)
    args = p.parse_args()
    records = validate(json.loads(args.image.read_text()), args.core)
    try:
        import serial
    except ImportError:
        raise RuntimeError('pyserial is missing. Install it for the Python selected in vscpu.pythonPath: python3 -m pip install pyserial')
    def progress(phase, done, total):
        print(json.dumps(dict(phase=phase, done=done, total=total)), flush=True)
    with serial.Serial(args.port, 57600, bytesize=8, parity='N', stopbits=1,
                       timeout=.3, write_timeout=2, xonxoff=False, rtscts=False, dsrdtr=False) as port:
        upload(port, records, progress)
    print(json.dumps({'phase':'complete'}), flush=True)

if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, RuntimeError, KeyError, TypeError) as exc:
        print(str(exc), file=sys.stderr)
        sys.exit(1)
