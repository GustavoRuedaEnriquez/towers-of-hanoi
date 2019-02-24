#Authors: Salvador Octavio Briones Martínez & Gustavo Adolfo Rueda Enríquez
.text
addi $s0,$zero,3
main: 
    # Tower's creation
    # TowerA -> $s1 -> starts at 0x10010000
    # TowerB -> $s2 -> starts at 0x10010020
    # TowerC -> $s3 -> starts at 0x10010040
    addi $s1,$zero,0x1001
    sll  $s1,$s1,16		#$s1 = 0x10010000
    addi $s2,$s1,0x1C		#$s2 = 0x10010020
    addi $s3,$s1,0x3C		#$s3 = 0x10010040
    add  $t0,$zero,$s0
    
    addi $s1,$s1,-4		#move the Tower A stack pointer one place back.
      
    for:
        beq $t0,$zero,end_for
        addi $s1,$s1,4		#move the Tower A stack pointer one place forward.

        sw $t0,0($s1)		#place a disk in Tower A 
        
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
    bne $a0, $zero, recursion
    jr  $ra
    
recursion:
    addi $sp,$sp,-20
    sw $ra,0($sp)
    sw $a0,4($sp)
    sw $a1,8($sp)
    sw $a2,12($sp)
    sw $a3,16($sp)
  
    addi $a0,$a0,-1
    add $t0,$zero,$a2	
    add $a2,$zero,$a3	#Swap: finish -> spare
    add $a3,$zero,$t0	#Swap: spare -> finish
    jal hanoiTower
    add $t0,$zero,$a2	#Back up spare reference.
    add $a2, $a3, $zero	#Swap: spare -> finish
    add $a3,$zero,$t0	#Restoring spare reference.
    
    #pop
    lw $v0,0($a1)	#int number = **tower;
    sw $zero,0($a1)	#Clear stack.
    addi $a1,$a1,-4	#(*tower)--;
   
    ##push		#push(disk, towerBTop);
    addi $a2,$a2,4	#(*tower)++;
    sw $v0,0($a2)	#**tower = disk;
    
    sw $a1,8($sp)
    sw $a2,12($sp)
    sw $a3,16($sp)
    
    lw $a0,4($sp)
    addi $a0,$a0,-1
    add $t0,$zero,$a1	#Back up start reference.
    add $a1,$zero,$a3	#Swap: start -> spare
    add $a3,$zero,$t0	#Swap: finish -> start
    jal hanoiTower
   
    lw $ra,0($sp)
    lw $a0,4($sp)
    lw $a1,8($sp)
    lw $a2,12($sp)
    lw $a3,16($sp)
    addi $sp,$sp,20
    jr $ra
    
exit: