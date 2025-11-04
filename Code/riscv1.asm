addi x1, x0, 5
sub x2 x1, x0
andi x3, x1, 4
or x4, x2, x0
add x3, x2, x3
ori x5, x1, 145
sub x3, x1, x0
and x2, x4, x1

mul x1, x2, x3
mul x1, x1, x1
mul x4, x2, x1
mul x0, x0, x3
div x2, x3, x1
div x4, x1, x4
div x0, x1, x1
div x2, x3, x4

beq x1, x2, next
next:
beq x3, x4, next1
next1:
j next
