import re
import argparse
import sys

# Define ISA with merged opcode and immediate values
ISA = {
    'ADD':   '0000',
    'ADDi':  '0001',
    'NAND':  '0010',
    'NANDi': '0011',
    'SRL':   '0100',
    'SRLi':  '0101',
    'LT':    '0110',
    'LTi':   '0111',
    'MUL':   '1110',
    'MULi':  '1111',
    'CP':    '1000',
    'CPi':   '1001',
    'CPI':   '1010',
    'CPIi':  '1011',
    'BZJ':   '1100',
    'BZJi':  '1101',
}

def asm_to_mem(asm_file, output_file):
    current_address = None  # Track the current address

    with open(asm_file, 'r') as asm, open(output_file, 'w') as mem:
        for line in asm:
            line = line.strip()
            if not line or line.startswith('//'):
                continue  # Skip empty lines and comments

            # Check if line contains only a data value, ignoring comments after the data
            data_match = re.match(r'(\d+):\s*(\d+)\s*(//.*)?$', line)
            if data_match:
                address, data_value, _ = data_match.groups()
                address = int(address)  # Convert address to int
                data_value_hex = f"{int(data_value):08X}"  # Convert data to 32-bit hex

                # Write @address only if there’s a gap
                if current_address is None or address != current_address + 1:
                    mem.write(f"@{address}\n")
                mem.write(f"{data_value_hex}\n")
                current_address = address
                continue

            # Parse address and instruction parts
            instr_match = re.match(r'(\d+):\s*(\w+)\s*(\d+),?\s*(\d+)?', line)
            if not instr_match:
                print(f"Skipping unrecognized line format: {line}")
                continue

            address, instruction, operand_a, operand_b = instr_match.groups()
            address = int(address)  # Convert address to int
            opcode_immediate = ISA.get(instruction)

            if opcode_immediate is None:
                print(f"Skipping unknown instruction: {instruction}")
                continue

            # Convert operands to binary with fixed width
            operand_a = f"{int(operand_a):014b}"
            operand_b = f"{int(operand_b):014b}" if operand_b is not None else '0' * 14

            # Construct 32-bit instruction word
            instruction_word = f"{opcode_immediate}{operand_a}{operand_b}"
            instruction_word_hex = f"{int(instruction_word, 2):08X}"

            # Write @address only if there’s a gap
            if current_address is None or address != current_address + 1:
                mem.write(f"@{address}\n")
            mem.write(f"{instruction_word_hex}\n")
            current_address = address

    print(f"Conversion complete. Output written to {output_file}")

if __name__ == "__main__":
    # Argument parser setup
    parser = argparse.ArgumentParser(description="Convert assembly file to .mem format.")
    parser.add_argument("input_file", type=str, help="Input assembly file with .asm extension")

    # Parse arguments
    args = parser.parse_args()
    input_file = args.input_file

    # Check if the input file has the correct .asm extension
    if not input_file.endswith(".asm"):
        print("Error: Unknown format. Please provide a file with the .asm extension.")
        sys.exit(1)

    # Generate the output filename by replacing .asm with .mem
    output_file = input_file.replace(".asm", ".mem")

    # Run the conversion
    asm_to_mem(input_file, output_file)