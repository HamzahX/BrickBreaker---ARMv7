@ Code section  
.section .text

.global initialization
initialization: 
	push	{lr}
	
	bl	getGpioPtr		//Get GPIO base address
	ldr	r1, =baseAddress	//load address to "baseAddress" into r1	
	str	r0, [r1]		//store returned value from getGpioPtr in "baseAddress"
	
	mov	r0, #9			//
	mov	r1, #1			//
	bl	initGPIO		//set latch line to output

	mov	r0, #10			//
	mov	r1, #0			//
	bl	initGPIO		//set data line to input
	
	mov	r0, #11			//
	mov	r1, #1			//
	bl	initGPIO		//set clock line to output

	pop	{lr}
	mov	pc, lr

.global SNESInput			//SNES Input method for continous input (holding down a button)
SNESInput:
	push	{lr}
	
	bl	readSNES		//read which button was pressed
	bl	readInput		//print appropriate message

	pop	{lr}
	mov	pc, lr

.global SNESInput2			//SNES Input method for one-time input (press and release)
SNESInput2: 
	push	{lr}
	
	buttons	.req  r10		

.delayInput:				//loop to stop program from contantly registering button presses

	bl	readSNES		//read which button was pressed	

	mov	buttons, r0		//move returned data to buttons register

	ldr	r0, =#50000		//
	bl	delayMicroseconds	//wait 50000 microseconds
	bl	readSNES		//read pressed button again
	cmp	buttons, r0		//compare first pressed button with second one
	beq	.delayInput		//if equal, branch back to delayInput
	cmp	r0, r4			//compare second pressed button to 0xffff (no buttons pressed)
	beq	.delayInput		//if equal, branch back to delayInput
		
	bl	readInput		//print appropriate message
	
	.unreq	buttons

	pop	{lr}
	mov	pc, lr


//Funcion which initializes a GPIO line. The function is general for lines 9, 10 and 11
//Accepts 2 paramaters:
//   1) Line Number (r0)
//   2) Function Code (r1)
//Returns nothing
initGPIO:
	push 	{r4, r5, r6, r7, lr}	//Push registers
	mov	r4, r0			//move argument 1 to a safer register
	mov	r5, r1			//move argument 2 to a safer register	

	ldr	r0, =baseAddress	//load "baseAddress" to r0
	ldr	r0, [r0]		//load value stored in 'baseAddress' to r0

	cmp	r4, #9			//compare r4 (line number) to 9
	bne	.GPFSEL1		//if pin# != 9, branch to GPFSEL1.

.GPFSEL0:				//else
	mov	r6, #9			//Store the least significant digit of the pin# in r6
	b 	.next			//branch unconditionally to next to skip over GPFSEL1

.GPFSEL1:					
	add	r0, r0, #4		//add 4 to base address to access GPFSEL1
	sub	r6, r4, #10		//subtract 10 from r4 (pin#) to get least significant digit. Stored in r6

.next:
	ldr	r1, [r0]		//copy GPFSEL0/GPFSEL1 into r1
	
	mov	r2, #7			//move 0111 to r2
	
	mov	r7, #3			//move 3 to r7 in preparation for multiplication on the next line
	mul	r4, r6, r7		//multipliy least significant digit(r6) by 3 to determine index of 1st bit for given line number
	lsl	r2, r4			//lsl r2 by index of first bit for given pin number
	bic	r1, r2			//clear correct bits
	
	lsl	r5, r4			//lsl r5 (function code) by index of first bit for given line number
	orr	r1, r5			//set correct pin in r1
	str	r1, [r0]		//write back to GPFSEL1/GPFSEL0

	pop	{r4, r5, r6, r7, lr}	//pop registers
	mov	pc, lr			//return


//Function which writes to GPIO latch line
//Accepts 1 parameter:
//	1) r0: Bit to be written (0,1)
//Returns nothing
writeGPIOLatch:
	push	{lr}
	
	mov	r1, #9			//pin #9 = latch line
	ldr	r2, =baseAddress	//
	ldr	r2, [r2]		//load base GPIO address to r2
	mov	r3, #1			//
	lsl	r3, r1			//align bit for pin #9

	teq	r0, #0			//compare r0 to 0

	streq	r3, [r2, #40]		//if equal, GPCLR0
	strne	r3, [r2, #28]		//else, GPLSSET0
	
	pop	{lr}
	mov	pc, lr			//return


//Function which writes to GPIO clock line
//Accepts 1 parameter
//	1) r0: Bit to be written (0,1)
//Returns nothing
writeGPIOClock:
	push	{lr}

	mov	r1, #11			//pin #11 = clock line
	ldr	r2, =baseAddress	//
	ldr	r2, [r2]		//load base GPIO address to r2
	mov	r3, #1			//
	lsl	r3, r1			//align bit for pin #11

	teq	r0, #0			//compare r0 to 0
		
	streq	r3, [r2, #40]		//if equal, GPCLR0
	strne	r3, [r2, #28]		//else, GPSET0
	
	pop	{lr}
	mov	pc, lr			//return

//Function which reads from the GPIO Data line
//Takes no paramters
//Returns 1 value
//	1) 0 or 1
readGPIOData:
	push	{lr}
	
	mov	r0, #10			//pin #10 = data line
	ldr	r2, =baseAddress	//
	ldr	r2, [r2]		//load base GPIO address to r2
	ldr	r1, [r2, #52]		//load GPLEV0 to r1
	mov	r3, #1			//
	lsl	r3, r0			//align pin 10 bit

	and	r1, r3			//use a bitmask to mask out all other bits
	teq	r1, #0			//compare r1 to 0

	moveq	r0, #0			//if equal, move 0 to r0 (return register)
	movne	r0, #1			//else, move 1 to r0 (return register)
	
	pop	{lr}
	mov	pc, lr			//return


//Function which reads from SNES controller
//Takes no paramaters
//Returns 1 value:
//	1) Register containing data about which buttons were pressed
readSNES:
	push	{r8, r9, lr}		//push registers
	i_r	.req  r9		
	
	mov	r0, #1			//
	bl	writeGPIOClock		//write 1 to the clock line	
	
	mov	r0, #1			//
	bl	writeGPIOLatch		//write 1 to the latch line

	mov	r0, #12			//
	bl	delayMicroseconds	//wait for 12 microseconds

	mov	r0, #0			//
	bl	writeGPIOLatch		//write 0 to the latch line

	mov	i_r, #0			//initialize the counter to 0
	mov	r8, #0x0000		//move 0 to the register which will hold button sampled data

.loopTop:

	mov	r0, #100		//
	bl	delayMicroseconds	//wait for 100 seconds

	mov	r0, #0			//
	bl	writeGPIOClock		//write 0 to the clock line

	mov	r0, #100		//
	bl	delayMicroseconds	//wait for 100 seconds	

	bl	readGPIOData		//read bit i

	lsl	r8, #1			//
	orr	r8, r0			//buttons[i] = returned value from readGPIOData
	
	mov	r0, #1			//
	bl	writeGPIOClock		//write 1 to the clock line

	add	i_r, i_r, #1		//increment i (loop counter)
	
	cmp	i_r, #16		//if i is less than 16
	blt	.loopTop		//branch back to the top of the loop

	mov	r0, r8			//move register containing sampled button data to r0
	
	.unreq	i_r

	pop	{r8, r9, lr}		//return, and pop used 
	mov	pc, lr


//Function which changes buttonPressed global variable based on which button was pressed
//Takes 1 paramater:
//	1) r0: register containing data of pressed buttons
//Returns nothing	
readInput:
	push	{r8, lr}		//push registers
	mov	r8, r0			//move paramater value to a safer register

.pressedB:
	ldr	r0, =#0b0111111111111111//
	cmp	r8, r0			//checks if B was pressed
	bne	.pressedY		//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #1
	str	r1, [r0]		//store 1 to buttonPressed

	b	.end			//branch to end label to return from function
	
.pressedY:
	ldr	r0, =#0b1011111111111111//
	cmp	r8, r0			//check if Y was pressed
	bne	.pressedSelect		//if not, check next button
		
	ldr	r0, =buttonPressed	//else,
	mov	r1, #2
	str	r1, [r0]		//store 2 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedSelect:
	ldr	r0, =#0b1101111111111111//
	cmp	r8, r0			//check if SELECT was pressed
	bne	.pressedStart		//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #3
	str	r1, [r0]		//store 3 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedStart:
	ldr	r0, =#0b1110111111111111//
	cmp	r8, r0			//check if START was pressed
	bne	.pressedUp		//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #4
	str	r1, [r0]		//store 4 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedUp:
	ldr	r0, =#0b1111011111111111//
	cmp	r8, r0			//check if UP was pressed
	bne	.pressedDown		//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #5
	str	r1, [r0]		//store 5 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedDown:
	ldr	r0, =#0b1111101111111111//
	cmp	r8, r0			//check if DOWN was pressed
	bne	.pressedLeft		//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #6
	str	r1, [r0]		//store 6 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedLeft:
	ldr	r0, =#0b1111110111111111//
	cmp	r8, r0			//check if LEFT was pressed
	bne	.pressedRight		//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #7
	str	r1, [r0]		//store 200 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedRight:
	ldr	r0, =#0b1111111011111111//
	cmp	r8, r0			//check if RIGHT was pressed
	bne	.pressedA		//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #8
	str	r1, [r0]		//store 200 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedA:
	ldr	r0, =#0b1111111101111111//
	cmp	r8, r0			//check if A was pressed
	bne	.pressedX		//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #9
	str	r1, [r0]		//store 9 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedX:
	ldr	r0, =#0b1111111110111111//
	cmp	r8, r0			//check if X was pressed
	bne	.pressedLT		//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #10
	str	r1, [r0]		//store 10 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedLT:
	ldr	r0, =#0b1111111111011111//
	cmp	r8, r0			//check if LEFT TRIGGER was pressed
	bne	.pressedRT		//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #7
	str	r1, [r0]		//store 7 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedRT:
	ldr	r0, =#0b1111111111101111//
	cmp	r8, r0			//check if RIGHT TRIGGER was pressed
	bne	.pressedLTAndA	//if not, check next button

	ldr	r0, =buttonPressed	//else,
	mov	r1, #8
	str	r1, [r0]		//store 8 to buttonPressed
	
	b	.end			//branch to end label to return from function

.pressedLTAndA:
	ldr	r0, =#0b1111111101011111//	
	cmp	r8, r0			//check if LEFT and A are being pressed together
	bne	.pressedRTAndA	//if not, check next button
	
	ldr	r0, =buttonPressed	//else,
	mov	r1, #13
	str	r1, [r0]		//store 13 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedRTAndA:
	ldr	r0, =#0b1111111101101111
	cmp	r8, r0			//check if RIGHT and A are being pressed together
	bne	.pressedLeftAndA	//if not, branch to end label to return from function
	
	ldr	r0, =buttonPressed	//else,
	mov	r1, #14
	str	r1, [r0]		//store 14 to buttonPressed

	b	.end

.pressedLeftAndA:
	ldr	r0, =#0b1111110101111111//	
	cmp	r8, r0			//check if LEFT and A are being pressed together
	bne	.pressedRightAndA	//if not, check next button
	
	ldr	r0, =buttonPressed	//else,
	mov	r1, #13
	str	r1, [r0]		//store 13 to buttonPressed

	b	.end			//branch to end label to return from function

.pressedRightAndA:
	ldr	r0, =#0b1111111001111111
	cmp	r8, r0			//check if RIGHT and A are being pressed together
	bne	.end			//if not, branch to end label to return from function
	
	ldr	r0, =buttonPressed	//else,
	mov	r1, #14
	str	r1, [r0]		//store 14 to buttonPressed
	
.end:
	pop	{r8, lr}		//pop registers and return
	mov	pc, lr


@ Data section
.section .data

baseAddress:
.int	0

.global buttonPressed
buttonPressed:
.int	0
