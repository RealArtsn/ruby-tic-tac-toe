# frozen_string_literal: true

module HandleBoard
  SYMBOLS = { 0 => '+', 1 => 'x', 2 => 'o' }.freeze
  def draw_board(board)
    puts ''
    board.each do |row|
      row.each { |tile| print SYMBOLS[tile] }
      puts
    end
    puts ''
  end

  # check if player has already selected spot
  def is_taken?(tile)
    tile != 0
  end

  # change board to reflect player choice
  def place_choice(board, player, numpad)
    row, column = numpad_to_index(numpad)
    current_tile = board[row][column]
    # raise exception if current tile has already been selected
    raise StandardError unless current_tile.zero?

    board[row][column] = player
  end

  def numpad_to_index(numpad)
    # messy translation from numpad to board
    row = nil
    column = nil
    case numpad
    when 1 then row = 2
                column = 0
    when 2 then row = 2
                column = 1
    when 3 then row = 2
                column = 2
    when 4 then row = 1
                column = 0
    when 5 then row = 1
                column = 1
    when 6 then row = 1
                column = 2
    when 7 then row = 0
                column = 0
    when 8 then row = 0
                column = 1
    when 9 then row = 0
                column = 2
    end
    [row, column]
  end

  def find_winner(_board)
    0
  end
end

class Game
  include HandleBoard
  def initialize
    @board = [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0]
    ]
  end
  attr_reader :board, :already_placed
  attr_accessor :player

  def print_board
    draw_board(board)
  end

  def start
    player = 2
    print_board
    next_turn
  end

  def game_winner
    find_winner(board)
  end

  private

  def get_choice
    loop do
      player_choice = gets.chomp
      # check if input is number
      is_number = !player_choice.match(/\A[0-9]\Z/).nil?
      p is_number
      # check if input already placed
      is_not_taken = true
      if is_number
        player_choice
        row, column = numpad_to_index(player_choice.to_i)
        is_not_taken = !is_taken?(board[row][column])
      end
      return player_choice.to_i if is_number && is_not_taken

      unless is_number
        puts 'Use the numpad format to select a placement:'
        puts '789'
        puts '456'
        puts '123'
      end
      puts 'Placement has already been taken.' unless is_not_taken
    end
  end

  # call next turn recursively until winner
  def next_turn
    # swap player
    @player = (@player == 1 ? 2 : 1)
    # get player choice
    letter = @player == 1 ? 'x' : 'o'
    puts "#{letter}'s turn. Enter a numpad key to place an #{letter}."
    # get player choice
    player_choice = get_choice
    # place player choice on board
    place_choice(board, player, player_choice)
    print_board
    next_turn unless game_winner.positive?
  end
end

game = Game.new
game.start
