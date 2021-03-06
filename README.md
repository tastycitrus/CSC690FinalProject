# FINAL PROJECT DETAILS

## Contributor(s) to project: Diana Luu

###### Working Title: Super Guy in the Galaxy

Progress Report (11/14/18):
* Completed tasks:
	* Added background node
	* Added player sprite
	* Added working jump button
	* Added working shoot button with projectiles
* To do:
	* Modify jump functionality so that you can only jump while on the ground
	* Add in a monster entity
	* Create collision mechanics for when a projectile hits a monster or a monster touches the player sprite
	* Create mechanics that spawns a monster entity off screen to the right and moves them to the left (?)
	* Create a start screen
	* Create a game over screen (when a player touches a monster)
	* Add in a proper background, one in motion (right to left)
	* Swap player placeholder sprite for a proper texture that shows a walk cycle
	* Add sprites for monster entity
* Things to consider:
	* Import tilemaps to create proper levels to auto scroll through
	* Create stage hazards to jump over
	* Implement a health bar for the player (?)
	* Implement unique enemies (i.e. flying enemy, enemy that shoots projectiles)
	* Implement boss enemy (spawns at end of level, has health bar, has unique battle mechanics)

Progress Report (12/8/18):
* Completed tasks:
	* Added monster spawn
	* Added collision mechanics for when a projectile hits a monster
	* Created start screen
	* Added proper moving background
* TODO:
	* Add win/loss condition
	* Add collision mechanics for when player touches a monster
	* Add game over screen that goes back to menu
	* Replace placeholder sprites
* Known issues:
	* FPS drop when adding in background (specifically background image)
	* Occasional game freeze on startup
	
Progress Report (12/12/18):
* Completed tasks:
	* Added loss condition (player collides with enemy three times)
	* Added game over screen (automatically segues back to main menu after five seconds)
	* Added score counter (+ 10 * current combo counter, up to x128)
	* Replaced placeholder sprites
	* Added sound effects and background music
* Known issues:
	* FPS stays at 40 FPS for unknown reasons
	* Game still occasionally freezes upon startup
	
Progress Report (12/13/18):
* Completed tasks:
	* Changed menu screen and game over backgrounds
	* Changed ground color
	* Edited monster spawn so gameplay functions as normal on larger screens
