import random

# R_type = ['R_type', 'ADD', 'SUB', 'XOR', 'OR', 'AND', 'SLL', 'SRL', 'SRA', 'SLT', 'SLTU', 'MUL', 'DIV']
R_type = ['R_type', 'ADD', 'SUB', 'OR', 'AND', 'SLT']
# I_type = ['I_type', 'ADDI', 'XORI', 'ORI', 'ANDI', 'SLLI', 'SRLI', 'SRAI', 'SLTI', 'SLTIU']
I_type = ['I_type', 'ADDI', 'ORI', 'ANDI', 'SLTI']
LW_type = ['LW_type', 'LW']
SW_type = ['SW_type', 'SW']
B_type = ['B_type', 'BEQ', 'BNE']
J_type = ['J_type', 'JAL', 'JALR']
instr = []
type_a = 0

ni = int(input("Numero de instrucciones: "))
r = int(input("Instrucciones tipo R? "))
i = int(input("Instrucciones tipo I? "))
l = int(input("Instrucciones tipo LW? "))
s = int(input("Instrucciones tipo SW? "))
b = int(input("Instrucciones tipo B? "))
j = int(input("Instrucciones tipo j? "))

if r:
    instr.append(R_type)
    type_a += 1

if i:
    instr.append(I_type)
    type_a += 1

if l:
    instr.append(LW_type)
    type_a += 1

if s:
    instr.append(SW_type)
    type_a += 1

if b:
    instr.append(B_type)
    type_a += 1

if j:
    instr.append(B_type)
    type_a += 1

print("main:")
for i in range(0, ni):
    ra = random.randint(0, type_a-1)
    rd = random.randint(0, 31)
    rs1 = random.randint(0, 31)
    rs2 = random.randint(0, 31)
    imm = random.randint(-255, 255)

    if instr[ra][0] == 'R_type':
        ra2 = random.randint(0, len(R_type)-2)
        instruction = (f'{instr[ra][ra2+1]} x{rd}, x{rs1}, x{rs2}')
        print(instruction)
    
    elif instr[ra][0] == 'I_type':
        ra2 = random.randint(0, len(I_type)-2)
        instruction = (f'{instr[ra][ra2+1]} x{rd}, x{rs1}, {rs2}')
        print(instruction)
    
    elif instr[ra][0] == 'LW_type':
        ra2 = random.randint(0, len(LW_type)-2)
        instruction = (f'{instr[ra][ra2+1]} x{rd}, {rs2*4}(x{rs1})')
        print(instruction)
    
    elif instr[ra][0] == 'SW_type':
        ra2 = random.randint(0, len(SW_type)-2)
        instruction = (f'{instr[ra][ra2+1]} x{rd}, {rs2*4}(x{rs1})')
        print(instruction)
    
    elif instr[ra][0] == 'B_type':
        ra2 = random.randint(0, len(B_type)-2)
        instruction = (f'{instr[ra][ra2+1]} x{rs1}, x{rs2}, main')
        print(instruction)
    
    elif instr[ra][0] == 'J_type':
        ra2 = random.randint(0, len(J_type)-2)
        instruction = (f'{instr[ra][ra2+1]} x{rd} main')
        print(instruction)
