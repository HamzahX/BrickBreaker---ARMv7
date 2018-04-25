@Code section
.section .text

//Function which updates the position of the paddle based on user input
//Takes no parameters
//Returns nothing
.global updatePaddleState
updatePaddleState:

	paddle		.req	r4
	paddleX 	.req	r5
	paddleXMax	.req	r6
	button		.req	r7
	paddleXMin	.req	r8

	push	{r4-r8, lr}
	
	ldr	paddle, =paddleState		//
	ldr	paddleX, [paddle]		// Load X position of vlaue
	ldr	paddleXMin, [paddle, #8]
	ldr	paddleXMax, [paddle, #12]	// Load the Max position the paddle X can be

	ldr	button, =buttonPressed	//
	ldr	button, [button]		//load the button(s) pressed by the user into r3

moveLeft:
	cmp	button, #7		//check if the user pressed left on the D-Pad		
	bne	moveRight		//if not, branch to next check
	
	sub	paddleX, #1		//if yes, subtract 1 from the x position of the paddle to move left
	cmp	paddleX, paddleXMin	//compare new x-position to lowest x-position allowed (width of left border)
	bge	move			//if greater than or equal to, branch to move to store new x-position in paddleState

	add	paddleX, #1		//otherwise, revert to old x-position
	b	end			//return

moveRight:
	cmp	button, #8		//check if the user pressed right on the D-Pad
	bne	moveLeftFast		//if not, branch to next check

	add	paddleX, #1		//if yes, add 1 to the x position of the paddle to move right	//
	cmp	paddleX, paddleXMax	//compare new x-position to highest x-position allowed (width of game screen - (width of right border + width of paddle))
	ble	move			//if less than or equal to, branch to move to store new x-position in paddleState

	sub	paddleX, #1		//otherwise, revert to old x-position
	b	end			//return

moveLeftFast:
	cmp	button, #13		//check if the user pressed left+A on the D-Pad		
	bne	moveRightFast		//if not, branch to next check
	
	sub	paddleX, #3		//if yes, subtract 3 from the x position of the paddle to move left
	cmp	paddleX, paddleXMin	//compare new x-position to lowest x-position allowed (left border)
	bge	move			//if greater than or equal to, branch to move to store new x-position in paddleState

	add	paddleX, #3		//otherwise, revert to old x-position
	b	end			//return

moveRightFast:
	cmp	button, #14		//check if the user pressed right+A on the D-Pad
	bne	end			//if not, branch to next check

	add	paddleX, #3		//if yes, add 3 to the x position of the paddle to move right
	cmp	paddleX, paddleXMax	//compare new x-position to highest x-position allowed (right border)
	ble	move			//if less than or equal to, branch to move to store new x-position in paddleState

	sub	paddleX, #3		//otherwise, revert to old x-position
	b	end			//return
	
move:	
	str	paddleX, [paddle]	//store the nex x-position of the paddle in paddleState

end:
	.unreq	button
	.unreq	paddleX
	.unreq	paddle
	.unreq	paddleXMax
	.unreq	paddleXMin

	pop	{r4-r8, lr}		//pop registers and
	mov	pc, lr			//return

//Updates the ball and paddles position based on user input before the releasing the ball
// No input or output registers
.global updatePaddleAndBallState
updatePaddleAndBallState:

	paddleX .req	r2
	button	.req	r3

	push	{r4-r6, lr}
	
	ldr	r1, =paddleState	//
	ldr	r2, [r1]		//load the x-position of the paddle into r2

	ldr	r4, =buttonPressed	//
	ldr	r3, [r4]		//load the button(s) pressed by the user into r3

	ldr	r5, =ballState
	ldr	r6, [r5]

moveLeftOG:
	cmp	r3, #7			//check if the user pressed left on the D-Pad		
	bne	moveRightOG		//if not, branch to next check
	
	sub	r2, #1			//if yes, subtract 1 from the x position of the paddle to move left
	sub	r6, #1
	cmp	r2, #67			//compare new x-position to lowest x-position allowed (width of left border)
	bge	moveOG			//if greater than or equal to, branch to move to store new x-position in paddleState

	add	r2, #1			//otherwise, revert to old x-position
	b	endOG			//return

moveRightOG:
	cmp	r3, #8
	bne	moveOG
	add	r2, #1			//if yes, add 1 to the x position of the paddle to move right
	add	r6, #1
	ldr	r3, [r1, #12]		//
	cmp	r2, r3			//compare new x-position to highest x-position allowed (width of game screen - (width of right border + width of paddle))
	ble	moveOG			//if less than or equal to, branch to move to store new x-position in paddleState

	sub	r2, #1			//otherwise, revert to old x-position
	b	endOG			//return
	
moveOG:	
	str	r2, [r1]		//store the nex x-position of the paddle in paddleState
	str	r6, [r5]

endOG:
	.unreq	button
	.unreq	paddleX

	pop	{r4-r6, lr}		//pop registers and
	mov	pc, lr			//return

//Updates the position, direction and collisions with the paddle and bricks
//Takes no parameters
//Returns Nothing
.global updateBallState
updateBallState:
	push 	{lr}


//////////// MOVE THE BALL AND CHECK COLLISIONS///////////////////
	bl	moveBall
	bl	checkPaddleCollision
	bl	checkBallOutOfBounds


///////////////////// PRINT OUT VALUE PACK ORIGIANL LOCATIONS ON THE SCREEN////////////////////////////
	ldr	r3, =valuePaddleState
	mov	r2, #0
	ldr	r0, [r3]
	ldr	r1, [r3, #8]
//	bl	drawValuePack

	ldr	r3, =valueBallState
	mov	r2, #1
	ldr	r0, [r3]
	ldr	r1, [r3, #8]
//	bl	drawValuePack

	ldr	r3, =valuePaddleState2
	mov	r2, #0
	ldr	r0, [r3]
	ldr	r1, [r3, #8]
//	bl	drawValuePack

	ldr	r3, =valueBallState2
	mov	r2, #1
	ldr	r0, [r3]
	ldr	r1, [r3, #8]
//	bl	drawValuePack

	ldr	r3, =valueBrickState
	mov	r2, #2
	ldr	r0, [r3]
	ldr	r1, [r3, #8]
//	bl	drawValuePack
	
	pop 	{lr}
	mov	pc, lr



// Checks if the ball has gone out of bounds ant the bottom of the screen
// IF so, reset the game
// NO input or ouptut
checkBallOutOfBounds:
	push {lr}

	ldr	r0, =ballState
	ldr	r0, [r0, #4]	// Y coord of ball
	ldr	r1, =#930	// Check if the ball has hit the bottom of the screen
	cmp	r0, r1		// If so reset the game
	bgt	resetGame	// Otherwise continue the game
	

	pop {lr}
	mov	pc,lr

// Check if the ball has collided with the paddle
// and changes the direction and angle of the ball according to hwere it hit
// NO input or ouptut
checkPaddleCollision:
	push {r4-r10,lr}

	
	ball	.req	r4
	ballX	.req	r5
	ballY	.req	r6
	angle	.req	r7
	dir	.req	r8
	paddleX	.req	r9

	ldr	r4, =ballState
	ldr	ballX, [r4]		// X coord of ball
	ldr	ballY, [r4, #4]		// Y coord of ball
	ldr	angle, [r4, #8]		// Angle of ball
	ldr	dir, [r4, #12]		// Direction of ball

	ldr	r10, =paddleState
	ldr	paddleX, [r10]		// X coord of paddle

	cmp	ballY, #816		// Check if the ball is at the correct Y vlaue to hit the ball
	beq	checkPaddle		// If the ball is on the paddle Y coord see if it is in X bounds
	ldr	r0, =#815		// Checks 3 pixels total for the ball
	cmp	ballY, r0		// Gives user a littler room to get the padle in position
	beq	checkPaddle
	ldr	r0, =#817
	cmp	ballY, r0
	beq	checkPaddle
	b	endPaddleCollision	// Otherwise stop checking paddle collision


checkPaddle:
	add	r0, ballX, #16		// Far right X coord of ball
	cmp	r0, paddleX		// Check if the right side of the ball is in contanct with the left side of the paddle
	blt	endPaddleCollision	// If not stop collision detection
	ldr	r2, [r10, #16]		// Load if the paddle is large
checkLeftPaddle:
	cmp	r2, #1			// Check if the paddle is extended
	beq	checkLeftLarge		// IF yes check paddle extended width
	add	r1, paddleX, #29	// Right Bound of 45 degree angle on left side of paddle
	b	checkLeft		// Check the left bound of the paddle to ball

checkLeftLarge:
	add	r1, paddleX, #57	// Right bound of 45 degree angle on left side of extended paddle

checkLeft:
	add	r0, ballX, #8		// Get the center coord of ball
	
	cmp	r0, r1			// Check if the center of the ball has passed the point to hit at a 60 degree angle
	bgt	checkMiddlePaddle	// Check if middle of ball has passed the left red part of the paddle
	mov	angle, #45		// Hit left red area of paddle so bounce at 45
	b	changeDirectionFromPaddle // in contact change the direction so the ball

checkMiddlePaddle:
	cmp	r2, #1			// Check if the paddle is extended
	beq	checkMiddleLarge
	add	r1, paddleX, #99	// Right Bound of 60 degree bounce on right side of paddle
	b	checkMiddle
checkMiddleLarge:
	add	r1, paddleX, #199	// RIght bound of 60 degree bounce on right side of extended paddle
checkMiddle:
	cmp	r0, r1			// Check if center of ball is within thre bounds of the middle ball
	bgt	checkRightPaddle	// If not check if the ball is on the right side of the paddle
 	mov	angle, #60		// Hit in middle of paddle so bounce at 60
	b	changeDirectionFromPaddle	// In contact with ball so change direction

checkRightPaddle:
	cmp	r2, #1			// Check if the paddle is in extended state
	beq	checkRightLarge		
	add	r1, paddleX, #128	// Right Bound of the entire paddle
	b	checkRight
checkRightLarge:
	add	r1, paddleX, #256	// Right Bound of the entire extended paddle
checkRight:
	
	cmp	r0, r1			// Check if the left X coord of the ball is past the right bound of the paddle
	bgt	endPaddleCollision	// If so stop collision detection
	mov	angle, #45		// Hit right red area so bounce at 45
	b	changeDirectionFromPaddle // Change the direction fo the ball

changeDirectionFromPaddle:
	cmp	dir, #2			
	beq	moveLeftFromPaddle	// IF the ball is going down to the left go up and to the left
	CMP	dir, #3
	bne	endPaddleCollision	// IF the ball is not going down to the right leave the function
	mov	dir, #0			// OTehr wise go up and to the right
	b	checkBallValuePack	// Check if the paddle has the catch ball value pack

moveLeftFromPaddle:
	mov 	dir, #1
	b	checkBallValuePack

checkBallValuePack:
	str	angle, [ball, #8]		// Store new angle into ball
	str	dir, [ball, #12]		// Store direction into ball

	ldr	r9, [r10, #20]		// Load in catch ball value pack flag
	cmp	r9, #1			// Check if it is enabled 
	beq	catchTheBall		
	b	endPaddleCollision	// IF not stop collision
catchTheBall:
	b	state1			/// OTherwise hold the ball unitl b is pressed

endPaddleCollision:	
	.unreq	ball
	.unreq	ballX
	.unreq	ballY
	.unreq	angle
	.unreq	dir
	.unreq	paddleX

	pop	{r4-r10,lr}
	mov	pc, lr

//////////////////////////////////////////////////////////////////////////////////////
/////////////////Move the Ball in the Current Direction///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// No input or output
moveBall:
	push {r4-r8,lr}

	ballX	.req	r5
	ballY	.req	r6
	angle	.req	r7
	dir	.req	r8

	ldr	r4, =ballState
	ldr	ballX, [r4]		// X coord of ball
	ldr	ballY, [r4, #4]		// Y coord of ball
	ldr	angle, [r4, #8]		// Angle of ball
	ldr	dir, [r4, #12]		// Direction of ball

checkTopRight:
	cmp	dir, #0			// check if ball is going top right
	bne	checkTopLeft		// If not check top left
	cmp	angle, #45		// Check the angle
	beq	topRight45		// IF equal to 45 move at 45 degree angle
	mov	r0, #0			// Move at 60
	bl	moveBallTopRight	// Move and draw the ball
	b	endBallMovement		// Stop ball movement function
topRight45:
	mov	r0, #1			// MOve at 45
	bl	moveBallTopRight	// Move and draw the ball
	b	endBallMovement		// Check if ball has hit the paddle

checkTopLeft:
	cmp	dir, #1			// Check if ball is going top left
	bne	checkBottomLeft		// If not check bottom left
	cmp	angle, #45
	beq	topLeft45
	mov	r0, #0			// MOve at 60
	bl	moveBallTopLeft		// MOve and draw the ball
	b	endBallMovement		// Stop ball movement
topLeft45:
	mov	r0, #1			// Move at 45
	bl	moveBallTopLeft		// Move and drawthe ball
	b	endBallMovement		// Stop ball movement
checkBottomLeft:
	cmp	dir, #2			// Check if ball is going bottom left
	bne	checkBottomRight	// If not check bottom right
	cmp	angle, #45		
	beq	bottomLeft45
	mov	r0, #0			// Mov at 60 
	bl	moveBallBottomLeft	// Move and draw the ball
	b	endBallMovement		// Check if ball has hit paddle
bottomLeft45:
	mov	r0, #1			// MOv at 45
	bl	moveBallBottomLeft	// MOve and draw the ball
	b	endBallMovement
checkBottomRight:
	cmp	dir, #3			// Check if ball is going bottom right
	bne	endBallMovement		// If not go to end of function
	cmp	angle, #45
	beq	bottomRight45
	mov	r0, #0			// Move at 60
	bl	moveBallBottomRight	// Move and draw the ball
	b	endBallMovement		// Check if ball has hit the paddle 
bottomRight45:
	mov	r0, #1			// Move at 45
	bl	moveBallBottomRight	// Move and draw the ball
	b	endBallMovement

endBallMovement:
	.unreq	ballX
	.unreq	ballY
	.unreq	angle
	.unreq	dir

	pop {r4-r8,lr}
	mov	pc,lr

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// MOVE BALL FUNCTIONS /////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Move the ball in the top right direction 1 pixel at a time
// Checks if the ball has collided with brick at each movement and stop movement if collided
// 	1) r0: move at 45 or 60
//		0: move at 60, up 2 and right 1
//		1: move at 45, up 2 and right 2
moveBallTopRight:
	push {r4-r7,lr}
	
	ball	.req	r4
	ballX	.req	r5
	ballY	.req	r6
	mov45	.req	r7
	
	ldr	ball, =ballState
	ldr	ballX, [ball]		// X coord of ball
	ldr	ballY, [ball, #4]	// Y coord of ball
	mov	mov45, r0		// 1 is move 45, 0 is move 60
	

///////////////////////MOVE BALL UP 1 PIXEL AND CHECK TOP BALL COLLISIONS//////////////////////////////////
	sub	ballY, #1			// Go up by 1 pixel

	// Check Top Left collision form Y value
	mov	r0, ballX
	mov	r1, ballY
	mov	r2, #1			// Tell collision fucntion to check Y coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endTopRight

	// Check Top Right collision from Y value
	add	r0, ballX, #16
	mov	r1, ballY
	mov	r2, #1			// Tell collision fucntion to check Y coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endTopRight

	// Draw new ball
	str	ballY, [ball, #4]	// Store new Y coord
	bl	drawBall		// Draw the new Ball
///////////////////////MOVE BALL RIGHT 1 PIXEL AND CHECK RIGHT BALL COLLISIONS//////////////////////////////////
	add	ballX, #1		// Go right by 1 pixel

	// Check Top Right collision from X value
	add	r0, ballX, #16
	mov	r1, ballY
	mov	r2, #0			// Tell collision fucntion to check X coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endTopRight

	// Check Bottom Right collision from X value
	add	r0, ballX, #16
	add	r1, ballY, #16
	mov	r2, #0			// Tell collision fucntion to check X coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endTopRight
	
	// Draw new ball
	str	ballX, [ball]		// Store new X coord
	bl	drawBall		// Draw the new Ball

///////////////////////MOVE BALL UP 1 PIXEL AND CHECK TOP BALL COLLISIONS//////////////////////////////////
	sub	ballY, #1			// Go up by 1 pixel

	// Check Top Left collision form Y value
	mov	r0, ballX
	mov	r1, ballY
	mov	r2, #1			// Tell collision fucntion to check Y coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endTopRight

	// Check Top Right collision from Y value
	add	r0, ballX, #16
	mov	r1, ballY
	mov	r2, #1			// Tell collision fucntion to check Y coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endTopRight

	// Draw new ball
	str	ballY, [ball, #4]	// Store new Y coord
	bl	drawBall		// Draw the new Ball

	cmp	mov45, #1		// If ball is moving at 45 do one more move right
	bne	endTopRight

///////////////////////MOVE BALL RIGHT 1 PIXEL AND CHECK RIGHT BALL COLLISIONS//////////////////////////////////
	add	ballX, #1		// Go right by 1 pixel

	// Check Top Right collision from X value
	add	r0, ballX, #16
	mov	r1, ballY
	mov	r2, #0			// Tell collision fucntion to check X coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endTopRight

	// Check Bottom Right collision from X value
	add	r0, ballX, #16
	add	r1, ballY, #16
	mov	r2, #0			// Tell collision fucntion to check X coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endTopRight
	
	// Draw new ball
	str	ballX, [ball]		// Store new X coord
	bl	drawBall		// Draw the new Ball


endTopRight:
	.unreq	ball
	.unreq	ballX
	.unreq	ballY
	.unreq	mov45
	
	pop {r4-r7,lr}
	mov	pc,lr

// Move the ball in the top left direction 1 pixel at a time
// Checks if the ball has collided with brick at each movement and stop movement if collided
// 	1) r0: move at 45 or 60
//		0: move at 60, up 2 and left 1
//		1: move at 45, up 2 and left 2
moveBallTopLeft:
	push {r4-r7,lr}
	
	ball	.req	r4
	ballX	.req	r5
	ballY	.req	r6
	mov45	.req	r7

	ldr	ball, =ballState
	ldr	ballX, [ball]		// X coord of ball
	ldr	ballY, [ball, #4]	// Y coord of ball
	mov	mov45, r0
	
/////////////////////////////////// Move Ball Up and check top of ball for collisions////////////////////////////////
	sub	ballY, #1		// Go up by 1 pixel

	// Check Top Left Coord For Collision
	mov	r0, ballX		// X coord of ball
	mov	r1, ballY		// Y coord of ball
	mov	r2, #1			// Tell collision function to check for Y bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endTopLeft

	// Check Top Right Coord For Collision
	add	r0, ballX, #16		// X right coord of ball
	mov	r1, ballY		// Y coord of ball
	mov	r2, #1			// Tell collision function to check for Y bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endTopLeft
	
	// Draw new ball
	str	ballY, [ball, #4]	// Store new Y coord
	bl	drawBall		// Draw the new Ball

//////////////////////////// Move Ball Left and check left side of ball for collisions //////////////////////
	sub	ballX, #1		// Go left by 1 pixel
	
	// Check top left coord
	mov	r0, ballX		// X coord of ball
	mov	r1, ballY		// Y coord of ball
	mov	r2, #0			// Tell collision function to check for X bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endTopLeft

	// Check bottom left coord
	mov	r0, ballX		// X coord of ball
	add	r1, ballY, #16		// Y coord of ball
	mov	r2, #0			// Tell collision function to check for X bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endTopLeft
	
	// Draw new ball
	str	ballX, [ball]		// Store new X coord
	bl	drawBall		// Draw the new Ball

/////////////////////////////////// Move Ball Up and check top of ball for collisions////////////////////////////////
	sub	ballY, #1		// Go up by 1 pixel

	// Check Top Left Coord For Collision
	mov	r0, ballX		// X coord of ball
	mov	r1, ballY		// Y coord of ball
	mov	r2, #1			// Tell collision function to check for Y bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endTopLeft

	// Check Top Right Coord For Collision
	add	r0, ballX, #16		// X right coord of ball
	mov	r1, ballY		// Y coord of ball
	mov	r2, #1			// Tell collision function to check for Y bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endTopLeft
	
	// Draw new ball
	str	ballY, [ball, #4]	// Store new Y coord
	bl	drawBall		// Draw the new Ball

	cmp	mov45, #1		// Check if moving at 45 or 60
	bne	endTopLeft

//////////////////////////// Move Ball Left and check left side of ball for collisions //////////////////////
	sub	ballX, #1		// Go left by 1 pixel
	
	// Check top left coord
	mov	r0, ballX		// X coord of ball
	mov	r1, ballY		// Y coord of ball
	mov	r2, #0			// Tell collision function to check for X bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endTopLeft

	// Check bottom left coord
	mov	r0, ballX		// X coord of ball
	add	r1, ballY, #16		// Y coord of ball
	mov	r2, #0			// Tell collision function to check for X bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endTopLeft
	
	// Draw new ball
	str	ballX, [ball]		// Store new X coord
	bl	drawBall		// Draw the new Ball

endTopLeft:
	.unreq	ball
	.unreq	ballX
	.unreq	ballY
	.unreq	mov45

	pop {r4-r7,lr}
	mov	pc,lr

// Move the ball in the bottom left direction 1 pixel at a time
// Checks if the ball has collided with brick at each movement and stop movement if collided
// 	1) r0: move at 45 or 60
//		0: move at 60, down 2 and left 1
//		1: move at 45, down 2 and left 2
moveBallBottomLeft:
	push {r4-r7,lr}
	
	ball	.req	r4
	ballX	.req	r5
	ballY	.req	r6
	mov45	.req	r7
	
	ldr	ball, =ballState
	ldr	ballX, [ball]		// X coord of ball
	ldr	ballY, [ball, #4]	// Y coord of ball
	mov	mov45, r0

///////////////// Move Ball Down by 1 pixel and check bottom of ball for collisions///////////////////////////
	
	add	ballY, #1		// Go up by 1 pixel

	// Check bottom left coord of ball
	mov	r0, ballX
	add	r1, ballY, #16
	mov	r2, #1
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick is hit stop movement
	beq	endBottomLeft

	// Check bottom right coord of ball
	add	r0, ballX, #16
	add	r1, ballY, #16
	mov	r2, #1
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick is hit stop movement
	beq	endBottomLeft

	// Draw new ball
	str	ballY, [ball, #4]	// Store new X coord
	bl	drawBall		// Draw the new Ball

////////////////// Move Ball Left by 1 pixel and check left side of ball for collision/////////////////////
	
	sub	ballX, #1		// Go left by 1 pixel
	
	// Check top left coord
	mov	r0, ballX		// X coord of ball
	mov	r1, ballY		// Y coord of ball
	mov	r2, #0			// Tell collision function to check for X bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endBottomLeft

	// Check bottom left coord
	mov	r0, ballX		// X coord of ball
	add	r1, ballY, #16		// Y coord of ball
	mov	r2, #0			// Tell collision function to check for X bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endBottomLeft
	
	// Draw new ball
	str	ballX, [ball]		// Store new X coord
	bl	drawBall		// Draw the new Ball

///////////////// Move Ball Down by 1 pixel and check bottom of ball for collisions///////////////////////////
	
	add	ballY, #1		// Go up by 1 pixel

	// Check bottom left coord of ball
	mov	r0, ballX
	add	r1, ballY, #16
	mov	r2, #1
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick is hit stop movement
	beq	endBottomLeft

	// Check bottom right coord of ball
	add	r0, ballX, #16
	add	r1, ballY, #16
	mov	r2, #1
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick is hit stop movement
	beq	endBottomLeft

	// Draw new ball
	str	ballY, [ball, #4]	// Store new X coord
	bl	drawBall		// Draw the new Ball


	cmp	mov45, #1		// Check if moving at 45 or 60
	bne	endBottomLeft
	

////////////////// Move Ball Left by 1 pixel and check left side of ball for collision/////////////////////
	
	sub	ballX, #1		// Go left by 1 pixel
	
	// Check top left coord
	mov	r0, ballX		// X coord of ball
	mov	r1, ballY		// Y coord of ball
	mov	r2, #0			// Tell collision function to check for X bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endBottomLeft

	// Check bottom left coord
	mov	r0, ballX		// X coord of ball
	add	r1, ballY, #16		// Y coord of ball
	mov	r2, #0			// Tell collision function to check for X bounce
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick was hit stop movement
	beq	endBottomLeft
	
	// Draw new ball
	str	ballX, [ball]		// Store new X coord
	bl	drawBall		// Draw the new Ball


endBottomLeft:
	.unreq	ball
	.unreq	ballX
	.unreq	ballY
	.unreq	mov45

	pop {r4-r7,lr}
	mov	pc,lr

// Move the ball in the bottom right direction 1 pixel at a time
// Checks if the ball has collided with brick at each movement and stop movement if collided
// 	1) r0: move at 45 or 60
//		0: move at 60, down 2 and right 1
//		1: move at 45, down 2 and right 2
moveBallBottomRight:
	push {r4-r7,lr}
	
	ball	.req	r4
	ballX	.req	r5
	ballY	.req	r6
	mov45	.req	r7
	
	ldr	ball, =ballState
	ldr	ballX, [ball]		// X coord of ball
	ldr	ballY, [ball, #4]	// Y coord of ball
	mov	mov45, r0
	
///////////////// Move Ball Down by 1 pixel and check bottom of ball for collisions///////////////////////////
	
	add	ballY, #1		// Go up by 1 pixel

	// Check bottom left coord of ball
	mov	r0, ballX
	add	r1, ballY, #16
	mov	r2, #1
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick is hit stop movement
	beq	endBottomRight

	// Check bottom right coord of ball
	add	r0, ballX, #16
	add	r1, ballY, #16
	mov	r2, #1
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick is hit stop movement
	beq	endBottomRight

	// Draw new ball
	str	ballY, [ball, #4]	// Store new X coord
	bl	drawBall		// Draw the new Ball


///////////////// MOve Ball Right by 1 pixel and check right of ball for collisions //////////////////////////
	
	add	ballX, #1		// Go right by 1 pixel

	// Check Top Right collision from X value
	add	r0, ballX, #16
	mov	r1, ballY
	mov	r2, #0			// Tell collision fucntion to check X coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endBottomRight

	// Check Bottom Right collision from X value
	add	r0, ballX, #16
	add	r1, ballY, #16
	mov	r2, #0			// Tell collision fucntion to check X coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endBottomRight
	
	// Draw new ball
	str	ballX, [ball]		// Store new X coord
	bl	drawBall		// Draw the new Ball

///////////////// Move Ball Down by 1 pixel and check bottom of ball for collisions///////////////////////////
	
	add	ballY, #1		// Go up by 1 pixel

	// Check bottom left coord of ball
	mov	r0, ballX
	add	r1, ballY, #16
	mov	r2, #1
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick is hit stop movement
	beq	endBottomRight

	// Check bottom right coord of ball
	add	r0, ballX, #16
	add	r1, ballY, #16
	mov	r2, #1
	bl	checkBrickCollision	// Check if ball has colided with brick from new Y value
	cmp	r0, #1			// If brick is hit stop movement
	beq	endBottomRight

	// Draw new ball
	str	ballY, [ball, #4]	// Store new X coord
	bl	drawBall		// Draw the new Ball

	cmp	mov45, #1		// Check if moving at 45 or 60
	bne	endBottomRight


///////////////// Move Ball Right by 1 pixel and check right of ball for collisions //////////////////////////
	
	add	ballX, #1		// Go right by 1 pixel

	// Check Top Right collision from X value
	add	r0, ballX, #16
	mov	r1, ballY
	mov	r2, #0			// Tell collision fucntion to check X coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endBottomRight

	// Check Bottom Right collision from X value
	add	r0, ballX, #16
	add	r1, ballY, #16
	mov	r2, #0			// Tell collision fucntion to check X coord
	bl	checkBrickCollision	// Check if ball has colided with brick from new X value
	cmp	r0, #1			// If brick was hit stop collision check
	beq	endBottomRight
	
	// Draw new ball
	str	ballX, [ball]		// Store new X coord
	bl	drawBall		// Draw the new Ball

	
endBottomRight:
	.unreq	ball
	.unreq	ballX
	.unreq	ballY
	.unreq	mov45

	pop {r4-r7,lr}
	mov	pc,lr

/////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////// CHeck Ball Corner Collision////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

// Check if the ball has hit a tile from the top left coord of the ball
// Input
//	1) r0: X coord of the ball to check
//	2) r1: Y coord of the ball to check

// Return 
//	1) r0: Flag if brick was hit
//		0 - brick was not hit
//		1 - brick was hit
checkBrickCollision:
	push	{r4-r10, lr}

	ball	.req 	r4
	ballX	.req	r5
	ballY	.req	r7
	dir	.req	r6
	tileI	.req	r8		// Index value for array
	tileJ	.req	r9		// Index value for array
	brick	.req	r10
	gridOffset	.req	r11	// Offset

	ldr	ball, =ballState	// Load ball array address into r4
	ldr	r10, =gridState		// Load grid array address into r10

	ldr	dir, [ball, #12]	// Load direction of ball into r6
	mov	ballX, r0
	mov	ballY, r1

	mov	tileI, ballX
	asr	tileI, #6		// I array value of Grid Tile collision

	mov	tileJ, ballY
	asr	tileJ, #5		// J array index of Grid Tile Collision
	
	//Calcualte offset for grid array and store brick value in brick register
	mov	gridOffset, #21		// Total amount of Columns
	mul	gridOffset, tileJ
	add	gridOffset, tileI
	lsl	gridOffset, #2		// r9 now contains the offset
	ldr	brick, [r10, gridOffset]// r2 contains the brick value of tile hit by ball

	cmp	brick, #1		// If brick is background do nothing
	beq	endBrickCollision

	cmp	r2, #0			// Check if new direction should be from X or Y coord position
	beq	xCollision

// CHange the direction in the Y vlaue becasue the top or bottom of a brick was hit
yCollision:
	cmp	dir, #0
	beq	topRightToBottomRight
	cmp	dir, #1
	beq	topLeftToBottomLeft
	cmp	dir, #2
	beq	bottomLeftToTopLeft
	cmp	dir, #3
	beq	bottomRightToTopRight
	b	endBrickCollision

topRightToBottomRight:
	mov	dir, #3
	b	replaceHitBrick

topLeftToBottomLeft:
	mov	dir, #2
	b	replaceHitBrick

bottomLeftToTopLeft:
	mov	dir, #1
	b	replaceHitBrick

bottomRightToTopRight:
	mov	dir, #0
	b	replaceHitBrick
// Change the direction in the X value becasue the side of a brick was hit
xCollision:
	cmp	dir, #0
	beq	topRightToTopLeft
	cmp	dir, #1
	beq	topLeftToTopRight
	cmp	dir, #2
	beq	bottomLeftToBottomRight
	cmp	dir, #3
	beq	bottomRightToBottomLeft
	b	endBrickCollision

topRightToTopLeft:
	mov	dir, #1
	b	replaceHitBrick

topLeftToTopRight:
	mov	dir, #0
	b	replaceHitBrick

bottomLeftToBottomRight:
	mov	dir, #3
	b	replaceHitBrick

bottomRightToBottomLeft:
	mov	dir, #2
	b	replaceHitBrick


	
// Replace that was hit with the value below it
replaceHitBrick:
	str	dir, [ball, #12]		// Store the new direction back into the ball array
	lsl	tileI, #6
	lsl	tileJ, #5
	mov	r0, tileI			// MOve top right x coord of the brick that was hit into ro		
	mov	r1, tileJ			// Move the top right Y coord of the brick that was hit into r1
	

	cmp	brick, #0			// Check if bordeBrick was hit
	beq	borderBrickHit
	cmp	brick, #2			// Check if purple brick was hit
	beq	replaceToBackgroundBrick
	cmp	brick, #3			// Check if blue brick was hit
	beq	replaceToPurpleBrick
	cmp	brick, #4			// Check if green brick was hit	
	beq	replaceToBlueBrick		
	cmp	brick, #5			// Check if orange brick was hit
	beq	replaceToGreenBrick
	cmp	brick, #6			// Check if red brick was hit
	beq	replaceToOrangeBrick
	b	endBrickCollision

borderBrickHit:
	ldr	r2, =borderBrick
	bl	drawBrickImage			// Redraw the border brick that was hit
	mov	r0, #1
	b	endBrickCollision		// End collision detection

replaceToBackgroundBrick:
	mov	r3, #1				// Change blue brick to background brick
	ldr	r10, =gridState			// Load grid array address
	str	r3, [r10, gridOffset]		// Store new value in grid array
	ldr	r2, =backgroundBrick
	bl	drawBrickImage			// Draw background brick where light blue brick was
	bl	incrementScore
	mov	r0, #1				// Set brick hit flag to true
	b	endBrickCollision

replaceToPurpleBrick:
	mov	r3, #2				// Change brick to purple
	ldr	r10, =gridState			// Load grid array address
	str	r3, [r10, gridOffset]		// Store new vlaue in grid
	ldr	r2, =purpleBrick		
	bl	drawBrickImage			// Repalce the hit brick with new brick
	bl	incrementScore
	mov	r0, #1				// Set brick hit flag to true
	b	endBrickCollision

replaceToBlueBrick:
	mov	r3, #3				// Change brick to blue
	ldr	r10, =gridState			// Load grid array address
	str	r3, [r10, gridOffset]		// Store new value in grid array
	ldr	r2, =blueBrick
	bl	drawBrickImage			// Repalce the hit brick with new brick
	bl	incrementScore
	mov	r0, #1				// Set brick hit flag to true
	b	endBrickCollision

replaceToGreenBrick:
	mov	r3, #4				// Change brick to green
	ldr	r10, =gridState			// Load grid array address
	ldr	r10, =gridState			// Load grid array address
	str	r3, [r10, gridOffset]		// Store new value in grid array
	ldr	r2, =greenBrick
	bl	drawBrickImage			// Repalce the hit brick with new brick
	bl	incrementScore
	mov	r0, #1				// Set brick hit flag to true
	b	endBrickCollision

replaceToOrangeBrick:
	mov	r3, #5				// Change brick to orange
	ldr	r10, =gridState			// Load grid array address
	str	r3, [r10, gridOffset]		// Store new value in grid array
	ldr	r2, =orangeBrick
	bl	drawBrickImage			// Repalce the hit brick with new brick
	bl	incrementScore
	mov	r0, #1				// Set brick hit flag to true
	b	endBrickCollision
	

endBrickCollision:

	.unreq	ballX	
	.unreq	ballY
	.unreq	ball
	.unreq	tileI
	.unreq	tileJ
	.unreq	brick
	.unreq	gridOffset
	.unreq	dir	
	pop	{r4-r10, lr}
	mov	pc,lr



.global checkValuePaddle
// Check if the brick that containts the paddle value pack has been hit
// If so start moving the value pack down the screen
// 	r0:	the value pack to move
//	r1:	the index value of the vlaue pack to move
checkValuePaddle:
	push	{r4-r11,lr}

	valuePack		.req 	r4
	valuePackX		.req	r5
	valuePackY		.req	r6
	tileI			.req	r7	// Index value for array
	tileJ			.req	r8	// Index value for array
	brick			.req	r9
	gridOffset		.req	r10	// Offset
	valuePackYInital	.req	r11

	mov	r12, r1				// MOve index to safer register

	mov	valuePack, r0
	ldr	r9, =gridState			// Load grid array address into r10

	ldr	valuePackX, [valuePack]
	ldr	valuePackY, [valuePack, #4]
	ldr	valuePackYInital, [valuePack, #8]

	

	mov	tileI, valuePackX
	asr	tileI, #6		// I array value of Grid Tile collision

	mov	tileJ, valuePackYInital
	asr	tileJ, #5		// J array index of Grid Tile Collision
	
	//Calcualte offset for grid array and store brick value in brick register
	mov	gridOffset, #21		// Total amount of Columns
	mul	gridOffset, tileJ
	add	gridOffset, tileI
	lsl	gridOffset, #2		// r9 now contains the offset
	ldr	brick, [r9, gridOffset]	// r2 contains the brick value of tile hit by ball

	cmp	brick, #1		// IF the brick has not been destroyed do not move the value pack down
	bne	endCheckValuePack


	mov	tileI, valuePackX
	asr	tileI, #6		// I array value of Grid Tile collision

	mov	tileJ, valuePackY
	asr	tileJ, #5		// J array index of Grid Tile Collision
	
	//Calcualte offset for grid array and store brick value in brick register
	mov	gridOffset, #21		// Total amount of Columns
	mul	gridOffset, tileJ
	add	gridOffset, tileI
	lsl	gridOffset, #2		// r9 now contains the offset
	ldr	r9, =gridState
	ldr	brick, [r9, gridOffset]// r2 contains the brick value of tile hit by ball


	mov	r0, tileI
	mov	r1, tileJ
	lsl	r0, #6			// X coord of brick to redraw
	lsl	r1, #5			// Y coord of vrick to redraw

			//draw correct brick entry
checkBorderValue:	cmp	brick, #0
			bne	checkBackgroundValue		
			ldr	r2, =borderBrick
			bl	drawBrickImage
			b	moveValuePack

checkBackgroundValue:	cmp	brick, #1
			bne	checkPurpleValue		
			ldr	r2, =backgroundBrick
			bl	drawBrickImage
			b	moveValuePack

checkPurpleValue:	cmp	brick, #2
			bne	checkBlueValue
			ldr	r2, =purpleBrick
			bl	drawBrickImage
			b	moveValuePack

checkBlueValue:		cmp	brick, #3
			bne	checkGreenValue		
			ldr	r2, =blueBrick
			bl	drawBrickImage
			b	moveValuePack
			
checkGreenValue:	cmp	brick, #4
			bne	checkOrangeValue		
			ldr	r2, =greenBrick
			bl	drawBrickImage
			b	moveValuePack

checkOrangeValue:	cmp	brick, #5
			bne	checkRedValue
			ldr	r2, =orangeBrick
			bl	drawBrickImage
			b	moveValuePack

checkRedValue:		cmp	brick, #6
			bne	endCheckValuePack
			ldr	r2, =redBrick
			bl	drawBrickImage
			b	moveValuePack


// Move the value pack down one pixel and checkl for collision with out of bounds and paddle
moveValuePack:

	ldr	r0, [valuePack, #12]		// Check if value pack has been used
	cmp	r0, #1
	beq	endCheckValuePack		// If pack has been used then stop the function

	cmp	valuePackY, #940		
	beq	endCheckValuePack		// Check if the vlaue pack has hit bottom of the screen

	add	valuePackY, #1			// Move the value pack down by 1
	str	valuePackY, [valuePack, #4]	// Store the new y value


	mov	r0, valuePackX			// Move into r0 the x coord of the value pack to draw
	mov	r1, valuePackY			// Move into r1 the y coord of the value pack to draw
	mov	r2, r12				// Move into r2 the address of the value pack image to draw 
	bl	drawValuePack			// Re drarw the value pack

	ldr	r8, =paddleState
	ldr	r9, [r8]			// X coord of paddle
	
	cmp	valuePackY, #812		// Check if the vlaue pack is in contact with the paddle
	bne	endCheckValuePack		// IF not go to end of function

	add	r0, valuePackX, #32		// Far right X coord of value pack
	cmp	r0, r9				// Check if right coord of pack is within left bound of paddle
	ble	endCheckValuePack		// If not stop function

	ldr	r1, [r8, #16]
	cmp	r1, #1				// Load in flag for extended paddle
	beq	catchExtendedPaddle		
	add	r0, r9, #128			// IF not extended add 128 to right bound of paddle
	b	checkPaddleRightBound

catchExtendedPaddle:
	add	r0, r9, #256			// IF extended add 256 to right bound of paddle

checkPaddleRightBound:
	cmp	valuePackX, r0			// Check if the left side of the vlaue pack is wihtin the right bound of the paddle
	bge	endCheckValuePack		// If not the value pack is not within bounds and has missed, stop function 


/////////////////The value pack has collided with the paddle////////////////////////////////////////

	// Check which value pack has hit the paddle
	cmp	r12, #0
	beq	changePaddleToLarge
	cmp	r12, #1
	beq	changePaddleToCatchBall
	cmp	r12, #2
	beq	changePaddleToBrick
	b	endCheckValuePack

// Extends the width of the paddle by 128 and reduces the movement of the paddle by 128 on the right side of the screen
// Removes the catch ball power up from the paddle 
changePaddleToLarge:
	ldr	r0, [r8, #16]		// Load extended paddle flag
	cmp	r0, #1			// Check if the paddle has already been extended
	beq	endCheckValuePack	// If yes dont extend again

	mov	r0, #1			// Set that the vALue pack has been used to true 
	str	r0, [valuePack, #12]	// Store that the pack has been used in valuePaddleState

	mov	r0, #1			// Set the extended paddle flag to tur
	str	r0, [r8, #16]		// Store that the paddle is extended

	mov	r0, #0			// Disable brick power up
	str	r0, [r8, #24]	

	ldr	r0, [r8, #12]		// Load X Maxbound for paddle movement
	sub	r0, #128		// Reduce by 128
	str	r0, [r8, #12]		// Store new X Max bound for paddle movement

	mov	r0, #1
	bl	replaceBottomBricks	// Remove the border bricks from the bottom if there

	mov	r0, #0			// Set the catch ball flag to false
	str	r0, [r8, #20]		// Remove the ball power up

	mov	r0, #25
	mov	r1, #30
	bl	drawGrid		// Redraw bottom of grid to remove the extended paddle
	b	endCheckValuePack	// Branch to end of function 

changePaddleToCatchBall:
	ldr	r0, [r8, #20]		// Load catch ball flag
	cmp	r0, #1			// If already enabled go to end of fucntion
	beq	endCheckValuePack
	mov	r0, #1			// Set the pack used flag to true
	str	r0, [valuePack, #12]	// Store used flag in value pack

	str	r0, [r8, #20]		// Store catch ball flag enabled in paddle array

	mov	r0, #0			// Disable brick power up
	str	r0, [r8, #24]	

	mov	r0, #1
	bl	replaceBottomBricks	// Remove obrder bricks from the bototm if there

	mov	r0, #25
	mov	r1, #30
	bl	drawGrid		// Redraw bottom of grid to remove the extended paddle

	ldr	r0, [r8, #16]		// Load in paddle extended flag
	cmp	r0, #0			// If enabled disable it and reduce paddle size and increase Max X bound
	beq	endCheckValuePack
	mov	r0, #0			
	str	r0, [r8, #16]		// Store that the paddle is not extended in paddleState

	ldr	r0, [r8, #12]
	add	r0, #128		// Add 128 to paddle right bound movement
	str	r0, [r8, #12]		// Change the right bound for paddle movement

	mov	r0, #25
	mov	r1, #30
	bl	drawGrid		// Redraw bottom of grid to remove the extended paddle
	b	endCheckValuePack	// Branch to end of function 

changePaddleToBrick:
	ldr	r0,[r8, #24]
	cmp	r0, #1			// Check if the brick powerup has already been used
	beq	endCheckValuePack
	
	mov	r0, #1			
	str	r0, [valuePack, #12]	// Set the flag in the value Pack to true
	str	r0,[r8,#24]		// Set the brick flag in the paddle to true

	mov	r0, #0
	bl	replaceBottomBricks	// Add border bricks to bottom of game screen

	mov	r0, #25
	mov	r1, #30
	bl	drawGrid		// Redraw bottom of grid to remove the extended paddle

	mov	r0, #0
	str	r0, [r8, #20]		// Remove catch ball flag 

	ldr	r0, [r8, #16]		// Load in paddle extended flag
	cmp	r0, #0			// If enabled disable it and reduce paddle size and increase Max X bound
	beq	endCheckValuePack
	mov	r0, #0			
	str	r0, [r8, #16]		// Store that the paddle is not extended in paddleState

	ldr	r0, [r8, #12]
	add	r0, #128		// Add 128 to paddle right bound movement
	str	r0, [r8, #12]		// Change the right bound for paddle movement

	mov	r0, #25
	mov	r1, #30
	bl	drawGrid		// Redraw bottom of grid to remove the extended paddle
	
	

endCheckValuePack:


	.unreq	valuePack		
	.unreq	valuePackX
	.unreq	valuePackY
	.unreq	tileI
	.unreq	tileJ
	.unreq	brick
	.unreq	gridOffset
	.unreq	valuePackYInital

	pop	{r4-r11,lr}
	mov	pc, lr

// Replaces the bottom 4 brics on each side of the screen with inputed value
// 	1)	r0: brick to replace too

.global replaceBottomBricks
replaceBottomBricks:
	push	{r5-r8,lr}

	mov	r7, r0
	
	mov	r5, #2356	// Offset for the bottom right of the grid
	ldr	r8, =gridState	
	str	r7, [r8, r5]	// Store border brick in bottom right of grid
	add	r5, #4		// Go to next brick in row and do the same
	str	r7, [r8, r5]	// Repeat for the all bricks that change on the bottom of the screen
	add	r5, #4		// For the power up
	str	r7, [r8, r5]	
	add	r5, #4
	str	r7, [r8, r5]
	mov	r5, #2416
	str	r7, [r8, r5]
	add	r5, #4
	str	r7, [r8, r5]	
	add	r5, #4
	str	r7, [r8, r5]	
	add	r5, #4
	str	r7, [r8, r5]


	pop	{r5-r8, lr}
	mov	pc, lr

// Incremenmts the score by 1 every time a brick is hit
// Stops the game when the score is 221
.global incrementScore
incrementScore:
	push	{r4, r5, lr}

	mov	r0, #192		//set x position
	mov	r1, #0			//set y position
	ldr	r2, =borderBrick	//
	bl	drawBrickImage		//redraw brick behind the score counter	

	ldr	r4, =scoreState		//load base address of the score state array

addtoOnes:	
	ldr	r5, [r4, #8]		//load the ones digit into r5
	cmp	r5, #9			//if == 9,
	beq	addtoTens		//branch to 'addtoTens'
	add	r5, #1			//else, add one to the ones digit
	str	r5, [r4, #8]		//store it back in the array
	b	checkScore		//branch to checkScore

addtoTens:
	mov	r5, #0			//
	str	r5, [r4, #8]		//store a 0 in the ones digit

	ldr	r5, [r4, #4]		//load the tens digit into r5
	cmp	r5, #9			//if == 9,	
	beq	addtoHundreds		//branch to 'addtoHundreds'
	add	r5, #1			//else, add one to the tens digit
	str	r5, [r4, #4]		//store it back in the array
	b	checkScore		//branch to checkScore

addtoHundreds:
	mov	r5, #0			//
	str	r5, [r4, #4]		//store a 0 in the tens digit

	ldr	r5, [r4]		//load the hundreds digit into r5
	add	r5, #1			//add 1 to the hundreds digit
	str	r5, [r4]		//store it back in the array
	
checkScore:
	ldr	r4, =numericalScore	//
	ldr	r5, [r4]		//load the numerical score
	add	r5, #1			//add 1 to it
	str	r5, [r4]		//store it back to the array

	cmp	r5, #221		//compare the score to 3 (score required to win) TODO: CHANGE FROM 3 TO CORRECT NUMBER
	blt	ISReturn		//if <, branch to return
	
	ldr	r4, =winCondition	//else
	mov	r5, #1			//
	str	r5, [r4]		//set winCondition to 1 (true)

ISReturn:
	pop	{r4, r5, lr}
	mov	pc, lr



// Degubbing Strings
.section    .data

ballXPos:
.asciz		"Ball X: %d\n"

ballYPos:
.asciz		"Ball Y: %d\n"

tileXPos:
.asciz		"Tile X: %d\n"

tileYPos:
.asciz		"Tile Y: %d\n"

gridIPos:
.asciz		"Grid I: %d\n"

gridJPos:
.asciz		"Grid J: %d\n"


gridOffsetValue:
.asciz		"Offset: %d\n"

test:
.asciz		"%d\n"

brickIsNowBackground:
.asciz		"Brick Hit is now a background brick\n\n"


.global brickHit
brickHit:
.asciz		"Brick: %d\n"

brickWasHit:
.asciz		"\nBrick Was Hit\n\n"

checkingTopLeft:
.asciz		"Checking Top Left Collission \n"

checkingTopRight:
.asciz		"Checking Top Right Collission \n"

angle45:
.asciz		"Change Angle to 45\n"

angle60:
.asciz		"Change Angle to 60\n"

		


	
