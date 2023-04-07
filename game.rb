# frozen_string_literal: true

module HandleBoard
  private

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

  # convert numpad to index
  def numpad_to_index(numpad)
    row = 2 - ((numpad - 1) / 3)
    column = (numpad - 1) % 3
    [row, column]
  end

  # return matching value if all values in array match
  def match_value(array)
    return array[0] if array.uniq.length == 1
    # if not matching return -1
    -1
  end
  
  def find_winner(_board)
    # initialize array to store columns for winner check
    columns = [[], [], []]
    col_idx = 0
    # initialize variable for counting empty spaces
    empty_spaces = 9
    _board.each_with_index do |row, _row_idx|
      # return the value if row is all same and not zero
      matching_value = match_value(row)
      return matching_value if matching_value.positive?

      # construct arrays of columns for matching later
      row.each_with_index do |place, col_idx|
        columns[col_idx].push(place)
        empty_spaces -= 1 if place.zero?
      end
    end
    columns.each do |column|
      # return the value if column is all same and not zero
      matching_value = match_value(column)
      return matching_value if matching_value.positive?
    end
    # criss cross not possible if middle seat isn't taken
    return 0 if (board[1][1]).zero?

    # check if criss or cross match
    criss = [board[0][0], board[1][1], board[2][2]]
    cross = [board[2][0], board[1][1], board[0][2]]
    [criss, cross].each do |row|
      matching_value = match_value(row)
      return matching_value if matching_value.positive?
    end

    # return -1 if tie game
    return -1 if empty_spaces == 9

    # return 0 for no winner
    0
  end
end

class Game
  include HandleBoard
  # start game
  def start
    # begin first turn before loop
    play_turn
    loop do
      # check for winner
      winner = find_winner(board)
      if winner != 0
        print_board
        print_winner(winner)
        break
      end
      # play turn in a loop until winner check succeeds
      play_turn
    end
  end

  private

  def initialize
    @board = [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0]
    ]
  end
  attr_reader :board
  attr_accessor :player

  def print_board
    draw_board(board)
  end

  def print_winner(winner)
    if winner == -1
      puts "It's a tie!"
      return
    end
    winner_char = winner == 1 ? 'x' : 'o'
    puts "#{winner_char} wins!"
  end

  def get_choice
    loop do
      player_choice = gets.chomp
      # check if input is number
      is_valid_number = !player_choice.match(/\A[0-9]\Z/).nil?
      # check if input already placed
      is_not_taken = true
      # check if spot has already been taken
      if is_valid_number
        player_choice
        row, column = numpad_to_index(player_choice.to_i)
        is_not_taken = !is_taken?(board[row][column])
      end
      # return player integer if valid input
      return player_choice.to_i if is_valid_number && is_not_taken

      # display numpad for reference if not a valid number
      unless is_valid_number
        puts 'Use the numpad format to select a placement:'
        puts '789'
        puts '456'
        puts '123'
      end
      puts 'Placement has already been taken.' unless is_not_taken
    end
  end

  # call next turn recursively until winner
  def play_turn
    # swap player
    @player = (@player == 1 ? 2 : 1)
    # get player choice
    letter = @player == 1 ? 'x' : 'o'
    print_board
    puts "#{letter}'s turn. Enter a numpad key to place an #{letter}."
    # get player choice
    player_choice = get_choice
    # place player choice on board
    place_choice(board, player, player_choice)
  end
end

# create game instance and start
game = Game.new
game.start
