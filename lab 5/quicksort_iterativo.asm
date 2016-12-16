.data
array: .word 63, 9, 85, 66, 71, 8, 38, 42, 35, 89, 13, 20, 100, 75, 35, 68, 16, 91, 76, 56
.text
la $a0, array
addi $a1, $zero, 0
addi $a2, $zero, 20
subi $a2, $a2, 1
Jal QUICKSORT_ITERATIVO

li $v0, 10 #syscall 10 (terminate)
syscall

.globl SWAP
SWAP:
  subi $sp, $sp, 12
  sw $t0, 0($sp)
  sw $t1, 4($sp)
  sw $t2, 8($sp)

  # troca
  #add $t2, $zero, $a0
  #move $a0, $a1
  #move $a1, $t0
  
  lw $t0, 0($a0)
  lw $t1, 0($a1)
  sw $t1, 0($a0)
  sw $t0, 0($a1)

  lw $t0, 0($sp)
  lw $t1, 4($sp)
  lw $t2, 8($sp)
  addi $sp, $sp, 12
  Jr $ra

.globl PARTICIONAR
PARTICIONAR:
  sll $s0, $a2, 2 # dir * 4
  add $s0, $s0, $a0 # pega pos do vetor
  lw $s0, 0($s0)  # x == $s0
  subi $s1, $a1, 1  # i == $s1
  add $s2, $a1, $zero  # j == $s2
  FOR:
    slt $t1, $s2, $a2 # j < dir
    beq $t1, $zero, EXIT_FOR # se j nao for menor q dir
      sll $t1, $s2, 2 # j*4
      add $t1, $t1, $a0 # pega pos do vetor
      lw $t2, 0($t1) # t2 recebe vetor[j]
      slt $t2, $s0, $t2 # se x < t2
      bne $t2, $zero, EXIT_IF # se for menor sai
        addi $s1, $s1, 1 # i++
        # guarda a0, a1 e ra
        subi $sp, $sp, 12
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $ra, 8($sp)
        sll $t3, $s1, 2 #pega pos de vetor[i]
        add $t3, $t3, $a0 #pega pos de vetor[i]
        #la $a0, 0($t2)
        #la $a1, 0($t1)
        #Jal SWAP
        lw $t4, 0($t1)
        lw $t5, 0($t3)
        sw $t4, 0($t3)
        sw $t5, 0($t1)
        
        # restaura valores de a0, a1 e ra
        lw $a0, 0($sp)
        lw $a1, 4($sp)
        lw $ra, 8($sp)
        addi $sp, $sp, 12
    EXIT_IF:
    addi $s2, $s2, 1 #j++
    j FOR
  EXIT_FOR:
  # swap
  subi $sp, $sp, 12
  sw $a0, 0($sp)
  sw $a1, 4($sp)
  sw $ra, 8($sp)
  addi $t0, $s1, 1
  sll $t0, $t0, 2
  add $t0, $t0, $a0
  sll $t1, $a2, 2
  add $t1, $t1, $a0
  #la $a0, 0($t0)
  #la $a1, 0($t1)
  #Jal SWAP
  lw $t2, 0($t0)
  lw $t3, 0($t1)
  sw $t2, 0($t1)
  sw $t3, 0($t0)
  
  lw $a0, 0($sp)
  lw $a1, 4($sp)
  lw $ra, 8($sp)
  addi $sp, $sp, 12
  addi $v0, $s1, 1
  Jr $ra


QUICKSORT_ITERATIVO:
  sub $t0, $a2, $a1 # dir - esq
  add $t0, $t0, 1 # dir - esq + 1
  subi $sp, $sp, 4
  sw $a0, 0($sp)
  sll $a0, $t0, 2 #espaco para dir-esq+1 inteiros(x4)
  # http://stackoverflow.com/questions/19612459/mips-how-does-mips-allocate-memory-for-arrays-in-the-stack
  li $v0, 9 #syscall 9 (sbrk)
  syscall # aloca memoria
  add $s0, $v0, $zero #stack == $s0
  lw $a0, 0($sp)
  addi $sp, $sp, 4
  li $s1, -1 #top == $s1
  sw $a1, 0($s0) #stack[0]
  sw $a2, 4($s0) #stack[1]
  addi $s1, $s1, 2
  WHILE:
    slt $t0, $s1, $zero # top < 0
    bne $t0, $zero, EXIT_WHILE #se nao for, entra no if
      sll $t0, $s1, 2 # pega pos vetor[top]
      add $t0, $t0, $s0 # pega pos vetor[top]
      lw $a2, 0($t0) # pega vetor[top]
      subi $s1, $s1, 1 #top--
      sll $t0, $s1, 2 # pega pos vetor[top]
      add $t0, $t0, $s0 # pega pos vetor[top]
      lw $a1, 0($t0) # pega vetor[top]
      subi $s1, $s1, 1 # top--

      #chama o particionar
      subi $sp, $sp, 12
      sw $s0, 0($sp)
      sw $s1, 4($sp)
      sw $ra, 8($sp)
      Jal PARTICIONAR
      lw $s0, 0($sp)
      lw $s1, 4($sp)
      lw $ra, 8($sp)
      addi $sp, $sp, 12
      add $s2, $v0, $zero # p == $s2

      subi $t0, $s2, 1 # p -1
      slt $t0, $a1, $t0 #esq < p-1
      beq $t0, $zero, EXIT_IF_1 #entra se esq for menor
        addi $s1, $s1, 1
        sll $t0, $s1, 2
        add $t0, $t0, $s0
        sw $a1, 0($t0)
        addi $s1, $s1, 1
        sll $t0, $s1, 2
        add $t0, $t0, $s0
        subi $t1, $s2, 1
        sw $t1, 0($t0)
      EXIT_IF_1:

      addi $t0, $s2, 1
      slt $t0, $t0, $a2
      beq $t0, $zero, EXIT_IF_2
        addi $s1, $s1, 1
        sll $t0, $s1, 2
        add $t0, $t0, $s0
        addi $t1, $s2, 1
        sw $t1, 0($t0)
        addi $s1, $s1, 1
        sll $t0, $s1, 2
        add $t0, $t0, $s0
        sw $a2, 0($t0)
      EXIT_IF_2:

    j WHILE
  EXIT_WHILE:
  Jr $ra
