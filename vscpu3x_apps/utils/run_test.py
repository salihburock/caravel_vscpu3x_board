import os
import time
import argparse
import testutils

def check_excluded_addresses(filename, excluded):
    """Reject images/checks using excluded words instead of silently omitting data."""
    address = None
    with open(filename) as source:
        for line in source:
            line = line.strip()
            if line.startswith('@'):
                address = int(line[1:])
            else:
                for word in line.split():
                    if address is None:
                        raise ValueError(f"Data before first address in {filename}")
                    if address in excluded:
                        raise ValueError(f"{filename} uses excluded address {address}; relocate the image first")
                    address += 1


def main(test_name, uart_instance, memclear, watch_address=None, skip_addresses=()):
    excluded = set(skip_addresses)
    if any(not 0 <= address < 16384 for address in excluded):
        raise ValueError("Skipped addresses must be within 0..16383")
    if watch_address is not None and watch_address in excluded:
        raise ValueError("Cannot watch an excluded address")
    error_count = 0
    processors = {
        'cm': {'name': 'codemaker', 'memory_size': 2048},
        'ct': {'name': 'control tower', 'memory_size': 2560},
        'a0': {'name': 'agent 0', 'memory_size': 1536}
    }
    if not any(os.path.exists(f"../{test_name}/{test_name}_{proc}.mem")
               for proc in processors):
        raise FileNotFoundError(f"No .mem files found for {test_name!r}; nothing uploaded")
    if excluded:
        for proc in processors:
            for suffix in (".mem", "_chk.mem"):
                filename = f"../{test_name}/{test_name}_{proc}{suffix}"
                if os.path.exists(filename):
                    check_excluded_addresses(filename, excluded)
        print(f"Excluded addresses (no programming access): {sorted(excluded)}")
    
    for proc, info in processors.items():
        mem_file = f"../{test_name}/{test_name}_{proc}.mem"
        
        if os.path.exists(mem_file):
            input(f"Please press enter if {info['name']} is ready to program")

            if memclear:
                print(f"Clearing memory for {info['name']}... (This may take a few minutes)")
                total = info['memory_size']
                for i in range(total):
                    if i not in excluded:
                        uart_instance.WriteWord(i, '00000000')
                    
                    # DYNAMIC PROGRESS BAR: Overwrites the same line and forces a terminal flush
                    if i % 64 == 0 or i == total - 1:
                        percent = int(((i + 1) / total) * 100)
                        print(f"\r  -> Progress: [{i}/{total}] {percent}%", end="", flush=True)
                
                print("\n  -> Memory cleared (excluding skipped addresses)." if excluded
                      else "\n  -> Memory cleared!", flush=True)
            
            print(f"Uploading {mem_file}...", flush=True)
            if watch_address is None:
                uart_instance.WriteMemFromFile(mem_file)
            else:
                uart_instance.WriteMemFromFile(mem_file, watch_address=watch_address)
            print("Verifying the complete image; keep the core in programming mode...", flush=True)
            if not uart_instance.CheckMemFromFile(mem_file):
                raise IOError(f"Upload readback failed for {info['name']}; do not run the program")
            print(f"Upload complete for {info['name']}.\n", flush=True)
            
    print(f"All programs are loaded. Please exit program mode and run your code.")
    time.sleep(2)

    for proc, info in processors.items():
        chk_file = f"../{test_name}/{test_name}_{proc}_chk.mem"
        if os.path.exists(chk_file):
            input(f"Please press enter if the program has run and {info['name']} is ready to read")

            result = uart_instance.CheckMemFromFile(chk_file)
            if not result:
                print(f"Test FAILED for {info['name']}")
                error_count += 1

    if error_count == 0:
        print("Upload/readback and any requested memory checks passed; hardware behavior is not verified.")
    else:
        print("Test FAILED")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run tests on processors.")
    parser.add_argument('test_name', type=str, help="The name of the test, e.g. bubble_sort.")
    parser.add_argument('uart_device', type=str, help="Path to UART device, e.g. COM15 or /dev/ttyUSB0.")
    parser.add_argument('--memclear', action='store_true', help="Enable memory zeroing before programming.", default=False)
    parser.add_argument('--watch-address', type=int,
                        help="After programming this word, check it after every subsequent image write")
    parser.add_argument('--skip-address', type=int, action='append', default=[],
                        help="Exclude an address from clearing; reject images/checks that access it (repeatable)")
    args = parser.parse_args()
    
    uart_baudrate = 57600
    uart_instance = testutils.uart(args.uart_device, uart_baudrate, 8, 'N', 1)
    try:
        main(args.test_name, uart_instance, args.memclear, args.watch_address, args.skip_address)
    finally:
        uart_instance.Close()
