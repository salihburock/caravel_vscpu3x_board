"""Read a suspect word repeatedly; optionally rewrite that one word first."""
import argparse
from collections import Counter
import time

import testutils


def sample(device, address, count, delay, alternate=None):
    results = Counter()
    for index in range(count):
        if alternate is not None:
            other = device.ReadWord(alternate)
            print(f"  intervening read {alternate}: {other!r}", flush=True)
            time.sleep(delay)
        value = device.ReadWord(address)
        results[value] += 1
        print(f"  {index + 1:2d}: address {address}: {value!r}", flush=True)
        time.sleep(delay)
    print(f"  Counts: {dict(results)}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("uart_device")
    parser.add_argument("address", type=int)
    parser.add_argument("--count", type=int, default=10)
    parser.add_argument("--rewrite", help="Explicitly write this 8-digit hex word before sampling")
    parser.add_argument("--alternate-address", type=int,
                        help="Address to read between suspect-word reads (default: suspect address + 1)")
    args = parser.parse_args()
    if not 0 <= args.address < 16383 or args.count < 1:
        parser.error("address must be 0..16382 and count must be positive")
    alternate = args.address + 1 if args.alternate_address is None else args.alternate_address
    if not 0 <= alternate < 16384:
        parser.error("alternate address must be 0..16383")
    if args.rewrite is not None:
        if len(args.rewrite) != 8 or any(c not in "0123456789abcdefABCDEF" for c in args.rewrite):
            parser.error("--rewrite requires exactly eight hexadecimal digits")
    input("Keep codemaker in programming mode throughout; press enter when ready: ")
    device = testutils.uart(args.uart_device, 57600, 8, 'N', 1)
    try:
        if args.rewrite is not None:
            value = args.rewrite.upper()
            print(f"Rewriting only address {args.address} with {value}...", flush=True)
            device.WriteWord(args.address, value)
            print("Immediate write verification passed.", flush=True)
            time.sleep(0.5)
        print("Repeated reads of the same address:")
        sample(device, args.address, args.count, 0.1)
        print(f"Reads interleaved with address {alternate}:")
        sample(device, args.address, args.count, 0.1, alternate)
    finally:
        device.Close()


if __name__ == "__main__":
    main()
