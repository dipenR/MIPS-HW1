.data
ErrMsg: .asciiz "Invalid Argument"
WrongArgMsg: .asciiz "You must provide exactly two arguments"
WorkingMsg: .asciiz "This is working!"
EvenMsg: .asciiz "Even"
OddMsg: .asciiz "Odd"

arg1_addr : .word 0
arg2_addr : .word 0
num_args : .word 0

.text:
.globl main
main:
	sw $a0, num_args

	lw $t0, 0($a1)
	sw $t0, arg1_addr
	lw $s1, arg1_addr

	lw $t1, 4($a1)
	sw $t1, arg2_addr
	lw $s2, arg2_addr

# do not change any line of code above this section
# you can add code to the .data section

# num_Args: $a0
# arg1: $s1, arg2: $s2
start_coding_here:
#----------------------------------------------PART 1--------------------------------------------------
# 1. check if num_args - $a0 is 2
	li $t0, 2
	bne $a0, $t0, WAM

# 2. first char must be - O S T I E C X M - any number of chars can follow
	# extract first char from s1
	# check if it is in list of acpt chars

	# load the first byte (character into the save register, then compare it tot he letters required.
	lb $s1, 0($s1)

	li $t0, 'O'
	beq $s1, $t0, arg_two_check

	li $t0, 'S'
	beq $s1, $t0, arg_two_check

	li $t0, 'T'
	beq $s1, $t0, arg_two_check

	li $t0, 'I'
	beq $s1, $t0, arg_two_check

	li $t0, 'E'
	beq $s1, $t0, arg_two_check

	li $t0, 'C'
	beq $s1, $t0, arg_two_check

	li $t0, 'X'
	beq $s1, $t0, arg_two_check

	li $t0, 'M'
	beq $s1, $t0, arg_two_check

	j EM
# 3. length of second arg must be atleast 10 chars. if more trim.
arg_two_check:
	# move $s0, $t0 # save char 1 for later parts.
	move $t0, $s2 # create a copy of the pointer to arg2
	lb $t1, 0($t0) # load the first char 
	
	beqz $t1, EM # check if EOS, jump to invalid arg
	li $t2, '0' # first char must be 0
	bne $t1, $t2, EM # if not, error message
	
	addi $t0, $t0, 1 # next char
	lb $t1, 0($t0) # load this char
	li $t2, 'x' # this must be an x
	bne $t1, $t2, EM # if not, error message

	# next 8 characters must be [0-9] or [A-F]. If less than 8, error, if invalid char, error
	# if more than 8, trim.
	li $t1, 0 # load counter
	li $t3, 8 # load final length
	character_check_loop:
		beq $t1, $t3, end_character_check_loop # check if we have reached the 8 character limit.
		addi $t1, $t1, 1 # add to counter
		addi $t0, $t0, 1 # move to next pointer in string
		
		lb $t2, 0($t0) # load current byte
		beqz $t2, EM # check if we have reached EOS, if so, then <10 chars.

		li $t4, 48 # >0, EM
		blt $t2, $t4, EM
		li $t4, 57
		bgt $t2, $t4, not_digit # <9 means not in 0-9, not digit
		
		# now we have a digit, use $s1 to store this arg since $s0 already stores arg1
		# li $t4, 8 # counter gives us number of bytes to move by, to actually move,
		# sllv $s1, $s1, $t4 # shift to make room
		
		j character_check_loop # current char is number, move to next char

		not_digit:
			li $t4, 65 # 65 -- ASCII for A
			blt $t2, $t4, EM
			li $t4, 70 # 70 -- ASCII for F
			bgt $t2, $t4, EM

			j character_check_loop # between A-F move to next char	
	end_character_check_loop:	
#----------------------------------------------PART 2-------------------------------------------------
# $s0 stores arg 1
# useful masks:
# 	FC000000 -- 1111 1100 0000 0000 0000 0000 0000 0000 -- EXTRACTS FIRST 6 BITS
# 	3E000000 -- 0000 0011 1110 0000 0000 0000 0000 0000 --  EXTRACTS NEXT 5 BITS

#-----------------------------------------------LABELS---------------------------------------------------	
WAM:
	li $v0, 4
	la $a0, WrongArgMsg
	syscall
	j EOP
EM:
	li $v0, 4
	la $a0, ErrMsg
	syscall
	j EOP
TR:
	li $v0, 4
	la $a0, WorkingMsg
	syscall
	j EOP
EOP:
	li $v0, 10
	syscall

