import serial
import time

class uart:
    def __init__(self, port, baudrate, bytesize, parity, stopbits):
        self.SerialPort = serial.Serial(port)
        self.SerialPort.baudrate = baudrate
        self.SerialPort.bytesize = bytesize
        self.SerialPort.parity   = parity
        self.SerialPort.stopbits = stopbits
        # PROTECTED: Increased timeout to give the VSCPU more time to respond
        self.SerialPort.timeout  = 0.1 

        print('\nStatus -> ', self.SerialPort)
        
    def Close(self):
        self.SerialPort.close()

    def ReadWord(self, address):
        RXWord = ""
        retry = 0
        # PROTECTED: Caps the loop at 5 retries to prevent infinite deadlocks
        while len(RXWord) < 8 and retry < 5:
            self.SerialPort.reset_input_buffer()
            self.SerialPort.write(b'R' + bytes(dec2hex(address, 4), 'UTF-8'))
            
            # PROTECTED: Block-reads exactly 8 bytes instead of looping 1 by 1
            raw_bytes = self.SerialPort.read(8)
            if len(raw_bytes) == 8:
                try:
                    RXWord = raw_bytes.decode('UTF-8')
                except UnicodeDecodeError:
                    RXWord = ""
            retry += 1
        return RXWord 
    
    def ReadMemory(self, address, datacount):
        mem = []
        current_address = address
        for _ in range(datacount):
            mem.append(self.ReadWord(current_address))
            current_address += 1
        return mem
        
    def WriteWord(self, address, data):
        RXWord = self.ReadWord(address)
        retry = 0
        # PROTECTED: Caps the write verification loop at 10 retries
        while RXWord != data and retry < 10:
            self.SerialPort.write(b'W' + bytes(data, 'UTF-8'))
            time.sleep(0.005) # Brief hardware pause to stabilize the UART bridge
            RXWord = self.ReadWord(address)
            retry += 1
        if RXWord != data:
            raise IOError(
                f"Write verification failed at address {address}: "
                f"expected {data}, read {RXWord!r} after {retry} attempts. "
                "Keep the core in programming mode and check the connection."
            )
        
    def WriteInt(self, address, data):
        self.WriteWord(address, dec2hex(data, 8))
                    
    def WriteMemory(self, startAddr, mem):
        waddr = startAddr
        for data in mem:
            self.WriteWord(waddr, data)
            waddr = waddr + 1
            
    def WriteMemFromFile(self, filename, watch_address=None):
        with open(filename, 'r') as file:
            lines = file.readlines()

        address = None
        words = []
        for line in lines:
            line = line.strip()
            if line.startswith('@'):
                address = int(line[1:])
            else:
                for data in line.split():
                    if address is None:
                        raise ValueError("Memory data before first @address")
                    words.append((address, data))
                    address += 1
        if watch_address is not None and not any(a == watch_address for a, _ in words):
            raise ValueError(f"Watch address {watch_address} is absent from {filename}")

        watched_value = None
        for address, data in words:
            self.WriteWord(address, data)
            if address == watch_address:
                watched_value = data
                print(f"Watching address {watch_address}: expected {data}", flush=True)
            if watched_value is not None:
                actual = self.ReadWord(watch_address)
                if actual != watched_value:
                    samples = [actual] + [self.ReadWord(watch_address) for _ in range(3)]
                    raise IOError(
                        f"Watch address {watch_address} changed after processing "
                        f"write to address {address} with {data}: expected "
                        f"{watched_value}, reads {samples}. Upload stopped."
                    )
            
    def CheckMemFromFile(self, filename):
        mismatch_count = 0 
        with open(filename, 'r') as file:
            lines = file.readlines()

        start_address = None
        expected_memory = []

        for line in lines:
            line = line.strip()
            if line.startswith('@'):
                if start_address is not None:
                    actual_memory = self.ReadMemory(start_address, len(expected_memory))
                    for i, (expected, actual) in enumerate(zip(expected_memory, actual_memory)):
                        if expected != actual:
                            print(f"Mismatch at address {start_address+i}! Expected: {expected}, Actual: {actual}")
                            mismatch_count += 1
                start_address = int(line[1:])
                expected_memory = []
            else:
                expected_memory.extend(line.split())
        
        if start_address is not None:
            actual_memory = self.ReadMemory(start_address, len(expected_memory))
            for i, (expected, actual) in enumerate(zip(expected_memory, actual_memory)):
                if expected != actual:
                    print(f"Mismatch at address {start_address+i}! Expected: {expected}, Actual: {actual}")
                    mismatch_count += 1

        return mismatch_count == 0

def dec2hex(dec, width):
    return hex(dec).split('x')[-1].upper().zfill(width)
