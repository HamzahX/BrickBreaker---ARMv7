@ Data section
.section .data

// Tracks the game score with individual digits
.align 4
.global scoreState
scoreState:		.int	0, 0, 0 //initialize score to 0.


// Total score 
.align	4
.global numericalScore
numericalScore:		.int 0


// Total amount of lives left
.align 4
.global livesState
livesState:		.int	3 //initialize lives to 3


// WIn flagy
.align 4
.global winCondition
winCondition:		.int	0 //0 = false; 1 = true


//Lose flag
.align 4
.global loseCondition
loseCondition:		.int	0 //0 = false; 1 = true


// Tracks the paddle X and Y coords, the max bounds the X can go and if it has a power up
.align 4
.global paddleState	  	//will be changed as the game runs
paddleState:		.int	0, 0, 64, 1148, 0, 0, 0 // paddle x, paddle y, min x, max x, larger paddle flag, catch ball flag, brick value pack flag


// The innital paddle state that is used to reset the paddle
// Change this to change starting location of paddle
.align 4		
.global initialPaddleState 	//will *NOT* be changed as the game runs
initialPaddleState:	.int	608, 832, 64, 1148, 0, 0, 0   // paddle x, paddle y, min x, max x, larger paddle, catch ball, brick value pack flag


// Tracks the ball X and Y coords, the angle and the direction
.align 4
.global	ballState		//will be changed as the game runs
ballState:		.int	0, 0, 0, 0 // ball x, ball y, angle, direction (0 = top-right; 1 = top-left; 2 = bottom-left; 3 = bottom-right)


// The inital paddle state that is used to reset the ball
.align 4
.global	initialBallState	//will *NOT* be changed as the game runs
initialBallState:	.int	666, 816, 60, 0 // ball x, ball y, angle, direction (0 = top-right; 1 = top-left; 2 = bottom-left; 3 = bottom-right)


// Tracks the X, Y inital Y coords and value pack used flag
.align 4
.global	valuePaddleState
valuePaddleState:	.int	0, 0, 0, 0	// X posiition, Y position, Inital Y position, used Flag


// Tracks the X, Y inital Y coords and value pack used flag
.align 4
.global	valuePaddleState2
valuePaddleState2:	.int	0, 0, 0, 0	// X posiition, Y position, Inital Y position, used Flag


// Tracks the X, Y inital Y coords and value pack used flag
.align 4
.global	valueBallState
valueBallState:		.int	0, 0, 0, 0	// X posiition, Y position, Inital Y position, used Flag


// Tracks the X, Y inital Y coords and value pack used flag
.align 4
.global	valueBallState2
valueBallState2:	.int	0, 0, 0, 0	// X posiition, Y position, Inital Y position, used Falg


.align 4
.global	valueBrickState
valueBrickState:	.int	0, 0, 0, 0	// X posiition, Y position, Inital Y position, used Falg


// Tracks the current brick type on the game screen
.align 4
.global gridState
gridState:
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


// Inital brick locations and values for the game
// Change this to change the game brick layout
//	0 - border brick - cannot be destroyed
//	1 - background brick - no interaction
//	2 - purple brick - goes to background brick when hit
//	3 - blue brick - goes to purple when hit
//	4 - green brick - goes to blue when hit
//	5 - orange brick - goes to green when hit
//	6 - red brick - goes to orange when hit
//     97 - score brick - displays score image on game
//     98 - lives brick - displays lives image on game	
.align 4
.global newGrid
newGrid:
			.int	0, 0, 0, 0,97, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,98, 0, 0, 0, 0
			.int    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 2, 3, 3, 2, 1, 1, 1, 1, 1, 2, 3, 3, 2, 1, 1, 1, 0
			.int    0, 1, 1, 1, 2, 3, 3, 2, 1, 1, 2, 1, 1, 2, 3, 3, 2, 1, 1, 1, 0
			.int    0, 1, 1, 2, 3, 0, 3, 2, 1, 2, 6, 2, 1, 2, 3, 0, 3, 2, 1, 1, 0
			.int    0, 1, 1, 2, 3, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 3, 2, 1, 1, 0
			.int    0, 1, 1, 2, 3, 1, 4, 4, 1, 3, 3, 1, 4, 4, 4, 1, 3, 2, 1, 1, 0
			.int    0, 1, 2, 3, 1, 1, 1, 4, 1, 3, 1, 1, 4, 1, 4, 1, 1, 3, 2, 1, 0
			.int    0, 1, 2, 3, 1, 1, 4, 4, 1, 3, 3, 1, 4, 4, 4, 1, 1, 3, 2, 1, 0
			.int    0, 1, 2, 3, 1, 1, 1, 4, 1, 1, 3, 1, 1, 1, 4, 1, 1, 3, 2, 1, 0
			.int    0, 1, 1, 2, 3, 1, 4, 4, 1, 3, 3, 1, 1, 1, 4, 1, 3, 2, 1, 1, 0
			.int    0, 1, 1, 2, 3, 1, 1, 1, 1, 5, 5, 5, 1, 1, 1, 1, 3, 2, 1, 1, 0
			.int    0, 1, 1, 2, 3, 3, 1, 1, 3, 2, 6, 2, 3, 1, 1, 3, 3, 2, 1, 1, 0
			.int    0, 1, 1, 1, 2, 2, 5, 5, 2, 1, 1, 1, 2, 5, 5, 2, 2, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
			.int    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
	