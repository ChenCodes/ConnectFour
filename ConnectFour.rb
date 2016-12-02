require 'matrix'

class ConnectFour
    
    
    def initialize(board_size, current_turn)
        @winner = "None"
        @moves = 0
        @winner_found = false
        @board_size = board_size
        @board = Array.new(board_size) {Array.new(board_size, '*')}
        @current_turn = current_turn
        @max_number_of_moves = board_size * board_size
    end
        
    #Show the board in ASCII
    
    def show_board
        print("\n")
        @board.each do |array|
            print(array.to_s.gsub('"', ''))
            print("\n")
        end
    end   

    #Show the winner of the game
    def show_winner
        print(@winner)
    end
    
    #When play is called, the game will continue until either a player has won or the game has ended in a draw. 
    
    def play()
        while(!@winner_found)
            if @moves == @max_number_of_moves
                break
            end
            #each player will select a random column to drop a piece in 
            move(rand(@board_size))
        end
        if @winner_found
            print("#{@winner}" +  " has won!")
        else 
            print("This game has ended in a tie.")
        end
        show_board()
    end
            
    
    #A move can only be inserted into a specific column 
    
    def move(column)
        if valid_move(column) 
            set_move(column)
            check_win()
            switch_player()
            @moves += 1
        end
    end
    
        
    #If the highest row has a piece that is taking up the specified column, then the move will be considered invalid 
    
    def valid_move(column) 
        if @board[0][column] == "*" and column <= @board_size and column >= 0
            return true
        else 
            return false
        end
    end
    
    #Check which row we should place the piece in, if a row already has a piece in it, we have to check the row above it to see if there is space 
    
    def set_move(column)
        (@board_size - 1).downto(0).each do |row|
            if @board[row][column] == '*'
                @board[row][column] = @current_turn
                return true
            end
        end
        return false 
    end
    
    
    
    #Switch between each player
    def switch_player()
        if @current_turn == "o"
            @current_turn = "x"
        elsif @current_turn == "x"
            @current_turn = "o"
        end
    end
     
    #Determine if a player has just won after performing a move
    
    def check_win()
        #If we have found four in a row in either the diagonals, rows, or columns, then return true immediately
        if check_columns() or check_rows or check_diagonals(populate_diagonals)
            return true
        else 
            return false
        end
    end
    
    
    def populate_diagonals()
        diagonalsArray = []
        row = 0
        while(row < @board_size)
            currentArray = find_diagonals_helper(row, @board)
            row += 1
            diagonalsArray.push(currentArray)
        end
        col = 1
        while(col < @board_size)
            currentArray = find_diagonals_helper_2(col, @board)
            col += 1
            diagonalsArray.push(currentArray)
        end
        
        flippedBoard = []
        @board.each do |array|
            flippedBoard.push(array.reverse)
        end
        
        row = 0
        while(row < @board_size)
            currentArray = find_diagonals_helper(row, flippedBoard)
            row += 1
            diagonalsArray.push(currentArray)
        end
        col = 1
        while(col < @board_size)
            currentArray = find_diagonals_helper_2(col, flippedBoard)
            col += 1
            diagonalsArray.push(currentArray)
        end
        return diagonalsArray
    end
        
    
    
    
    def find_diagonals_helper(row, board)
        col = 0
        rowTemp = row
        currentArray = []
        while(rowTemp >= 0)
            currentArray.push(board[rowTemp][col])
            rowTemp -= 1
            col+= 1
        end    
        return currentArray
    end
    
    def find_diagonals_helper_2(col, board)
        colTemp = col
        row = @board_size - 1
        currentArray = []
        while(colTemp <= @board_size - 1)
            currentArray.push(board[row][colTemp])
            row -= 1
            colTemp += 1
        end
        return currentArray
    end
    
    
    #Check the diagonals for wins 
    def check_diagonals(finalArray)
        diagonalArray = []
        #Filter out only the diagonals that have four or more elements 
        finalArray.each do |element|
            if element.length >= 4
                diagonalArray.push(element)
            end
        end
        
        diagonalArray.each do |array|
            consecutive_pieces = Hash.new(0)
            previous = -1
            array.each do |element|
                if previous == -1 
                    previous = element
                    consecutive_pieces[element] = 1
                elsif previous == element
                    consecutive_pieces[element] += 1
                elsif previous != element
                    consecutive_pieces[element] = 1
                    previous = element
                end
                if check_winner(consecutive_pieces)
                    return true
                end
            end
        end
        return false
    end
    
    #Check the rows for winners 
    
    def check_rows()
        for i in 0 .. @board_size - 1
            consecutive_pieces = Hash.new(0)
            previous = -1
            @board[i].each do |element|
                if previous == -1 
                    previous = element
                    consecutive_pieces[element] = 1
                elsif previous == element
                    consecutive_pieces[element] += 1
                elsif previous != element
                    previous = element
                    consecutive_pieces[element] = 1
                end
                if check_winner(consecutive_pieces)
                    return true
                end
            end
        end
        return false
    end

    #Check the columns for winners 
    def check_columns()
        column_arrays = []
        for i in 0 .. @board_size - 1
            column_arrays.push(@board.map {|row| row[i]})
        end
        
        column_arrays.each do |array|
            consecutive_pieces = Hash.new(0)
            previous = -1
            array.each do |position|    
                if previous == -1 
                    previous = position
                    consecutive_pieces[position] = 1
                elsif previous == position
                    consecutive_pieces[position] += 1
                elsif previous != position
                    previous = position 
                    consecutive_pieces[position] = 1
                end
                
                if check_winner(consecutive_pieces)
                    return true
                end
            end
        end
        return false
    end
    end



    #Helper method that cleans up the code a little, returns true if a player has won, thus ending the game 
    
    def check_winner(hash)
        if hash["o"] == 4 
            @winner_found = true
            @winner = "Player o"
            return true
        else if hash["x"] == 4
            @winner_found = true
            @winner = "Player x"
            return true
        end
        return false
    end


end

board = ConnectFour.new(5, "o")
#Calling the line below will start a game 
board.play








