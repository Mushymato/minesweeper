# minesweeper
3 Week Final Project for CSC258
* A FPGA based minesweeper game.
# Implemented Features
* Basic Game Rules and Graphics
* Win/Lose and restart cycle
* Uncomment VGA related code in minesweeper.v to use VGA displays
# How to Play
* KEY0 is reset
* KEY1 is start new game
* KEY2 is reveal
* SW4-0 corresponds to up, down, left, right.
* KEY3 is confirm movement
# Planned but Unimplemented Features
* Automatic revealing of blank squares
  * this was forgotten :v
* Random and Games
  * Trouble with getting LFSR to generate values within range
* Custom Board Size
  * Larger boards fails to load on chip
* Keyboard input
  * code worked in modelsim but fails to load on chip
* Prettier Graphics, especially the win/lose screen
  * neither me or my partner can draw
