.section .text

.global main
main:
	ldr r0, =fmtInput
	ldr r1, =num
	bl scanf
	
	ldr r0, =test
	ldr r1, =num
	ldr r1, [r1]
	bl printf


	@ ask for frame buffer information
	ldr 	r0, =frameBufferInfo 	//frame buffer information structure
	bl	initFbInfo		//initialize frame buffer info



	bl	initialization		//initialize SNES lines
menuBackground:




	mov	r0, #0			//set the x co-ordinate
	mov	r1, #0			//set the y co-ordinate
	bl	drawMenu		//draw the menu background

menu1:		
	mov	r0, #462		//set the x co-ordinate
	mov	r1, #400		//set the y co-ordinate
	bl	drawNewGameSelected	//draw menu buttons (new game selected)

menu1Loop:
	bl	SNESInput2		//get controller input
	ldr	r0, =buttonPressed	//
	ldr	r0, [r0]		//load button pressed into r0
		
	cmp	r0, #6			//if user presses down on d-pad
	beq	menu2			//branch to other menu screen

	cmp	r0, #9			//if user presses A
	beq	resetGrid		//branch to resetGrid to start a new game
	
	b	menu1Loop		//if user presses neither, ask for input again

menu2:
	mov	r0, #462		//set the x co-ordinate
	mov	r1, #400		//set the y co-ordinate
	bl	drawQuitSelected	//draw menu buttons (quit selected)
	
menu2Loop:
	bl	SNESInput2		//get controller input
	ldr	r0, =buttonPressed	//
	ldr	r0, [r0]		//load button pressed into r0
	
	cmp	r0, #5			//if user presses up on the d-pad
	beq	menu1			//branch to other menu screen
		
	cmp	r0, #9			//if user presses A
	beq	exitGame		//branch to exit game

	b	menu2Loop		//if user presses neither, ask for input again

resetGrid:				//used to return a game grid to its initial state after the game is restarted
	ldr	r8, =newGrid		//load base address to new grid in r8
	ldr	r9, =gridState		//load base address to game grid in r9
	
	ldr	r1, [r8, r0]		//load entry from new grid
	str	r1, [r9, r0]		//and store it into game grid

	add	r0, #4			//add 4 to r0 to access next grid entries
	ldr	r7, =#2520
	cmp	r0, r7			//compare to 2 (num of bricks * 4)
	ble	resetGrid		//if <=, branch back to resetGrid to change next grid brick

renewScoreAndLives:
	bl	randomNumber		//call randomNumber to generate a random number
	bl	setValuePackPositions	//call set valuePackPositions with r0 as an argument

	ldr	r3, =livesState		//load base address of livesState
	mov	r4, #4			//
	str	r4, [r3]		//set lives to 4

	ldr	r3, =scoreState		//load base address of scoreState
	mov	r4, #0			//
	str	r4, [r3]		//set first digit of score to 0
	str	r4, [r3, #4]		//set second digit of score to 0
	str	r4, [r3, #8]		//set third digit of score to 0

	ldr	r3, =numericalScore	//load base address of numericalScore
	mov	r4, #0			//
	str	r4, [r3]		//set it to 0

	ldr	r3, =loseCondition	//load base address of loseCondition
	mov	r4, #0			//
	str	r4, [r3]		//set loseCondition to 0 (false)

	ldr	r3, =winCondition	//load base address of winCondition
	mov	r4, #0			//
	str	r4, [r3]		//set winCondition to 0 (false)

.global	resetGame
resetGame:
	ldr	r7, =initialBallState	//reset ball and paddle positions
	ldr	r3, [r7]		//original ball x position
	ldr	r4, [r7, #4]		//original ball y position	
	ldr	r5, [r7, #8]		//original ball angle
	ldr	r6, [r7, #12]		//original ball direction
	ldr	r8, =ballState		
	str	r3, [r8]		//store original x position
	str	r4, [r8, #4]		//store original y position
	str	r5, [r8, #8]		//store original ball angle
	str	r6, [r8, #12]		//store original ball direction

	ldr	r5, =initialPaddleState
	ldr	r3, [r5]		//original paddle x position
	ldr	r4, [r5, #4]		//original paddle y position
	ldr	r7, [r5, #12]		//original paddle x max
	ldr	r8, [r5, #16]		//original paddle size flag
	ldr	r9, [r5, #20]		//original catch ball flag
	ldr	r6, =paddleState	
	str	r3, [r6]		//store original paddle x position
	str	r4, [r6, #4]		//store original paddle y position
	str	r7, [r6, #12]		//store original paddle x max
	mov	r8, #0
	str	r8, [r6, #16]		//store paddle size flag to false
	str	r8, [r6, #20]		//store catch ball flag to false
	str	r8, [r6, #24]		//store brick power flag to false

	mov	r0, #1
	bl	replaceBottomBricks

	ldr	r3, =livesState		//
	ldr	r4, [r3]		//load number of lives into r4
	sub	r4, #1			//subtract 1 from number of lives
	cmp	r4, #1			//if new number of lives is >= 1
	bge	continue		//branch to continue

	ldr	r3, =loseCondition	//else,
	mov	r4, #1			//
	str	r4, [r3]		//set the lose condition to 1 (true)
	
	b	drawGame		//branch to drawGame
	
continue:
	str	r4, [r3]		//store number of lives in livesState

drawGame:		
	mov	r0, #0			//
	mov	r1, #30			//
	bl	drawGrid		//draw the entire game grid
	bl	drawPaddle		//draw the paddle in its starting position
	bl	drawBall		//draw the ball in its starting position

	bl	drawScore		//draw the score
	bl	drawLives		//draw the number of lives

.global state1				//state where ball is attached to the paddle
state1:
	ldr	r3, =loseCondition	//
	ldr	r3, [r3]		//check lose condition
	cmp	r3, #1			//if == 1 (true)
	beq	gameOver		//branch to gameOver

	ldr	r1, =buttonPressed	
	mov	r2, #0		
	str	r2, [r1]		//zero the button pressed global variable
	bl	SNESInput		//ask for user input

	bl	updatePaddleAndBallState //update ball and paddle state simultaeneously. 

	ldr	r0, =valuePaddleState	
	mov	r1, #0
	bl	checkValuePaddle

	ldr	r0, =valueBallState
	mov	r1, #1
	bl	checkValuePaddle

	ldr	r0, =valuePaddleState2
	mov	r1, #0
	bl	checkValuePaddle

	ldr	r0, =valueBallState2
	mov	r1, #1
	bl	checkValuePaddle

	ldr	r0, =valueBrickState
	mov	r1, #2
	bl	checkValuePaddle

	bl	drawPaddle		//redraw paddle
	bl	drawBall		//redraw ball
	
	bl	SNESInput		//ask for user input
	ldr	r1, =buttonPressed	//
	ldr	r1, [r1]		//load button pressed
	
	cmp	r1, #1			//if user presses B
	beq	firstStart		//branch to firstStart 
	
	b	state1			//otherwise, branch back to top of state1

pauseReturn:
	mov	r0, #2			//
	mov	r1, #30			//
	bl	drawGrid		//redraw the grid, except for the top 2 rows
	bl	drawPaddle		//draw the paddle
	bl	drawBall		//draw the ball
	
	ldr	r0, =#1000000
	bl	delayMicroseconds	//delay for one second before restarting the game after a pause
	
	b	state2			//branch to state 2 (main game loop)

firstStart:
	mov	r0, #0			//
	mov	r1, #30			//
	bl	drawGrid		//draw the entire grid
	bl	drawPaddle		//draw the paddle
	bl	drawBall		//draw the ball

//MAIN GAME LOOP! 	
state2:					//state where ball is *NOT* attached to the paddle
	ldr	r1, =winCondition	//
	ldr	r1, [r1]		//
	cmp	r1, #1			//compare gameWon flag to 1 (true)
	beq	gameWon			//if true, branch to gameWon
	
	bl	drawScore		//draw the score
	bl	drawLives		//draw lives

	ldr	r1, =buttonPressed	
	mov	r2, #0
	str	r2, [r1]		//zero the button pressed global variable

	bl	SNESInput		//ask for user input
	ldr	r0, =buttonPressed
	ldr	r0, [r0]

	cmp	r0, #4			//if user presses start
	beq	pause			//branch to pause
	
	bl	updateBallState		//update the ball logic
	bl	updatePaddleState	//update the paddle logic
	bl	drawBall		//draw the ball
	bl	drawPaddle		//draw the paddle

	// CHeck if the bricks contianint the vlaue packs have benn borken and move them down the screen
	ldr	r0, =valuePaddleState
	mov	r1, #0
	bl	checkValuePaddle

	ldr	r0, =valueBallState
	mov	r1, #1
	bl	checkValuePaddle

	ldr	r0, =valuePaddleState2
	mov	r1, #0
	bl	checkValuePaddle

	ldr	r0, =valueBallState2
	mov	r1, #1
	bl	checkValuePaddle

	ldr	r0, =valueBrickState
	mov	r1, #2
	bl	checkValuePaddle

	b	state2			//branch back to the top of the game loop
//END OF MAIN GAME LOOP!

pause:	
	mov	r0, #462		//set x co-ordinate
	mov	r1, #400		//set y co-ordinate	
	bl	drawNewGameSelected	//draw pause menu buttons

pauseLoop:
	ldr	r1, =buttonPressed	
	mov	r2, #0
	str	r2, [r1]		//zero the button pressed global variable
	
	bl	SNESInput2		//ask for user input
	ldr	r0, =buttonPressed
	ldr	r0, [r0]
	
	cmp	r0, #6			//if user presses DOWN on the d-pad
	beq	pause2			//branch to second pause screen

	cmp	r0, #9			//if user presses A
	beq	resetGrid		//branch to reset grid to restart the game

	cmp	r0, #4			//if user presses START
	beq	pauseReturn		//branch to pauseReturn to return to the current game

	b	pauseLoop		//if user presses none of the above, branch back to the top of the pause loop

pause2:
	mov	r0, #462		//set x co-ordinate
	mov	r1, #400		//set y co-ordinate
	bl	drawQuitSelected	//draw pause menu buttons
	
pause2Loop:
	ldr	r1, =buttonPressed
	mov	r2, #0
	str	r2, [r1]		//zero the button pressed global variable
	
	bl	SNESInput2		//ask for user input
	ldr	r0, =buttonPressed
	ldr	r0, [r0]
	
	cmp	r0, #5			//if user presses UP on the d-pad
	beq	pause			//branch to first pause screen
	
	cmp	r0, #9			//if user presses A
	beq	menuBackground		//branch to exitGame

	cmp	r0, #4			//if user presses START
	beq	pauseReturn		//branch to pauseReturn to return to the current game

	b	pause2Loop		//if user presses none of the above, branch back to the top of the pause2 loop

gameOver:
	mov	r0, #0			//set x co-ordinate
	mov	r1, #0			//set y co-ordinate	
	bl	drawGameOver		//draw 'game over' screen

gameOverLoop:
	ldr	r1, =buttonPressed
	mov	r2, #0
	str	r2, [r1]		//zero the button pressed global variable
	
	bl	SNESInput2		//ask for user input
	ldr	r0, =buttonPressed	
	ldr	r0, [r0]
	
	cmp	r0, #0			//if user presses anything
	bne	menuBackground		//return to the main menu

	b	gameOverLoop		//otherwise, branch to top of gameOver loop

gameWon:
	mov	r0, #0			//set x co-ordinate
	mov	r1, #0			//set y co-ordinate
	bl	drawGameWon		//draw 'game won' screen

gameWonLoop:
	ldr	r1, =buttonPressed	
	mov	r2, #0
	str	r2, [r1]		//zero the button pressed global variable
	
	bl	SNESInput2		
	ldr	r0, =buttonPressed
	ldr	r0, [r0]		//ask for user input
	
	cmp	r0, #0			//if user presses anything
	bne	menuBackground		//return to main menu

	b	gameWonLoop		//otherwise, branch to top of gameWon loop

exitGame:
	bl	clearScreen		//clear the screen
	
	haltLoop$:
	b	haltLoop$

.section .data
test:	.asciz	"Output = %d\n"

num: 	.word 0
fmtInput: .asciz "%d"
