import os
import time
import argparse
import testutils

def check_excluded_addresses(filename, excluded):
    address = None
    with open(filename) as image:
        for line in image:
            line = line.strip()
            if line.startswith('@'):
                address = int(line[1:])
            else:
                for word in line.split():
                    if address is None:
                        raise ValueError('Memory data before first @address')
                    if address in excluded:
                        raise ValueError(f'{filename} uses excluded address {address}')
                    address += 1

def main(test_name, uart_instance, memclear, watch_address=None, skip_addresses=None, core=None):
    excluded = set(skip_addresses or [])
    if watch_address is not None and watch_address in excluded:
        raise ValueError('Cannot watch an excluded address')
    error_count = 0
    checked_results = 0
    processors = {
        'cm': {'name': 'codemaker', 'memory_size': 2048},
        'ct': {'name': 'control tower', 'memory_size': 2560},
        'a0': {'name': 'agent 0', 'memory_size': 1536}
    }
    if core is not None:
        if core not in processors:
            raise ValueError(f'Unknown core: {core}')
        processors = {core: processors[core]}
    modes = {'cm': '01', 'ct': '10', 'a0': '11'}
    images = {proc: f"../{test_name}/{test_name}_{proc}.mem" for proc in processors}
    images = {proc: path for proc, path in images.items() if os.path.exists(path)}
    if not images:
        raise FileNotFoundError(f'No program images found for {test_name}; run from the utils directory')
    if excluded:
        for path in images.values():
            check_excluded_addresses(path, excluded)
    
    for proc, info in processors.items():
        mem_file = f"../{test_name}/{test_name}_{proc}.mem"
        
        if proc in images:
            input(f"Select mode {modes[proc]} for {info['name']}, wait one second, then press Enter: ")

            if memclear:
                print(f"Clearing memory for {info['name']}... (This may take a few minutes)")
                total = info['memory_size']
                for i in range(total):
                    if i in excluded:
                        continue
                    uart_instance.WriteWord(i, '00000000')
                    
                    # DYNAMIC PROGRESS BAR: Overwrites the same line and forces a terminal flush
                    if i % 64 == 0 or i == total - 1:
                        percent = int((i / total) * 100)
                        print(f"\r  -> Progress: [{i}/{total}] {percent}%", end="", flush=True)
                
                print("\n  -> Memory cleared!", flush=True)
            
            print(f"Uploading {mem_file}...", flush=True)
            if watch_address is None:
                uart_instance.WriteMemFromFile(mem_file)
            else:
                uart_instance.WriteMemFromFile(mem_file, watch_address=watch_address)
            print('Verifying the complete image; keep this core in programming mode.', flush=True)
            if not uart_instance.CheckMemFromFile(mem_file):
                raise IOError(f'Full image verification failed for {info["name"]}; upload stopped')
            print(f"Upload complete for {info['name']}.\n", flush=True)
            
    print('Selected program images are loaded. Select mode 00 to run your code.')
    time.sleep(2)

    for proc, info in processors.items():
        chk_file = f"../{test_name}/{test_name}_{proc}_chk.mem"
        if os.path.exists(chk_file):
            checked_results += 1
            input(f"Please press enter if the program has run and {info['name']} is ready to read")

            result = uart_instance.CheckMemFromFile(chk_file)
            if not result:
                print(f"Test FAILED for {info['name']}")
                error_count += 1

    if not checked_results:
        print('Upload and memory verification passed. Application execution/GPIO outputs have not been checked.')
    elif error_count == 0:
        print("Test SUCCEEDED")
    else:
        print("Test FAILED")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run tests on processors.")
    parser.add_argument('test_name', type=str, help="The name of the test, e.g. bubble_sort.")
    parser.add_argument('uart_device', type=str, help="Path to UART device, e.g. COM15 or /dev/ttyUSB0.")
    parser.add_argument('--memclear', action='store_true', help="Enable memory zeroing before programming.", default=False)
    parser.add_argument('--core', choices=['cm', 'ct', 'a0'], help='Upload/check only this core; switches must still be set manually.')
    args = parser.parse_args()
    
    uart_baudrate = 57600
    uart_instance = testutils.uart(args.uart_device, uart_baudrate, 8, 'N', 1)
    try:
        main(args.test_name, uart_instance, args.memclear, core=args.core)
    finally:
        uart_instance.Close()
