module HandleBoard
    SYMBOLS = {0=>'+', 1=>'x', 2=>'o'}
    def draw_board(board)
        board.each { |row|
            row.each {|tile| print SYMBOLS[tile]}
            puts
        }
    end
    # check if player has already selected spot
    def is_taken?(tile)
        tile != 0
    end
    # change board to reflect player choice
    def place_choice(board, player, numpad)
        row, column = nil, nil
        # messy translation from numpad to board
        case numpad
        when 1 then row, column = 2, 0
        when 2 then row, column = 2, 1
        when 3 then row, column = 2, 2
        when 4 then row, column = 1, 0
        when 5 then row, column = 1, 1
        when 6 then row, column = 1, 2
        when 7 then row, column = 0, 0
        when 8 then row, column = 0, 1
        when 9 then row, column = 0, 2
        end
        current_tile = board[row][column]
        # raise exception if current tile has already been selected
        raise Exception unless current_tile == 0
        board[row][column] = player
    end
    def find_winner(board)
        return 0
    end
end

class Game
    include HandleBoard
    def initialize()
        @board = [
            [0,0,0],
            [0,0,0],
            [0,0,0]
        ]
        @player = 2
    end
    attr_reader :board
    attr_accessor :player
    def print_board
        puts ''
        draw_board(board)
        puts ''
    end
    def start
        print_board()
        next_turn()
    end
    def game_winner()
        find_winner(board)
    end
    # call next turn recursively until winner
    def next_turn()
        # swap player
        @player = (@player == 1 ? 2 : 1)
        # get player choice
        letter = @player == 1 ? 'x' : 'o'
        puts "#{letter}'s turn. Enter a numpad key to place an #{letter}."
        player_choice = gets.chomp.to_i
        place_choice(board,player, player_choice)
        print_board()
        next_turn() unless game_winner() > 0
    end
end

game = Game.new
game.start
