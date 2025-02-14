GENERAL INFORMATION ABOUT LOCK GAME
Lock game is a strategy game played with 2 people. The playing field is 8X8 and consists of 64 squares. In the game, both players have 8 stones. The object of the game is to remove all the opponent's stones. At the beginning of the game, players place their stones on the squares in the row closest to them. Then the players take turns trying to lock the opponent's stones by moving a stone of their own. The stones can be moved as far as desired horizontally or vertically within the playing field, but the stones cannot be jumped over. A stone with opponent’s stones on 2 adjacent squares horizontally, a stone with opponent’s stones on 2 adjacent squares vertically, or a stone in the corner with opponent’s stones on the adjacent squares horizontally and vertically is considered locked. If the player whose turn it locks an opponent’s stone as a result of his/her move, he/she takes that stone out. The player who succeed to remove all the opponent's stones wins the game.

Problem Definition
A program is requested to be developed that will simulate the Lock game described above. Theplaying field should be at least 4X4 and at most 8X8. The rows of the playing field must be represented by counting numbers and the columns of the playing field must be represented by capital letters in English. When the program runs, first two characters must be taken from the user to represent the players:
Enter a character to represent player 1: X
Enter a character to represent player 2: Y
The game should be able to be played repeatedly, and at the start of each game, the initial playing field should be displayed after the row/column number of the playing field [4-8] is taken from the user. For example, a 4X4 initial playing field can be displayed like the following:
Enter the row/column number of the playing field(4-8): 4

Player X, please enter the position of your own stone you want to move and the target position:
Players must enter the current position of their own stone they want to move and the target position with the row number (in the example [1-4]) and the column letter (in the example  [A-D]) of the corresponding position adjacently (for example 3C) and leaving a space between the two positions (for example 3C 1C).
After each move, the playing field must be re-displayed, and if there is a stone that has been locked and removed with this move, the position of this stone must be specified. For example, the playing field at any stage of the game in the example above can be displayed like the following:
 
The stone at position 2C was locked and removed. 
Player Y, please enter the position of your own stone you want to move and the target position:
At the end of the game, which player won the game should be printed on the screen and the user should be asked if he/she wants to play again:  
Player X won the game.
Would you like to play again(Y/N)?: 
