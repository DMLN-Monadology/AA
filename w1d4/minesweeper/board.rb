require_relative 'tile.rb'
require 'byebug'

class Board
  def initialize(number_of_mines)
    @grid = Array.new(9) { Array.new(9) }

    set_mine_positions(number_of_mines)
    make_grid
    assign_tile_values
  end

  def set_mine_positions(number_of_mines)
    @mine_positions = []
    until @mine_positions.length == number_of_mines
      pos = [rand(9), rand(9)]
      @mine_positions << pos unless @mine_positions.include?(pos)
    end
  end

  def make_grid
    @grid.each_with_index do |arr, row|
      arr.each_with_index do | _, col|
        position = [row, col]
        if @mine_positions.include?(position)
          self[position] = Tile.new(true)
        else
          self[position] = Tile.new(false)
        end
      end
    end
  end

  def assign_tile_values
    @mine_positions.each do |bomb_pos|
      adj_tiles = adjacent_tiles(bomb_pos)
      adj_tiles.each do |pos|
        tile = self[pos]
        tile.value += 1
      end
    end
  end

  def lose?
    @mine_positions.each do |mine_pos|
      bomb_tile = self[mine_pos]
      return true unless bomb_tile.hidden
    end
    false
  end

  def won?
    hidden_tiles = 0

    @grid.each_with_index do |arr, row|
      arr.each_with_index do | _, col|
        pos = [row, col]
        tile = self[pos]

        hidden_tiles += 1 if tile.hidden
      end
    end
    hidden_tiles == @mine_positions.size
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def display
    print "   "
    (0..8).each {|row| print " #{row}"}
    puts ""
    print "   "
    print " _" * 9 + "\n"
    @grid.each_with_index do |arr, row|
      print "#{row}: "
      arr.each do |tile|
        print "|#{print_tile(tile)}"
      end
      puts "|\n"
    end
  end

  def print_tile(tile)
    if tile.flag
      "F"
    elsif tile.hidden
      "#"
    elsif tile.bomb
      "*"
    elsif tile.value > 0
      "#{tile.value}"
    else
      "_"
    end
  end

  def adjacent_tiles(pos)
    row, col = pos
    adj_tiles = [
      [row + 1, col],
      [row - 1, col],

      [row, col + 1],
      [row, col - 1],

      [row + 1, col + 1],
      [row - 1, col - 1],

      [row - 1, col + 1],
      [row + 1, col - 1],
    ]
    adj_tiles.select do |position|
      (position[0] < 9 && position[0] >= 0) &&
      (position[1] < 9 && position[1] >= 0) &&
      self[position].hidden
    end
  end


  def reveal(pos)
    tile = self[pos]
    tile.reveal
    if tile.value.zero? && !tile.bomb
      adj_tiles = adjacent_tiles(pos)
      adj_tiles.each do |position|
        recursive_reveal(position)
      end
    end
  end

  def recursive_reveal(pos)

    tile = self[pos]

    if tile.bomb
      return
    elsif tile.value > 0
      tile.reveal
      return
    end

    #debugger
    tile.reveal
    if tile.value.zero? && !tile.bomb
      adj_tiles = adjacent_tiles(pos)
      adj_tiles.each do |position|
          recursive_reveal(position)
      end
    end
  end
end
