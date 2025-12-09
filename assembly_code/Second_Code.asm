MAIN:
    # Construir la dirección base 0x10010000 en x5
    addi   x5, x0, 256        # x5 = 256
    slli   x5, x5, 4          # x5 = 256 << 4 = 4096  (0x1000)
    addi   x5, x5, 1          # x5 = 4096 + 1 = 4097 (0x1001)
    slli   x5, x5, 16         # x5 = 0x1001 << 16 = 0x10010000
                              # x5 = &array[0]

    addi   x6, x5, 36         # x6 = x5 + 36 = &array[9]
                              # (10 palabras: 0,4,...,36)

    lw     x7, 0(x5)          # x7 = M[x5] = array[0]
                              # x7 será el mínimo actual

LOOP:
    addi   x5, x5, 4          # x5 = x5 + 4 -> siguiente elemento
                              # ahora x5 apunta a array[1], luego [2], ..., [9]

    lw     x8, 0(x5)          # x8 = M[x5] = valor actual del arreglo

    slt    x9, x8, x7         # x9 = (x8 < x7) ? 1 : 0
                              # ¿el valor actual es menor que el mínimo?

    beq    x9, x0, KEEP       # si x9 == 0 (NO es menor), saltar a KEEP
                              # si x9 == 1 (SÍ es menor), no salta y actualizamos mínimo

    add    x7, x8, x0         # x7 = x8
                              # nuevo mínimo = valor actual

KEEP:
    beq    x5, x6, DONE       # si x5 == x6, ya estamos en el último elemento (array[9])
                              # -> terminamos el recorrido

    j      LOOP               # si no, seguimos recorriendo el arreglo

DONE:
    # En este punto:
    # - x5 == x6 == &array[9]
    # - x7 contiene el mínimo de array[0..9]

    sw     x7, 4(x5)          # M[x5 + 4] = x7
                              # guarda el mínimo en array[10] (una palabra después del arreglo)

END:
    j      END                # bucle infinito (programa terminado)
