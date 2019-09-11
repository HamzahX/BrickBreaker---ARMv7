# Brick Breaker

ARMv7 project on Raspberry Pi to play the game Brick Breaker

This game was created for a University of Calgary CPSC 359 course


### Project Goals

* Create a game using ARMv7 architecture
* Program an SNES controller to work on the Pi

### How the app works

* Run the program
* Use either the keyboard or a SNES controller to move around the menu
* Select a level and the play game

### Installation

* First, clone the app onto your Raspberry Pi
* Second, navigate to the game directory in tour console and type the following command to compile the code <code>/make</code>
* Third, type the following command to run the program <code>./myProg</code>

### Controls

* To start and release the ball from the paddle, press either A on the SNES controller or the spacebar on your keyboard
* To move the paddle back and forth, use the right and left trigger on the SNES or the A and D / left and right arrow keys on your keyboard
* TO pause, press the start button on the SNES controller or the enter key on your keyboard
* To unpause, press the same button or key as the pause function

### Game Rules

* You start with 3 lives. Every time the ball hits the bottom of the screen you lose a life
* You start with a score of 0. Each brick the ball hits will grant you a point
* There are 6 different bricks the ball can hit and score points from
	- Purple: Takes 1 hit to break
	- Blue: Takes 2 hits to break
	- Green: Takes 3 hits to break
	- Orange: Takes 4 hits to break
	- Red: Takes 5 hits to break
	- Black: Unbreakable. Used primarily for the game boundaries
* Bricks that require more than one hit to break will change to the brick with one less value until it is completely destroyed
	- When a red brick is hit, it will turn into an orange brick and so on
	- When a purple brick is hit, it will be destroyed
* There are power ups hidden throughout the level that will drop down the screen when the brick it is hiding behind is destroyed
	- The paddle power up will extend the width of your paddle
	- The ball power up enables the paddle to catch the ball when it collides with the paddle
	- The brick power up adds extra border bricks to the bottom left and right side of the game screen
* Picking up a power up will disable any other power up you may have enabled and you lose your power up when you die
* To win the game you must destroy all of the bricks on the screen

### Authors

 - Pierce
 - Hamzah

### Remaining Backlog Items

* Add true randomization to the value packs
* Add more value packs
* Add more levels and a progression system
* Clean up the game images
