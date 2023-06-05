from typing import Dict, List

PATH_INPUT_FILE: str = 'code.txt'
PATH_OUTPUT_FILE: str = 'output.mif'
HEX_CHARS: str = '0123456789ABCDEF'
INSTRUCTION_MAP: Dict[str, int] = {'NOP': 0b0000, 'LDA': 0b0001, 'ADD': 0b0010, 'SUB': 0b0011, 'STA': 0b0100,
                                   'LIA': 0b0101, 'JMP': 0b0110, 'JC': 0b0111, 'JZ': 0b1000, 'LDB': 0b1001,
                                   'STE': 0b1010, 'OUT': 0b1110, 'HLT': 0b1111}
MIF_TEMPLATE: List[str] = ['WIDTH=8;\n', 'DEPTH=16;\n', 'ADDRESS_RADIX=HEX;\n', 'DATA_RADIX=BIN;\n', 'CONTENT BEGIN\n',
                           'END;\n']


def read_file() -> List[str]:
    content: List[str] = []
    with open(PATH_INPUT_FILE, 'r') as file:
        for line in file:
            content.append(line.strip())
    return content


def convert_to_mif(_code: List[str]) -> List[str]:
    mif_content: List[str] = MIF_TEMPLATE
    for i, line in enumerate(_code):
        mc: str = instruction_to_machine_code(line)
        mif_content.insert(5 + i, f'{i:1X}: {mc};\n')
    return mif_content


def instruction_to_machine_code(instruction: str) -> str:
    instruction = instruction.split()
    if instruction[0] in INSTRUCTION_MAP.keys():
        s = f'{INSTRUCTION_MAP[instruction[0]]:04b}'
        s += f'{HEX_CHARS.index(instruction[1]):04b}' if len(instruction) == 2 else '0000'
        return s
    return f'{HEX_CHARS.index(instruction[0]):08b}'


def write_output_file(content: List[str]) -> None:
    with open(PATH_OUTPUT_FILE, 'w+') as file:
        file.writelines(content)


code: List[str] = read_file()
code = convert_to_mif(code)
write_output_file(code)
