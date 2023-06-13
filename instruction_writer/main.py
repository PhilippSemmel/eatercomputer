from typing import List, Dict

SIGNAL = int
INSTRUCTION = List[SIGNAL]

PATH_OUTPUT_FILE: str = '../vhdl/mif_files/instruction_signals.mif'
MIF_TEMPLATE: List[str] = ['WIDTH=16;\n', 'DEPTH=2048;\n', 'ADDRESS_RADIX=HEX;\n', 'DATA_RADIX=BIN;\n',
                           'CONTENT BEGIN\n', 'END;\n']

# logic signals
HLT: SIGNAL = 0b000000000000001
MI: SIGNAL = 0b0000000000000010
RI: SIGNAL = 0b0000000000000100
RO: SIGNAL = 0b0000000000001000
IO: SIGNAL = 0b0000000000010000
II: SIGNAL = 0b0000000000100000
AI: SIGNAL = 0b0000000001000000
AO: SIGNAL = 0b0000000010000000
EO: SIGNAL = 0b0000000100000000
SU: SIGNAL = 0b0000001000000000
BI: SIGNAL = 0b0000010000000000
OI: SIGNAL = 0b0000100000000000
CE: SIGNAL = 0b0001000000000000
CO: SIGNAL = 0b0010000000000000
J: SIGNAL = 0b0100000000000000
FI: SIGNAL = 0b1000000000000000

INSTRUCTIONS: Dict[str, INSTRUCTION] = {
    'NOP': [
        MI | CO,
        RO | II | CE,
        0, 0, 0, 0, 0, 0
    ],
    'LDA': [
        MI | CO,
        RO | II | CE,
        MI | IO,
        RO | AI,
        0, 0, 0, 0
    ],
    'ADD': [
        MI | CO,
        RO | II | CE,
        MI | IO,
        RO | BI | FI,
        AI | EO,
        0, 0, 0
    ],
    'SUB': [
        MI | CO,
        RO | II | CE,
        MI | IO,
        RO | BI | FI,
        AI | EO | SU,
        0, 0, 0
    ],
    'STA': [
        MI | CO,
        RO | II | CE,
        MI | IO,
        RI | AO,
        0, 0, 0, 0
    ],
    'LIA': [
        MI | CO,
        RO | II | CE,
        IO | AI,
        0, 0, 0, 0, 0
    ],
    'JMP': [
        MI | CO,
        RO | II | CE,
        IO | J,
        0, 0, 0, 0, 0
    ],
    'JC': [
        MI | CO,
        RO | II | CE,
        0, 0, 0, 0, 0, 0
    ],
    'JZ': [
        MI | CO,
        RO | II | CE,
        0, 0, 0, 0, 0, 0
    ],
    'LDB': [
        MI | CO,
        RO | II | CE,
        MI | IO,
        RO | BI,
        0, 0, 0, 0
    ],
    'STE': [
        MI | CO,
        RO | II | CE,
        MI | IO,
        RI | EO,
        0, 0, 0, 0
    ],
    'NOP2': [
        MI | CO,
        RO | II | CE,
        0, 0, 0, 0, 0, 0
    ],
    'NOP3': [
        MI | CO,
        RO | II | CE,
        0, 0, 0, 0, 0, 0
    ],
    'NOP4': [
        MI | CO,
        RO | II | CE,
        0, 0, 0, 0, 0, 0
    ],
    'OUT': [
        MI | CO,
        RO | II | CE,
        AI | OI,
        0, 0, 0, 0, 0
    ],
    'HLT': [
        MI | CO,
        RO | II | CE,
        HLT,
        0, 0, 0, 0, 0
    ]
}

FLAGS_Z0C0 = 0
FLAGS_Z0C1 = 1
FLAGS_Z1C0 = 2
FLAGS_Z1C1 = 3

instructions: List[Dict[str, INSTRUCTION]] = [
    INSTRUCTIONS,
    INSTRUCTIONS,
    INSTRUCTIONS,
    INSTRUCTIONS
]


def init_instructions():
    instructions[FLAGS_Z0C1]['JC'][2] = IO | J
    instructions[FLAGS_Z1C0]['JZ'][2] = IO | J
    instructions[FLAGS_Z1C1]['JC'][2] = IO | J
    instructions[FLAGS_Z1C1]['JZ'][2] = IO | J


def convert_to_mif():
    mif_content: List[str] = MIF_TEMPLATE
    max_addr = 2 ** 9
    for addr in range(max_addr):
        flags = (addr & 0b110000000) >> 7
        inst = (addr & 0b001111000) >> 3
        step = (addr & 0b000000111)
        micro_instruction = instructions[flags][list(INSTRUCTIONS.keys())[inst]][step]
        mif_content.insert(addr + 5, f'{addr:03X}: {micro_instruction:016b};\n')
    return mif_content


def write_output_file(content: List[str]) -> None:
    with open(PATH_OUTPUT_FILE, 'w+') as file:
        file.writelines(content)


init_instructions()
mif = convert_to_mif()
write_output_file(mif)
