#Authors: Salvador Octavio Briones Martínez & Gustavo Adolfo Rueda Enríquez
.text
addi $s0,$zero,5
main: 
    # Tower's creation
    # TowerA -> $s1 -> starts at 0x10010000
    # TowerB -> $s2 -> starts at 0x10010020
    # TowerC -> $s3 -> starts at 0x10010040
    addi $s1,$zero,0x1001
    sll $s1,$s1,16		#$s1 = 0x10010000
    ori $s2,$s1,0x20		#$s2 = 0x10010020
    ori $s3,$s1,0x40		#$s3 = 0x10010040
    add $t0,$zero,$s0
      
    for:
        beq $t0,$zero,end_for
        sw $t0,0($s1)		#place a disk in Tower A 
        addi $s1,$s1,4		#move the Tower A stack pointer one place forward.
        addi $t0,$t0,-1
        j for
    end_for: 
     
    add $a0,$zero,$s0   
    add $a1,$zero,$s1
    add $a2,$zero,$s2
    add $a3,$zero,$s3
    addi $s4,$zero,1
    
    jal hanoiTower
    
    j exit
 
# This is a recursive function that does the  Hanoi's Towers algorithm.
# void hanoiTower(int disk, int **start, int **finish, int **spare)
# $a0 - disk - The disk's number [0,n].
# $a1 - start - It refers to the tower's top where the disk is.
# $a2 - spare - It refers to the auxiliary tower's top.
# $a3 - finish - It refers to the tower's top where the disk must end.
hanoiTower:
	bne $a0, $s4, recursion		# n = 1
	
	addi $a1, $a1, -4	#(*tower)--
	lw $t0, 0($a1)		#int number = **tower	
	sw $zero, 0($a1)	#Free the old stack's top		
	sw $t0, 0($a3)		#**tower = disk;		
	add $a3, $a3, 4		#(*tower)++;
			
	jr $ra
	
recursion:
	addi $sp, $sp, -8	#Reserve stack.
	sw $ra, 0($sp)		#Store $ra.
	sw $a0, 4($sp)		#Store disk number.
	
	addi $a0, $a0, -1	# disk - 1
	add $t0, $a2, $zero	#Back up the spare reference.	
	add $a2, $a3, $zero	#Swap: spare -> finish	
	add $a3, $t0, $zero	#Swap: finish -> spare	
	
	jal hanoiTower
	
	add $t0, $a2, $zero	#Back up the finish reference.
	add $a2, $a3, $zero	#Swap: finish -> spare
	add $a3, $t0, $zero	#Swap: spare -> finish
	
	lw $ra, 0($sp)		#Restore $ra.
	lw $a0, 4($sp)		#Restore disk last value.
	addi $sp, $sp, 8	#Free stack.
	
	addi $a1, $a1, -4	#(*tower)--
	lw $t0, 0($a1)		#int number = **tower	
	sw $zero, 0($a1)	#Free the old stack's top		
	sw $t0, 0($a3)		#**tower = disk;		
	add $a3, $a3, 4		#(*tower)++;	
	
	addi $sp, $sp, -8	#Reserve stack.
	sw $ra, 0($sp)		#Store $ra.
	sw $a0, 4($sp)		#Store disk number.
		
	addi $a0, $a0, -1	# disk -1
	add $t0, $a1, $zero	#Back up start reference
	add $a1, $a2, $zero	#Swap: start -> spare
	add $a2, $t0, $zero	#Swap:spare -> start
	
	jal hanoiTower
	
	add $t0, $a1, $zero	#Back up spare reference
	add $a1, $a2, $zero	#Swap: spare -> start
	add $a2, $t0, $zero	#Swap: start -> spare
	
	lw $ra, 0($sp)		#Restore $ra.
	lw $a0, 4($sp)		#Restore disk last value.
	addi $sp, $sp, 8	#Free stack.		
	
	jr $ra
exit:
