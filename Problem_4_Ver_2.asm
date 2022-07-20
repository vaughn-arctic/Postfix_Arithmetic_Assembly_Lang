
# the pointer is being corrupted somewhere
# it prints the same value everytime




#################################################################################################################################
#
#	Jared Vaughn
#	javaughn2@alaska.edu
#	Programming Assignment 4
#	25 April 2022
#
#
#	Purpose: This program builds upon assignment 3, taking the properly formated postfix string and performing arithmetic on the 
#		values of the string by storing the values in the stack
#
#
#	Algorith: int p* = some address
#		  for (i in string) :
#			if isdigit(i):
#				p* += 4
#				store i on stack
#				
#
#			if isOperator(i)
#				get val_1 from stack
#				p* -= 4
#				get val_2 from stack
#				p* -= 4
#
#				perform operation (ex. val_1 + val_2 = val_3
#				p* += 4
#				store i on stack
#				
#	INPUTS: String - the Postfix arithmetic equation to be evaluated
#
#	OUTPUTS: There are no direct outputs, however the remaing value at the top of the stack should be the correct mathemetic value
#		to the postfix equation
#
####################################################################################################################################



	.data
prompt:            	.asciiz        "Enter postfix expression: "
enter:            	.asciiz        "You entered: "
continue:		.asciiz		"Enter another string? Press 1 for yes, 2 for no: "
newline:        	.asciiz        "\n"
string:           	.space        	40
ExtraWhitespace:	.asciiz		"SYNTAX ERROR: Expression contains extra whitespace"
InvalidCharacter:	.asciiz		"SYNTAX ERROR: Expression contains invalid characters"
InvalidAmount:		.asciiz		"OPERATOR ERROR: Number of operators exceed number of operands"
InvalidAmount2:		.asciiz		"OPERAND ERROR: Number of operands exceed number of operators"
stackEmpty1:		.asciiz		"Stack empty"
stackFull1:		.asciiz		"Stack full"
zeroDivide1:		.asciiz		"Divide by zero!"
S:			.word		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0



    	.text					#
main: 

la    	$s2, S + -4				# create pointer to the stack
#sub	$s2, $s2, 4				# 
						#
la    	$a0, prompt    				# load print promt
li    	$v0, 4                    		# print prompt statement
syscall						#
    						#
jal   	getString                		# call getString function
la    	$a0, enter    				#
li    	$v0, 4                    		# print prompt statement
syscall						#
la	$t3, string				#
jal	putString				#
#jal    	start		         		# call Syntax function
#bne	$v0, 1, errorContinue			#
#jal	stack_underflow				# call stack underflow function
jal	getNumber
jal	errorContinue				#
						#
errorContinue:					#
la	$a0, continue				#
li	$v0, 4					#
syscall						#
						#
li    	$v0, 5                  		# cin >> input
syscall						#
						#
move    $t2, $v0               			# storing input in a register
bne   $t2, 1, terminate				#
						#
j	main					#
      						#
getString:					#
    li    $v0, 8                    		# cin >> input
    						#
    la    $a0, string                		# allocating space
    li    $a1, 40                   		# length of string allowed
    move    $t3, $a0               		# storing input in a register 
    syscall					#
						#
putString:    					#
la	$a0, ($t3)				#
    li    $v0, 4                    		# cout << input
    syscall					#
    						#
    la    $a0, newline				#
	li    $v0, 4                		# cout << endl
	syscall					#
    jr	$ra					#
						#
    						#
start:  					#
la 	$a0, string				#
li	$v0, 1					# bool = 1
j 	syntax					#
						#
	   					#
syntax: 					#
lb	$s0, 0($a0)				# buffer[i]
lb	$s1, 1($a0)				# buffer[i+1]
						#
beq	$s0, 43, Symbol				# if buffer[i] == '+'
beq	$s0, 45, Symbol				# if buffer[i] == '-'
beq	$s0, 42, Symbol				# if buffer[i] == '*'
beq	$s0, 47, Symbol				# if buffer[i] == '/'
beq	$s0, 32, extraSpace			# if buffer[i] == ' '
beq	$s0, 10, returnTrue			# end of string that meets all parameters
						#
blt	$s0, '0', InvalidChar			# if buffer[i] < '0'
bgt	$s0, '9', InvalidChar			#if  buffer[i] > '9'
						#
addi	$a0, $a0, 1				#increment i
j	syntax					#return
						#
						#
Symbol:						#
add	$a0, $a0, 1				# increment i
j	syntax					# return loop
						#
						#
InvalidChar:					#
la 	$t3, InvalidCharacter			#
j	putString				#
						#
la	$a0, newline				#
li	$v0, 4					#cout << endl
syscall						#
						#
li 	$v0, 0					# return false in $v0
jr	$ra					# exit program
						#
						#
extraSpace: 					#
						#
addi	$a0, $a0, 1				# increment i
bne	$s1, 32, syntax				# if buffer[i + 1] != ' '
						#
la 	$t3, ExtraWhitespace			#
j	putString				#
						#
la	$a0, newline				#
li	$v0, 4					#cout << endl
syscall						#
						#
li	$v0, 0					# return false in $v0
jr	$ra					# exit program
						#
returnTrue: 					#
li	$v0, 1					# return true in $v0
						#
						#
stack_underflow:				#
						#
la   	$a0, string        			# load in string
li    	$t0, 0                    		# digit_count = 0
li    	$t1, 0               			# symbol_count = 0
j     	checks					# begin checking values
						#
						#
checks:						#
lb    	$s0, 0($a0)           			# buffer[i]
lb    	$s1, 1($a0)            			# buffer[i+1]
						#
beq    	$s0, '1', Digit				#
beq    	$s0, '2', Digit				#
beq    	$s0, '3', Digit				#
beq    	$s0, '4', Digit				# if buffer[i] is digit
beq    	$s0, '5', Digit				#
beq    	$s0, '6', Digit				# jump to Digit eval
beq    	$s0, '7', Digit				#
beq    	$s0, '8', Digit				#
beq    	$s0, '9', Digit				#
beq    	$s0, '0', Digit				#
						#
beq    	$s0, 43, Symbol_Under           	# 
beq    	$s0, 42, Symbol_Under           	# if buffer[i] == '*'
beq    	$s0, 47, Symbol_Under           	# 	jumpt to symbol eval
						#
beq    	$s0, 45, Negative        		# if buffer[i] == '-'
						#	jump to negative/minus eval
						#
beq	$s0, 10, CheckValid			# if end of string and meets paramters
						#		
addi    $a0, $a0, 1            			# i++
j    	checks                  		# loop checks
						#
Digit:						#
addi    $a0, $a0, 1           			# i++ first
beq	$s1, 10, DigitCount			#
bne     $s1, 32, checks       			# if [i+1] is digit, continue
addi    $t0, $t0, 1           			# digit_count++
ble     $t0, $t1, Invalid      			# if digit_count <= symbol_count {
                                       	 	#	invald
                                        	#       }
						#
j    checks                   			# loop checks
						#
DigitCount:					#
addi    $t0, $t0, 1           			# digit_count++
ble     $t0, $t1, Invalid      			# if digit_count <= symbol_count {
                                       	 	#	invald
                                        	#       }
						#
j    checks                   			# loop checks
						#
Symbol_Under:					#
addi    $t1, $t1, 1            			# symbol_count++
addi    $a0, $a0, 1            			# i++
ble     $t0, $t1, Invalid      			# if digit_count <= symbol_count {
                                        	#	invald
                                        	#        }
j       checks           			# loop checks
						#
						#
Negative:					#
beq	$s1, 10, Symbol_Under			#
beq    $s1, 32, Symbol_Under           		#  if buffer[i + 1] == ' '
						#  	jump to symbol eval
addi    $a0, $a0, 1            			# i++
j    checks           				# loop checks
						#
Invalid:					#
						#
la     $t3, InvalidAmount			#
j	putString				#
						#
la    $a0, newline				#
li    $v0, 4               			# cout << endl
syscall						#
						#
li    $v0, 0					#     
		             			# return false in $v0  		
jr	$ra                  			# exit program
						#
						#
CheckValid: 					#
ble	$t0, $t1, Invalid			#
						#
sub	$t2, $t0, $t1				#
bge	$t2, 2, InvalidNum			#
li	$v0, 1					# return true in $v0
jr	$ra					#
						#
						#
						#
InvalidNum: 					#
						#
la     $t3, InvalidAmount2			#
j	putString				#
						#
la    $a0, newline				#
li    $v0, 4                			# cout << endl
syscall						#
						#
li    $v0, 0            			# return false in $v0
jr	$ra           				# exit program
						#
						#
terminate:					#
li      $v0, 10              			# terminate program run and
syscall                     			# Exit 














getNumber:
li	$t4, 0					# number = 0
li	$t6, 0
lb	$t5, 0($a0)				# string[i]

loop:
beq	$t5, 32, Item				# string[i] == ' '
beq	$t5, 10, printStack				# string[i] == '\0'

beq	$t5, 43, EMPTY				# if buffer[i] == '+'
beq	$t5, 42, EMPTY				# if buffer[i] == '*'
beq	$t5, 42, EMPTY				# if buffer[i] == '*'
beq	$t5, 45, EMPTY				# if buffer[i] == '-'

addi 	$t5, $t5, -48   			#converts t5's ascii value to dec value
mul 	$t6, $t6, 10   		       		# number *= 10
add 	$t6, $t6, $t5    			# number += string[t5]-'0'
addi 	$a0, $a0, 1     			# i++
j loop                 				# return loop
			#
						#
Item:						#
						#
addi	$t4, $t6, 0				#
j	Full					# number equals loop result
						#
						#
EMPTY: 						#
la	$t1, S					#
subi	$t1, $t1, 4				#	if P <= stack addres - 4
sle    	$v0, $s2, $t1				#		return true ( to $v0
bnez	$v0, errorContinue
j 	pop					#
	 					#
stackEmpty:					#
la    	$a0, stackEmpty1   			# load empty promt
li    	$v0, 4                    		# print empty statement
syscall						#
j 	errorContinue
						#
Full:						#
la 	$t1, S					#	if P >= stack address + 76
addi	$t1, $t1, 76 				#		return true
sge 	$v0, $s2, $t1 				# 
bnez	$v0, stackFull
j 	push				#
						#
stackFull: 					#
la    	$a0, stackFull1   			# load full promt
li    	$v0, 4                    		# print full statement
syscall						#
						#
j	errorContinue					#						#
						#
push:						#
					# Call Full
bnez 	$v0, stackFull				# if true -> print stack full msg

la 	$s2, 4($s2)												#
add 	$s2, $s2, 4				# move pointer						
sw 	$s2, 0($t4)				# stores ITEM at P
j 	loop					# return to loop 
						#
						#
pop:						#
						#					# call Empty
bnez	$v0, stackEmpty				# if true -> print stack empty msg
						#
lw	$t7, 0($s2)				# load num to $t7
la 	$a3, 0($s2)
li	$a3, 0					# remove num from stack
la	$s2, -4($s2)
#sub	$s2, $s2, 4				# decrement pointer
lb	$t8, ($s2)				# load next num to $t8
la 	$a3, 0($s2)
li	$a3, 0					# remove num from stack
la	$s2, -4($s2)				# decrement pointer	
						#
						
add    	$a0, $t7, 0    				# load print promt
li    	$v0, 1                    		# print prompt statement
syscall						#
add    	$a0, $t8, 0    				# load print promt
li    	$v0, 1                    		# print prompt statement
syscall		



beq	$t3, 43, caseAdd			# if buffer[i] == '+'						#
beq	$t3, 45, caseSub			# if buffer[i] == '-'						#
beq	$t3, 42, caseMul			# if buffer[i] == '*'						#
beq	$t3, 47, caseDiv			# if buffer[i] == '/' 	
						#
DivideZero:					#
						#
la    	$a0, zeroDivide1   			# load print promt
li    	$v0, 4                    		# print prompt statement
syscall						#
						#
						#
			#
						#
						#
						#
						#
caseAdd:					#
add	$t4, $t7, $t8				# add 2 values popped of stack

j	push					# save to $t4 and push back to stack
						#
						#
						#
caseSub:					#
						#	
sub	 $t4, $t8, $t7				# sub 2 values 
j	push					# back to stack
						#
caseMul:					#
mul	$t4, $t7, $t8				#
j	push					#
						#
caseDiv:					#
beqz 	$t7, DivideZero				#
div 	$s3, $t8, $t7				#
j 	push					#
						#


printStack: 
						# load print promt
lw	$a0, ($s2)

li    	$v0, 1                    		# print prompt statement
syscall			
j 	terminate			#
