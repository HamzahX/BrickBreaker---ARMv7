.section .text

//Taken from lecture slides
//Function which draws a pixel to the screen at position (x,y)
//Takes 2 arguments:
//	1) r0: x position
//	2) r1: y position
//	3) r2: color of the pixel
//Returns nothing
drawPixel:
	push	{r4, r5, lr}

	offset	.req	r4

	ldr	r5, =frameBufferInfo	

	// offset = (y * width) + x
	ldr	r3, [r5, #4]		// r3 = width
	mul	r1, r3
	add	offset,	r0, r1
	
	// offset *= 4 (32 bits per pixel/8 = 4 bytes per pixel)
	lsl	offset, #2

	// store the colour (word) at frame buffer pointer + offset
	ldr	r0, [r5]		// r0 = frame buffer pointer
	str	r2, [r0, offset]

	.unreq	offset

	pop	{r4, r5, lr}
	mov	pc, lr

//Function which draws a specified image to the screen at position (x,y)
//Takes 3 arguments:
//	1) r0: x-coordinate
//	2) r1: y-coordinate
//	2) r2: address of the image to be drawn
//Returns nothing	
drawImage:
	push 	{r5-r10, lr}
	
	drawnX	.req	r5
	drawnY	.req	r6
	width	.req 	r7
	height	.req 	r8
	image	.req	r9

	mov	r10, r0			//store initial x co-ordinate in r10
	mov	image, r2		//store image address in image register

	mov	drawnX, #0		//x pixels drawn
	mov	drawnY, #0		//y pixels drawn
	ldr	width, =imageWidth	//
	ldr	width, [width]		//load image width
	ldr	height, =imageHeight	//
	ldr	height, [height]	//load image height
	
outerLoop:
	mov	drawnX, #0		//reset number of X pixels drawn
	mov	r0, r10			//reset x-coordinate to initial value
	add	r1, r1, #1		//add one to y-coordinate
	add	drawnY, drawnY, #1	//add one to y pixels drawn
	
	cmp	drawnY, height		//compare y pixels drawn to the height of the image
	bgt	done			//if > branch to done

drawLoop:
	cmp	drawnX, width		//compare x pixels drawn to width
	bge	outerLoop		//If >= branch back outerLoop

	ldr	r2, [image], #4		//load a byte from the ascii representation of the image

	push	{r0-r2}				
	bl	drawPixel		//draw pixel in the specified place
	pop	{r0-r2}

	add	drawnX, drawnX, #1	//increment x pixels drawn
	add	r0, r0, #1		//increment x-coordinate

	b	drawLoop		//branch to draw loop

done:
	.unreq	drawnX
	.unreq	drawnY
	.unreq	width
	.unreq	height
	.unreq 	image

	pop	{r5-r10, lr}		
	mov	pc, lr

//Function that clears the entire game screen
//Takes no arguments
//Returns nothing
.global clearScreen
clearScreen:
	push	{r4, lr}

	mov	r0, #0			//x pixels drawn			
	mov	r1, #0			//y pixels drawn
	ldr	r2, =0xFFFFFF		//set r2 to black

	add	r3, r0, #1344		//final x co-ordinate
	add	r4, r1, #960		//final	y co-ordinate

clearLoop:
	cmp	r0, r3			//compare x pixels drawn to final x co-ordinate
	bge	clearNext		//if >= branch to clearNext
	
	push	{r0-r4}
	bl	drawPixel		//draw a black pixel
	pop	{r0-r4}

	add	r0, #1			//increment x pixels drawn
	b	clearLoop		//branch to clearLoop

clearNext:
	sub	r0, #1344		//reset x co-ordinate
	add	r1, #1			//increment y pixels drawn
	cmp	r1, r4			//compare y pixels drawn to final y co-ordinate

	ble	clearLoop		//if <=, branch to clearLoop

	pop	{r4, lr}
	mov	pc, lr

//Function which draws main menu background image
//Takes 2 arguments:
//	1) r0: x-coordinate of the background image
//	2) r1: y-coordinate of the background image
//Returns nothing
.global drawMenu
drawMenu:
	push	{lr}
 
	ldr	r2, =imageWidth		//
	mov	r3, #1344		//
	str	r3, [r2]		//change imageWidth global variable

	ldr	r2, =imageHeight	//
	mov	r3, #960		//
	str	r3, [r2]		//change imageHeight global variable

	ldr	r2, =mainMenu		//load address of main menu background image
	
	bl	drawImage		//call drawImage
	
	pop	{lr}
	mov	pc, lr

.global drawLevelSelectBackground
drawLevelSelectBackground:
	push	{lr}
 
	ldr	r2, =imageWidth		//
	mov	r3, #1344		//
	str	r3, [r2]		//change imageWidth global variable

	ldr	r2, =imageHeight	//
	mov	r3, #960		//
	str	r3, [r2]		//change imageHeight global variable

	ldr	r2, =levelBackground	//load address of main menu background image
	
	bl	drawImage		//call drawImage
	
	pop	{lr}
	mov	pc, lr


//Function which draws the game over screen
//Takes 2 arguments:
//	1) r0: x-coordinate of the game over image
//	2) r1: y-coordinate of the game over image
//Returns nothing
.global drawGameOver
drawGameOver:
	push	{r4, r5, lr}
 
	ldr	r4, =imageWidth		//
	mov	r5, #1344		//
	str	r5, [r4]		//change imageWidth global variable

	ldr	r4, =imageHeight	//
	mov	r5, #960		//
	str	r5, [r4]		//change imageHeight global variable
	
	ldr	r2, =gameOver
	
	bl	drawImage		//call drawImage
	
	pop	{r4, r5, lr}
	mov	pc, lr

//Function which draws the value pack for the paddle power up
//Takes 2 arguments:
//	1) r0: x-coordinate of the top left corner of the value pack
//	2) r1: y-coordinate of the top left corner of the value pack
// 	3) r2: value pack to be drawn
//Returns nothing
.global drawValuePack
drawValuePack:
	push	{r4, lr}

	mov	r4, r2			//store r2 in r4
	
	ldr	r2, =imageWidth		//
	mov	r3, #32			//
	str	r3, [r2]		//set image width

	ldr	r2, =imageHeight	//
	mov	r3, #18			//
	str	r3, [r2]		//set image height

	cmp	r4, #0			//if r4 == 0
	beq	drawValuePaddle		//draw 'extend paddle' value pack
	cmp	r4, #1			//if r4 == 1
	beq	drawValueBall		//draw 'catch ball' value pack
	cmp	r4, #2			//if r4 == 2
	beq	drawValueBrick		//draw 'brick layer' value pack (NOT USED IN ACTUAL GAME)
	ldr	r2, =valuePackImage	//if r4 is none of the above, draw a generic value pack (ALSO NOT USED IN ACTUAL GAME)
	b	contDrawValuePack	

drawValuePaddle:
	ldr	r2, =valuePaddleImage	//load address of 'extend paddle' value pack image
	b	contDrawValuePack	//branch over

drawValueBall:
	ldr	r2, =valueBallImage	//load address of 'catch ball' value pack image
	b	contDrawValuePack	//branch over

drawValueBrick:
	ldr	r2, =valueBrickImage	//load address of 'brick layer' value pack image
	b	contDrawValuePack	//branch over
	
contDrawValuePack:
	bl	drawImage		//call draw image

	pop	{r4, lr}
	mov	pc, lr

//Function which draws the game won screen
//Takes 2 arguments:
//	1) r0: x-coordinate of the game won image
//	2) r1: y-coordinate of the game won image
//Returns nothing
.global drawGameWon
drawGameWon:
	push	{r4, r5, lr}
 
	ldr	r4, =imageWidth		//
	mov	r5, #1344		//
	str	r5, [r4]		//change imageWidth global variable

	ldr	r4, =imageHeight	//
	mov	r5, #960		//
	str	r5, [r4]		//change imageHeight global variable
	
	ldr	r2, =gameWon		//load address of gameWon image
	
	bl	drawImage		//call drawImage
	
	pop	{r4, r5, lr}
	mov	pc, lr

//Taken from tutorial 8 code (Hayden Kroepfl)
//Function which draws a specified Number
//Takes 3 arguments
//	1) r0: digit to be drawn (0 to 9)
//	2) r1: x co-oridnate to draw number
//	3) r2: y co-ordinate to draw number
//Returns nothing
.global drawNumber
drawNumber:
	push	{r4-r10, lr}

	chAdr	.req	r4		//
	px	.req	r5		//
	py	.req	r6		//
	row	.req	r7		//
	mask	.req	r8		//name commonly used registers

	mov	r9, r1			// 
	mov	r10, r2			//store r1 and r2 in safer registers

	ldr	chAdr, =font		//load the address of the font map
	add	r0, r0, #'0'		//calculate ASCII value of digit to be drawn
	add	chAdr,	r0, lsl #4	//char address = font base + (char * 16)

	mov	py, r9			//init the Y coordinate (pixel coordinate)

charLoop$:
	mov	px, r10			//init the X coordinate

	mov	mask, #0x01		//set the bitmask to 1 in the LSB

	ldrb	row, [chAdr], #1	//load the row byte, post increment chAdr

rowLoop$:
	tst	row, mask		//test row byte against the bitmask
	beq	noPixel$

	mov	r0, px			// 
	mov	r1, py
	mov	r2, #0x00FFFFFF		//load white into r2
	bl	drawPixel		//draw white pixel at (px, py)

noPixel$:
	add	px, #1			//increment x coordinate by 1
	lsl	mask, #1		//shift bitmask left by 1

	tst	mask, #0x100		//test if the bitmask has shifted 8 times (test 9th bit)
	beq	rowLoop$

	add	py, #1			//increment y coordinate by 1

	tst	chAdr, #0xF
	bne	charLoop$		//loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr			//
	.unreq	px			//
	.unreq	py			//
	.unreq	row			//
	.unreq	mask			//un-name registers

	pop	{r4-r10, lr}
	mov	pc, lr

//Function which draws the score to the game screen
//Takes no arguments
//Returns nothing	                              
.global	drawScore
drawScore:
	push	{r4, lr}		//
		
	ldr	r4, =scoreState		//
	ldr	r4, [r4]		//load hundreds digit of score
	mov	r0, r4			//move loaded digit into r0
	mov	r1, #10			//set x co-ordinate to draw first digit
	mov	r2, #210		//set y co-ordinate to draw first digit
	bl	drawNumber		//call drawNumber

	ldr	r4, =scoreState		// 
	ldr	r4, [r4, #4]		//load tens digit of score
	mov	r0, r4			//move loaded digit into r0
	mov	r1, #10			//set x co-ordinate to draw second digit 
	mov	r2, #219		//set y co-ordinate to draw second digit
	bl	drawNumber		//call drawNumber

	ldr	r4, =scoreState		//
	ldr	r4, [r4, #8]		//load ones digit of score
	mov	r0, r4			//move loaded digit into r0
	mov	r1, #10			//set x co-ordinate to draw second digit 	
	mov	r2, #228		//set y co-ordinate to draw second digit
	bl	drawNumber		//call drawNumber

	pop	{r4, lr}
	mov	pc, lr

//Function which draws the number of lives to the game screen
//Takes no arguments
//Returns nothing
.global	drawLives
drawLives:
	push	{r4, lr}

	ldr	r4, =livesState		// 
	ldr	r4, [r4]		//load number of lives into r4
	mov	r0, r4			//move loaded number into r0
	mov	r1, #10			//set x co-ordinate to draw number
	mov	r2, #1114		//set y co-ordinate to draw number 
	bl	drawNumber		//call drawNumber

	pop	{r4, lr}
	mov	pc, lr

//Function which draws the menu options (with new game selected and quit game unselected)
//Takes 2 arguments
//		1) r0: x-coordinate of top menu button
//		2) r1: y-coordinate of bottom menu button
//Returns nothing
.global drawNewGameSelected
drawNewGameSelected:
	push	{lr}
	
	ldr	r2, =imageWidth		//
	mov	r3, #420		//
	str	r3, [r2]		//set image width

	ldr	r2, =imageHeight	//
	mov	r3, #100		//
	str	r3, [r2]		//set image height
	
	ldr	r2, =newGameSelected	//load address of menu button (new game selected)

	bl	drawImage		//call draw image
	
	add	r1, #75			//add 75 to x co-ordinate

	ldr	r2, =imageWidth		//
	mov	r3, #420		//
	str	r3, [r2]		//set image width
	
	ldr	r2, =imageHeight	//
	mov	r3, #100		//
	str	r3, [r2]		//set image height

	ldr	r2, =quit		//load address of menu button (quit unselected)
	
	bl	drawImage		//call draw image

	pop	{lr}
	mov	pc, lr

.global drawLevelMenu1
drawLevelMenu1:
	
	push	{lr}
	
	ldr	r2, =imageWidth		//
	mov	r3, #420		//
	str	r3, [r2]		//set image width

	ldr	r2, =imageHeight	//
	mov	r3, #450		//
	str	r3, [r2]		//set image height
	
	ldr	r2, =level1		//load address of menu button (new game selected)

	bl	drawImage		//call draw image

	pop	{lr}
	mov	pc, lr

.global drawLevelMenu2
drawLevelMenu2:
	
	push	{lr}

	ldr	r2, =imageWidth		//
	mov	r3, #420		//
	str	r3, [r2]		//set image width

	ldr	r2, =imageHeight	//
	mov	r3, #450		//
	str	r3, [r2]		//set image height
	
	ldr	r2, =level2		//load address of menu button (new game selected)

	bl	drawImage		//call draw image

	pop	{lr}
	mov	pc, lr

.global drawLevelMenu3
drawLevelMenu3:
	
	push	{lr}

	ldr	r2, =imageWidth		//
	mov	r3, #420		//
	str	r3, [r2]		//set image width

	ldr	r2, =imageHeight	//
	mov	r3, #450		//
	str	r3, [r2]		//set image height
	
	ldr	r2, =level3		//load address of menu button (new game selected)

	bl	drawImage		//call draw image

	pop	{lr}
	mov	pc, lr

//Function which draws the menu options (with new game unselected and quit game selected)
//Takes 2 arguments
//		1) r0: x-coordinate of top menu button
//		2) r1: y-coordinate of bottom menu button
//Returns nothing
.global drawQuitSelected
drawQuitSelected:
	push	{lr}
	
	ldr	r2, =imageWidth		//
	mov	r3, #420		//
	str	r3, [r2]		//set image width

	ldr	r2, =imageHeight	//
	mov	r3, #100		//
	str	r3, [r2]		//set image height

	ldr	r2, =newGame		//load address of menu button (new game unselected)

	bl	drawImage		//call draw image
		
	add	r1, #75			//add 75 to x co-ordinate

	ldr	r2, =imageWidth		//
	mov	r3, #420		//
	str	r3, [r2]		//set image width

	ldr	r2, =imageHeight	//
	mov	r3, #100		//
	str	r3, [r2]		//set image height

	ldr	r2, =quitSelected	//load address of menu button (quit selected)
	
	bl	drawImage		//call draw image

	pop	{lr}
	mov	pc, lr

//Function which draws a temporary brick. Used to cover tracks of paddle movement
//Takes 2 arguments
//	1) r0: x co-ordinate of the top left corner of the brick
//	2) r1: y co-ordinate of the top left corner of the brick
//Returns nothing
.global drawTempBrick
drawTempBrick:
	push	{lr}
	
	ldr	r2, =imageWidth		//
	mov	r3, #1			//
	str	r3, [r2]		//set image width
		
	ldr	r2, =imageHeight	//
	mov	r3, #32			//
	str	r3, [r2]		//set image height

	ldr	r2, =tempBrick		//load address of tempBrick image

	bl	drawImage		//call draw image

	pop	{lr}
	mov	pc, lr

//Function which draws a brick
//Takes 3 arguments
//	1) r0: x co-ordinate of the top left corner of the brick
//	2) r1: y co-ordinate of the top left corner of the brick
//	3) r2: the address of the image of the brick to be drawn
//Returns nothing
.global drawBrickImage
drawBrickImage:
	push	{r4, r5, lr}

	ldr	r4, =imageWidth		//
	mov	r5, #64			//
	str	r5, [r4]		//set image width
	
	ldr	r4, =imageHeight	//
	mov	r5, #32			//
	str	r5, [r4]		//set image height
		
	bl	drawImage		//call draw image

DBReturn:
	pop	{r4, r5, lr}
	mov	pc, lr

//Function which draws the paddle.
//Draws both normal paddle and extended paddle
//Takes no arguments
//Returns nothing
.global drawPaddle
drawPaddle:
	push	{r4-r5, lr}
	
	ldr	r2, =imageWidth		//	
	mov	r3, #128		//
	str	r3, [r2]		//set image width for normal paddle

	ldr	r2, =imageHeight	//
	mov	r3, #32			//
	str	r3, [r2]		//set image height

	ldr	r4, =paddleState	//load base address of the paddleState
	ldr	r0, [r4]		//load paddle x position into r0
	ldr	r1, [r4, #4]		//load paddle y position into r1

	ldr	r5, [r4, #16]		//
	cmp	r5, #1			//check if extend paddle value pack has been activated
	beq	drawLargePaddle		//if so, then branch to drawLargePaddle
	ldr	r2, =paddleImage	//otherwise, load address of normal paddle image 

	bl	drawImage		//call draw image

	add	r0, #128		//add 128 to paddle x position (to get x position of the right side of the paddle)
	b	contDrawPaddle		//branch over drawLargePaddle
	
drawLargePaddle:
	ldr	r2, =imageWidth		//
	mov	r3, #256		//
	str	r3, [r2]		//set image width for extended paddle
	ldr	r2, =paddleExtendedImage//load address of extended paddle image
	bl	drawImage		//call draw image

	add	r0, #256		//add 256 to paddle x position (to get x position of the right side of the paddle)

contDrawPaddle:
	
	mov	r1, #832		//set y co-ordinate
	bl	drawTempBrick		//draw a temp brick on the right side of the paddle
		
	add	r0, #1			//move right by one pixel
	mov	r1, #832
	bl	drawTempBrick		//draw another temp brick
	
	add	r0, #1			
	mov	r1, #832
	bl	drawTempBrick		//repeat above

	add	r0, #1			
	mov	r1, #832
	bl	drawTempBrick		//repeat above


	cmp	r5, #1			//check if extend paddle value pack has been activated
	beq	drawLargePaddle2	//if so, then branch to drawLargePaddle2
	sub	r0, #131		//if not, sub 131 from paddle x position (to get x position of the left side of the paddle)
	b	contDrawPaddle2		//branch over drawLargePaddle2
	
drawLargePaddle2:
	ldr	r5, =#259		//sub 259 from paddle x position (to get x position of the left side of the paddle)
	sub	r0, r5

contDrawPaddle2:
	
	mov	r1, #832		//set y co-ordinate
	bl	drawTempBrick		//draw a temp brick on the left side of the paddle

	sub	r0, #1			//move left by one pixel
	mov	r1, #832
	bl	drawTempBrick		//draw another temp brick
	
	sub	r0, #1
	mov	r1, #832
	bl	drawTempBrick		//repeat above

	sub	r0, #1
	mov	r1, #832
	bl	drawTempBrick		//repeat above

	pop	{r4-r5, lr}
	mov	pc, lr

//Function which draws the ball
//Takes 2 arguments
//	1) r0: x co-ordinate of the top left corner of the ball
//	2) r1: y co-ordinate of the top left corner of the ball
//Returns nothing
.global drawBall
drawBall:
	push	{lr}
	
	ldr	r2, =imageWidth		//
	mov	r3, #16			//
	str	r3, [r2]		//set image width

	ldr	r2, =imageHeight	//
	mov	r3, #16			//
	str	r3, [r2]		//set image height

	ldr	r2, =ballImage		//load address of ball image

	ldr	r4, =ballState		//load base address
	ldr	r0, [r4]		//get x position of ball
	ldr	r1, [r4, #4]		//get y position of ball

	bl	drawImage		//call drawImage

	pop	{lr}
	mov	pc, lr

//Function which draws the game grid (or part of it)
//Takes 2 arguments
//	1) r0: the first row to draw
//	2) r1: the last row to draw
//Returns nothing
.global drawGrid
drawGrid:
	push	{r4-r10, lr}	
	
	columns		.req	r4
	rows		.req	r5
	i_r		.req	r6
	j_r		.req	r7
	baseAddress	.req	r8

	ldr	baseAddress, =gridState			//load the base address of the grid to be drawn
	
	mov	i_r, r0					//initialize I to be the first row we neeed to draw			
	mov	rows, r1				//rows in the last row to be drawn	
	mov	columns, #21				//columns is the total number of columns, always 21

	drawGridRow:
		mov	j_r, #0				//initialize counter for inner loop
		drawBrick:		
			mov	r0, #64			//move 64 to r0. used for multiplication later	
			mov	r1, #32			//move 32 to r0. used for multiplication later
			
			mul	r0, j_r			//calculate pixel position for gridState[i][j]
			mul 	r1, i_r			//calculate pixel position for gridState[i][j]
				
			mul	r9, columns, i_r	//
			add	r9, r9, j_r		//
			lsl	r9, #2			//calculate offset to load gridState[i][j]

			ldr	r10, [baseAddress, r9]	//r10 = gridState[i][j]
				
checkBorder:		cmp	r10, #0			//	
			bne	checkBackground		//	
			ldr	r2, =borderBrick	//
			bl	drawBrickImage		//if r10 is a 0, draw a border brick
			b	incrementJ		//increment J

checkBackground:	cmp	r10, #1			//
			bne	checkPurple		//
			ldr	r2, =backgroundBrick	//
			bl	drawBrickImage		//if r10 is a 1, draw a background brick
			b	incrementJ		//increment J

checkPurple:		cmp	r10, #2			//
			bne	checkBlue		//
			ldr	r2, =purpleBrick	//
			bl	drawBrickImage		//if r10 is a 2, draw a purple brick
			b	incrementJ		//increment J

checkBlue:		cmp	r10, #3			//
			bne	checkGreen		//
			ldr	r2, =blueBrick		//
			bl	drawBrickImage		//if r10 is a 3, draw a blue brick
			b	incrementJ		//increment J
			
checkGreen:		cmp	r10, #4			//
			bne	checkOrange		//
			ldr	r2, =greenBrick		//
			bl	drawBrickImage		//if r10 is a 4, draw a green brick
			b	incrementJ

checkOrange:		cmp	r10, #5			//
			bne	checkRed		//
			ldr	r2, =orangeBrick	//
			bl	drawBrickImage		//if r10 is a 5, draw a orange brick
			b	incrementJ		//increment J

checkRed:		cmp	r10, #6			//
			bne	checkScore		//
			ldr	r2, =redBrick		//
			bl	drawBrickImage		////if r10 is a 6, draw a red brick
			b	incrementJ		//increment J

checkScore:		cmp	r10, #97		//
			bne	checkLives		//
			ldr	r2, =scoreBrick		//
			bl	drawBrickImage		//if r10 is a 97, draw a border brick with a score label
			b	incrementJ		//increment J

checkLives:		cmp	r10, #98		//
			bne	incrementJ		//
			ldr	r2, =livesBrick		//
			bl	drawBrickImage		//if r10 is a 98, draw a border brick with a score label
			b	incrementJ		//increment J

			
incrementJ:		add	j_r, #1			//j++
			cmp	j_r, columns		//compare j to total number of columns
			blt	drawBrick		//if <, branch back to the top of drawBrick

		add	i_r, #1			//i++
		cmp	i_r, rows		//compare i to total number of rows
		blt	drawGridRow		//if <, branch back to the top of drawGridRow
end:
	.unreq	columns	
	.unreq	rows
	.unreq	i_r
	.unreq	j_r	
	.unreq	baseAddress

	pop	{r4-r10, lr}
	mov	pc, lr

.section .data
//global variable for image width. Is changed before drawImage is called
imageWidth:
	.int	0

//global variable for image height. Is changed before drawImage is called
imageHeight:
	.int	0

.align 4
//font information
font:	.incbin "font.bin"
