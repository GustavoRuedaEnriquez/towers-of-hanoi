#Authors: Salvador Octavio Briones Martínez & Gustavo Adolfo Rueda Enríquez
.text
addi $s0,$zero,8

main:
    # Tower's creation
    # TowerA -> $s1 -> starts at 0x10010000
    # TowerB -> $s2 ->starts at 0x10010020
    # TowerC -> $s3 ->starts at 0x10010040
    addi $s1,$zero,0x1001
    sll  $s1,$s1,16
    addi $s2,$s1,0x20
    addi $s3,$s1,0x40
    add  $t0,$zero,$s0
    for:
        beq $t0,$zero,end_for
        sw $t0,($s1)
        addi $s1,$s1,4
        addi $t0,$t0,-1
        j for
    end_for:
    add $a0,$zero,$s0
    add $a1,$zero,$s1
    add $a2,$zero,$s3
    add $a3,$zero,$s2
    jal hanoiTower
    j exit
 
# This is a recursive function that does the  Hanoi's Towers algorithm.
# void hanoiTower(int disk, int **start, int **finish, int **spare)
# $a0 - disk - The disk's number [0,n].
# $a1 - start - It refers to the tower's top where the disk is.
# $a2 - finish - It refers to the tower's top where the disk must end.
# $a3 - spare - It refers to the auxiliary tower's top.   
hanoiTower:
    addi $sp,$sp,-20
    sw $ra,0($sp)
    sw $a0,4($sp)
    sw $a1,8($sp)
    sw $a2,12($sp)
    sw $a3,16($sp)
  
    addi $t0,$a0,-1
    beq $t0,0,end_hanoiTower
    addi $a0,$a0,-1
    add $t0,$zero,$a2
    add $a2,$zero,$a3
    add $a3,$zero,$t0
    jal hanoiTower
    jal move_f
    add $t0,$zero,$a1
    add $a1,$zero,$a2
    add $a2,$zero,$a3
    add $a3,$zero,$t0
    jal hanoiTower
    
end_hanoiTower:
    lw $ra,0($sp)
    lw $a0,4($sp)
    lw $a1,8($sp)
    lw $a2,12($sp)
    lw $a3,16($sp)
    addi $sp,$sp,20
    jr $ra
# This is a functions function removes to top element of an Stack A
# and pushes it to the top of an Stack B.
# void move(int **towerATop, int **towerBTop)
# $a1 - towerATop - The tower's top to be "poped" and pushed to Tower B.
# $a2 - towerBTop - The tower's top.
move_f:
    addi $sp,$sp,-4
    sw $ra,0($sp)
    
    jal pop
    add $a3,$zero,$v0		#int disk = pop(towerATop);
    jal push			#push(disk, towerBTop);
    
    lw $ra,0($sp)
    addi $sp,$sp,4

# This function pushes an element to an Stack's top.
# void push(int disk, int **tower)
# $a3 - disk - The element to be pushed.
# $a2 - tower - The Stack's current top.
push:
    addi $sp,$sp,-4
    sw $ra,0($sp)
    
    sw $a3,0($a2)		#**tower = disk;
    addi $a2,$a2,4		#(*tower)++;
    
    lw $ra,0($sp)
    addi $sp,$sp,4
    jr $ra

# This function pops an Stack's top and returns it.
# int pop(int **tower)
# $a1 - tower - The Stack's current top that will be "poped".
# It returns the result in $v0
pop:
    addi $sp,$sp,-4
    sw $ra,0($sp)
    
    lw $v0,0($a1)		#int number = **tower;
    addi $a1,$a1,-4		#(*tower)--;

    lw $ra,0($sp)
    addi $sp,$sp,4
    jr $ra
exit:
