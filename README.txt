README

Creators: Hamzah Umar and Pierce de Jong
	  30029294	  30006609

This game was created for the purpose of a University of Calgary CPSC 359 course. It is not inteneded for 
unauthorized redistribution and/or sale. 

Game Rules:
	- User begins with 3 lives. You lose a life whenever the ball hits the bottom of the screen
	- 
	- You begin with a score of 0. You gain a point for every time your ball collides with a brick that is not a black brick
	- There are 6 different bricks than you can collide with. Each brick has a different 'hardness'
		- Purple: Takes one hit to break
		- Blue: Takes 2 hits to break
		- Green: Takes 3 hits to break 
		- Orange: Takes 4 hits to break
		- Red: Takes 5 hits to break
		- Black: Unbreakable. Used primarily for wall tiles
	- Bricks that require more than one hit to break and disappear will change color upon a hit.
		- i.e.: A red brick will turn into an orange brick when hit, and an orange brick will turn into a green brick when hit
		  and so on and so forth
	- There are three value packs implemented in the game
		- The paddle value pack extends the width of your paddle
		- The ball value pack enables you to catch a ball whenever it collides with your paddle. You can then launch the ball
		  whenever you want. The ball is launched at the opposite direction at which it was caught
		- The brick value pack adds a layer of 5 bricks at the bottom of the screen, on either side.
		- The positions of value packs are pseudo-randomly set to one of 8 pre-determined positions 
		NOTE: ACTIVATING ONE VALUE PACK WILL INSTANTLY DEACTIVATE ANY VALUE PACK THAT WAS ALREADY ENABLED
		YOU CAN NEVER HAVE MORE THAN ONE VALUE PACK EFFECT AT THE SAME TIME
		YOU WILL ALSO LOSE YOUR VALUE PACK WHENEVER YOU LOSE A LIFE, OR LOSE THE GAME (DUH!)
	- You win the game by breaking all the bricks (acheiveing a score of 221)
	

EXTRA NOTES TO THE TA MARKING THIS:
	
	- Please give us an A+ :)
	- As mentioned above, the positions of value packs is pseudo-randomly set.
	- As value packs are hidden, it may be difficult or time-consuming for you to hit a value pack and test its functionalty
	- Thus, we have added a feature to draw value packs for debugging purposes
	- To display the value packs, uncomment lines 156, 162, 168, 174 and 180 in gameTransitions.s
	
