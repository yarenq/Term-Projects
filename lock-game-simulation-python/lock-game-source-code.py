def create_table(row_column, char1, char2): #creates a 2D list for the table
    table = []
    for i in range(row_column): #placing the stones in the starting order
        columns = [" "] * row_column
        table.append(columns)
    for j in range(row_column):
        table[0][j]=char2
        table[row_column-1][j]=char1
    return table #returns the table to use in display_table function
def display_table(row_column,column_letters,table):  #displays the current board at the beginning and after each move
    print("    ",end="")
    for letter in column_letters:
        print(f"{letter}", end="   ")
    print("")
    print(" ","-" * (row_column * 4 + 1))
    for num in range(row_column):
        print(num+1,end=" | ")
        for stone in range(row_column):
            print(table[num][stone],end=" | ")
        print(num+1)
        print(" ", "-" * (row_column * 4 + 1))
    print(end="    ")
    for letter in column_letters:
        print(f"{letter}", end="   ")
    print(" ")

def is_move_valid(table,row_column,char, column_letters): #checks if the position input is valid according to the movement rules
#if the entry is invalid the function calls itself to start checking from the beginning (recursion) (in lines 42, 46, 54, 62, 70, 78, 81)
    move_char = input(f"Player {char}, please enter the position of your own stone you want to move and the target position:") #takes the position input
    # checking if the entry is valid
    while True:
        try:
            #creating the location variables
            current_row = int(move_char[0])
            current_column = move_char[1].upper()
            next_row = int(move_char[3])
            next_column = move_char[4].upper()
            # checking if the current character is valid and the target location is empty
            if table[current_row - 1][column_letters.index(current_column)] != char or table[next_row - 1][column_letters.index(next_column)] != " ":
                print("Invalid data entry, please try again.")
                current_row, current_column, next_row, next_column, table = is_move_valid(table,row_column, char, column_letters)
            #checks the current and target direction to prevent moving diagonally
            if (current_row != next_row or current_column == next_column) and (current_row == next_row or current_column != next_column):
                print("Invalid data entry, please try again.")
                current_row, current_column, next_row, next_column, table = is_move_valid(table,row_column, char, column_letters)
            #prevents jumping over the stones when going right
            if current_row == next_row and column_letters.index(next_column) > column_letters.index(current_column):
                for column in range(column_letters.index(current_column)+1, column_letters.index(next_column)+1):
                    if table[current_row-1][column] != " ":
                        row_border = column
                        if column_letters.index(next_column) > row_border:
                            print("Invalid data entry, you can't jump over a stone, please try again.")
                            current_row, current_column, next_row, next_column, table = is_move_valid(table, row_column, char, column_letters)
            # prevents jumping over the stones when going left
            elif current_row == next_row and column_letters.index(next_column) < column_letters.index(current_column):
                for column in range(column_letters.index(current_column)-1, column_letters.index(next_column) -1 , -1):
                    if table[current_row-1][column] != " ":
                        row_border = column
                        if column_letters.index(next_column) < row_border:
                            print("Invalid data entry, you can't jump over a stone, please try again.")
                            current_row, current_column, next_row, next_column, table = is_move_valid(table, row_column, char, column_letters)
            # prevents jumping over the stones when going down
            elif current_column == next_column and column_letters.index(next_column) > column_letters.index(current_column):
                for row in range(current_row, row_column):
                    if table[row][column_letters.index(current_column)] != " ":
                        column_border = row
                        if next_row > column_border:
                            print("Invalid data entry, you can't jump over a stone, please try again.")
                            current_row, current_column, next_row, next_column, table = is_move_valid(table, row_column, char, column_letters)
            # prevents jumping over the stones when going up
            elif current_column == next_column and column_letters.index(next_column) < column_letters.index(current_column):
                for row in range(row_column-1, current_row-1, -1):
                    if table[row][column_letters.index(current_column)] != " ":
                        column_border = row
                        if next_row < column_border:
                            print("Invalid data entry, you can't jump over a stone, please try again.")
                            current_row, current_column, next_row, next_column, table = is_move_valid(table, row_column, char, column_letters)
        except:
            print("Invalid data entry, please try again.")
            current_row, current_column, next_row, next_column, table = is_move_valid(table,row_column, char, column_letters)
        finally: #breaks from the loop if everything is valid
            break
    return current_row, current_column, next_row, next_column, table #returns some values to use in move_stone and remove_locked_stones

def move_stone(row_column, char1, char2, column_letters):  #a function that makes the movements
    # variables for the stones that got removed
    outer_stone1 = 0
    outer_stone2 = 0
    table = create_table(row_column, char1, char2)
    while outer_stone1<=row_column-1 or outer_stone2<=row_column-1:  #the game continues until all of the stones of a player except one, is out
        current_row1, current_column1, next_row1, next_column1, table = is_move_valid(table,row_column, char1, column_letters) #calling the is_valid to make sure the entry is correct
        # moving the stone
        table[current_row1 - 1][column_letters.index(current_column1)] = " "
        table[next_row1 - 1][column_letters.index(next_column1)] = char1

        outer_stone, table = remove_locked_stones(table, next_row1, next_column1, column_letters, char2, char1, row_column) #calling the remove stone function to check if stones need to be removed
        outer_stone2 += outer_stone
        display_table(row_column, column_letters, table)
        if outer_stone2>= row_column-1:
            return char1

        current_row2, current_column2, next_row2, next_column2, table = is_move_valid(table, row_column, char2, column_letters)
        # moving the stone
        table[current_row2 - 1][column_letters.index(current_column2)] = " "
        table[next_row2 - 1][column_letters.index(next_column2)] = char2
        outer_stone, table = remove_locked_stones(table, next_row2, next_column2, column_letters, char1, char2, row_column)
        outer_stone1 += outer_stone
        display_table(row_column, column_letters, table)
    return  char2

def remove_locked_stones(table,next_row,next_column,column_letters,outer_char,moving_char,row_column):
    outer_stone = 0
    try:
        # checks the 2 tiles on the right side next to the moving stone
        if table[next_row-1][column_letters.index(next_column)+1]==outer_char and table[next_row-1][column_letters.index(next_column)+2]==moving_char:
            table[next_row-1][column_letters.index(next_column) + 1] = " "
            outer_stone += 1 #if any stone is being removed, adds 1 to the outer_stone counter
    except:
        pass
    try:
        #checks the left
        if table[next_row-1][column_letters.index(next_column) - 1] == outer_char and table[next_row-1][column_letters.index(next_column) - 2] == moving_char and column_letters.index(next_column) - 2 >= 0:
            table[next_row-1][column_letters.index(next_column) - 1] = " "
            outer_stone += 1
    except:
        pass
    try:
        #checks up
        if table[next_row][column_letters.index(next_column)] == outer_char and table[next_row+1][column_letters.index(next_column)] == moving_char:
            table[next_row][column_letters.index(next_column)] = " "
            outer_stone += 1
    except:
        pass
    try:
        #checks down
        if table[next_row-2][column_letters.index(next_column)] == outer_char and table[next_row-3][column_letters.index(next_column)] == moving_char and next_row-3 >= 0:
            table[next_row-2][column_letters.index(next_column)] = " "
            outer_stone += 1
    except:
        pass
    #other conditions specified for the corners
    #checks the left top corner
    try:
        if table[0][0]==outer_char and table[1][0]==table[0][1] and table[0][1]==moving_char:
            table[0][0] = " "
            outer_stone += 1
    except:
        pass
    #checks the right top corner
    try:
        if table[0][row_column-1]==outer_char and table[0][row_column-2]==table[1][row_column-1] and table[1][row_column-1]==moving_char:
            table[0][row_column-1]= " "
            outer_stone += 1
    except:
        pass
    #checks the left down corner
    try:
        if table[row_column-1][0]==outer_char and table[row_column-2][0]==table[row_column-1][1] and table[row_column-1][1]==moving_char:
            table[row_column-1][0]= " "
            outer_stone += 1
    except:
        pass
    #checks the right down corner
    try:
        if table[row_column - 1][row_column-1] == outer_char and table[row_column - 2][row_column-1] == table[row_column - 1][row_column-2] and table[row_column - 1][row_column-2] == moving_char:
            table[row_column - 1][row_column-1]= " "
            outer_stone += 1
    except:
        pass

    return outer_stone, table #after all the stones that need to be removed are out, returns the total outer stones for that move and the current board

def main():
    MIN_ROW_COLUMN=4
    MAX_ROW_COLUMN=8
    replay="y"
    while replay=="y": #taking the first 3 inputs to start the game
        char1 = input("Enter a character to represent player 1: ") #getting the first character input
        while len(char1)!=1 or char1==" ":
            print("Invalid data entry, please try again.")
            char1 = input("Enter a character to represent player 1: ")
        char2 = input("Enter a character to represent player 2: ") #getting the second character input
        while len(char2)!=1 or char2==" " or char2==char1: #characters length cannot more than 1 and they cannot be same
            print("Invalid data entry, please try again.")
            char2 = input("Enter a character to represent player 2: ")
        while True:
            try:
                row_column= int(input("Enter the row/column number of the playing field(4-8): "))
                while row_column<MIN_ROW_COLUMN or row_column>MAX_ROW_COLUMN:
                    print("Invalid data entry, please try again.")
                    row_column = int(input("Enter the row/column number of the playing field(4-8): "))
            except ValueError:
                print("Invalid data entry, please try again.")
            else:
                break
        LETTERS = "ABCDEFGH"
        column_letters=[]
        for i in range(row_column): #creates the list of letters for the columns on the board
            column_letters.append(LETTERS[i])
        row_numbers= []
        for m in range(row_column): #creates the list of numbers for the rows on the board
            row_numbers.append(m+1)
        table = create_table(row_column, char1, char2)
        display_table(row_column, column_letters,table)  # displaying the starting version of the board
        winner=move_stone(row_column, char1, char2, column_letters) #calling the move_stone function to play 1 round until a player wins
        print(f"Player {winner} won the game. Congratulations.")  #prints the winner player
        replay=input("Would you like to play again? (y/Y/n/N): ") #asking the player if they want to play another round
        while replay not in "yYnN":
            print("Invalid data entry, please try again.")
            replay = input("Would you like to play again? (y/Y/n/N): ")
main() #calling the main function to start the program




