# Authors: Salvador Octavio Briones Martínez & Gustavo Adolfo Rueda Enríquez
.text
# Disk Number
addi $s0,$zero,3
main:
    ori $s1,$zero,0x1001
    sll $s1,$s1,16          #TowerA -> $s1 -> starts at 0x10010000
    ori $s2,$s1,0x20        #TowerB -> $s2 -> starts at 0x10010020
    ori $s3,$s1,0x40        #TowerC -> $s3 -> starts at 0x10010040
    add $t0,$zero,$s0

    for:
        beq $t0,$zero,end_for   # disks == 0?
        sw $t0,0($s1)           #Place a disk in Tower A 
        addi $s1,$s1,4          #Move the Tower A stack pointer one place forward.
        addi $t0,$t0,-1         #Decrease the next disk's number.
        j for
    end_for: 
     
    add $a0,$zero,$s0		#Load the number of disks. 		
    add $a1,$zero,$s1		#Load the Tower A's reference.
    add $a2,$zero,$s2		#Load the Tower B's reference.
    add $a3,$zero,$s3		#Load the Tower C's reference.
    addi $s4,$zero,1		#Load a number 1. (It will be used in the recursion).
    
    jal hanoiTower
    
    j exit
 
# This is a recursive function that does the  Hanoi's Towers algorithm.
# void hanoiTower(int disk, int **start, int **finish, int **spare)
# $a0 - disk - The disk's number [0,n].
# $a1 - start - It refers to the tower's top where the disk is.
# $a2 - spare - It refers to the auxiliary tower's top.
# $a3 - finish - It refers to the tower's top where the disk must end.
hanoiTower:
    bne $a0, $s4, recursion	#Stop condition: disk == 1?
	
    addi $a1,$a1,-4   #(*tower)--
    lw $t0,0($a1)     #int number = **tower	
    sw $zero, 0($a1)  #Free the old stack's top		
    sw $t0,0($a3)     #**tower = disk;		
    add $a3,$a3,4     #(*tower)++;
    
    jr $ra
	
recursion:
    addi $sp,$sp, -4    #Reserve stack.
    sw $ra,0($sp)       #Store $ra.
    
    addi $a0,$a0, -1    #disk - 1
    add $t0,$a2,$zero   #Back up the spare reference.	
    add $a2,$a3,$zero   #Swap: spare -> finish	
    add $a3,$t0,$zero   #Swap: finish -> spare	
    
    jal hanoiTower
    
    add $t0,$a2,$zero   #Back up the finish reference.
    add $a2,$a3,$zero   #Swap: finish -> spare
    add $a3,$t0,$zero   #Swap: spare -> finish
    
    addi $a1,$a1,-4     #(*tower)--
    lw $t0,0($a1)       #int number = **tower	
    sw $zero,0($a1)     #Free the old stack's top		
    sw $t0,0($a3)       #**tower = disk;		
    add $a3,$a3,4       #(*tower)++;	
    		
    add $t0,$a1,$zero   #Back up start reference
    add $a1,$a2,$zero   #Swap: start -> spare
    add $a2,$t0,$zero   #Swap: spare -> start
    
    jal hanoiTower
    
    add $t0,$a1,$zero   #Back up spare reference
    add $a1,$a2,$zero   #Swap: spare -> start
    add $a2,$t0,$zero   #Swap: start -> spare
    
    addi $a0, $a0, 1
    
    lw $ra,0($sp)       #Restore $ra.
    addi $sp,$sp,4      #Free stack.		
    
    jr $ra
exit: