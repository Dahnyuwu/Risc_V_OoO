        addi x0,  x0, 0     # F4 --> 74
        addi x1,  x0, 1
        addi x2,  x0, 2
        addi x3,  x0, 3
        addi x4,  x0, 4
        addi x5,  x0, 5
        addi x6,  x0, 6
        addi x7,  x0, 7
        addi x8,  x0, 8
        addi x9,  x0, 9
        addi x10, x0, 10
        addi x11, x0, 11
        addi x12, x0, 12
        addi x13, x0, 13
        addi x14, x0, 14
        addi x15, x0, 15
        addi x16, x0, 16
        addi x17, x0, 17
        addi x18, x0, 18
        addi x19, x0, 19
        addi x20, x0, 20
        addi x21, x0, 21
        addi x22, x0, 22
        addi x23, x0, 23
        addi x24, x0, 24
        addi x25, x0, 25
        addi x26, x0, 26
        addi x27, x0, 27
        addi x28, x0, 28
        addi x29, x0, 29
        addi x30, x0, 30
        addi x31, x0, 31
    
    
    ############################################################
    # BUBBLE SORT
    ############################################################

    add x0, x0, x0              # nop *** INITIALIZATION FOR BUBBLE SORT ***
    add x31, x4, x0             # x31 = 4
    mul x2, x5, x31             # ak = 4 * num_of_items
    add x0, x0, x0              # nop

BUBBLE_BEGIN:
    add x3, x0, x0              # ai = 0 *** BUBBLE SORT STARTS ***
    add x4, x3, x31             # aj = ai + 4
    slt x6, x4, x2              # (aj < ak) ?
    beq x6, x0, CHECK_FIRST5    # if no, program finishes. goto checker

LOAD:
    lw  x13, 0(x3)              # mi = M(ai)
    lw  x14, 0(x4)              # mj = M(aj)
    slt x6, x14, x13            # (mj < mi) ?
    beq x6, x0, SKIP_SWAP       # if no, skip swap

    sw  x14, 0(x3)              # M(ai) = mj // swap
    sw  x13, 0(x4)              # M(aj) = mi // swap

SKIP_SWAP:
    add x3, x3, x31             # ai = ai + 4
    add x4, x4, x31             # aj = aj + 4

    slt x6, x4, x2              # (aj < ak) ?
    beq x6, x1, LOAD            # if yes, goto LOAD  (x1 se asume = 1)
    sub x2, x2, x31             # ak = ak - 4
    j   BUBBLE_BEGIN            # goto BEGIN  (pseudoinstrucción jal x0,BUBBLE_BEGIN)


    ############################################################
    # CHECKER FOR FIRST 5 ITEMS
    ############################################################

CHECK_FIRST5:
    add x0, x0, x0              # nop *** CHECKER FOR FIRST 5 ITEMS ***
    add x26, x0, x0             # addr1 = 0
    add x27, x26, x31           # addr2 = addr1 + 4
    mul x28, x5, x31            # addr3 = num_of_items * 4

CHECK1_LOOP:
    add x28, x28, x26           # addr3 = addr3 + addr1
    lw  x29, 0(x26)             # maddr1 = M(addr1)
    lw  x30, 0(x27)             # maddr2 = M(addr2)
    slt x25, x30, x29           # (maddr2 < maddr1) ?

    beq x25, x0, CHECK1_NEXT    # if no, proceed to the next data
CHECK1_STUCK:
    beq x0, x0, CHECK1_STUCK    # else, You're stuck here (bucle infinito)

CHECK1_NEXT:
    add x26, x26, x31           # addr1 = addr1 + 4
    add x27, x27, x31           # addr2 = addr2 + 4

    beq x27, x28, AFTER_CHECK1  # if all tested, proceed to the next program
    j   CHECK1_LOOP             # else test next data
    add x0, x0, x0              # noop
    add x0, x0, x0              # noop


    ############################################################
    # SELECTION SORT
    ############################################################

AFTER_CHECK1:
    add x0, x0, x0              # nop *** INITIALIZATION FOR SELECTION SORT ***
    add x2, x5, x0              # set min = 5  (según comentario original)
    add x9, x5, x31             # x9 = 9  (si x5=5 y x31=4)
    add x10, x9, x1             # x10 = 10 (si x1=1)

    add x6, x0, x0              # slt_result = 0
    add x3, x5, x0              # i = 5
    add x4, x3, x1              # j = i+1

SEL_OUTER:
    mul x13, x3, x31            # ai = i*4

    lw  x23, 0(x13)             # mi = M(ai)
    add x12, x13, x0            # amin = ai
    add x22, x23, x0            # mmin = mi

SEL_INNER:
    mul x14, x4, x31            # aj = j*4
    lw  x24, 0(x14)             # mj = M(aj)
    slt x6, x24, x22            # (mj < mmin)
    beq x6, x0, SEL_INNER_CONT  # if(no), no actualiza amin/mmin
    add x12, x14, x0            # amin = aj
    add x22, x24, x0            # mmin = mj

SEL_INNER_CONT:
    add x4, x4, x1              # j++
    beq x4, x10, SEL_INNER_DONE # (j == 10)
    j   SEL_INNER               # if(no), sigue inner loop

SEL_INNER_DONE:
    add x0, x0, x0              # nop
    sw  x22, 0(x13)             # M(ai)   = mmin // swap
    sw  x23, 0(x12)             # M(amin) = mi   // swap
    add x3, x3, x1              # i++

    add x4, x3, x1              # j = i+1
    beq x3, x9, AFTER_SELECTION # (i==9) -> fin de selection sort
    j   SEL_OUTER               # if(no), siguiente iteración de i
    add x0, x0, x0              # nop


    ############################################################
    # CHECKER FOR THE NEXT 5 ITEMS
    ############################################################

AFTER_SELECTION:
    add x0, x0, x0              # nop *** CHECKER FOR THE NEXT 5 ITEMS ***
    mul x26, x5, x31            # addr1 = num_of_items * 4
    add x27, x26, x31           # addr2 = addr1 + 4
    mul x28, x5, x31            # addr3 = num_of_items * 4

CHECK2_LOOP:
    add x28, x28, x26           # addr3 = addr3 + addr1
    lw  x29, 0(x26)             # maddr1 = M(addr1)
    lw  x30, 0(x27)             # maddr2 = M(addr2)
    slt x25, x29, x30           # (maddr1 < maddr2) ?

    beq x25, x25, CHECK2_NEXT   # if yes, proceed to the next data (siempre se toma)
CHECK2_STUCK:
    beq x0, x0, CHECK2_STUCK    # else, You're stuck here (bucle infinito)

CHECK2_NEXT:
    add x26, x26, x31           # addr1 = addr1 + 4
    add x27, x27, x31           # addr2 = addr2 + 4

    beq x27, x28, END_PROGRAM   # if all tested, proceed to the next program
    j   CHECK2_LOOP             # else test next data
    add x0, x0, x0              # noop
    add x0, x0, x0              # noop

END_PROGRAM:
    # fin
