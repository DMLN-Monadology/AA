require_relative 'pieces'

class Board

  attr_accessor :board

  def initialize
    @board = populated_board

  end

  def populated_board
    @board = Array.new(8) { Array.new(8) {"_"} }
    @board[2][2] = Knight.new([2,2], :white)
    @board
  end

  def move(start, end_pos)
    if start == nil
      raise "please enter a valid pos"   #rescue when we call move
    elsif @board[start].color == @board[end_pos].color #make colour attribute for pieces
      raise "You can't kill your own men!"
    end

    piece = @board[start]
    @board[start] = NullPiece
    @board[end_pos] = piece
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def self.in_bounds?(destination)
    destination.all? {|ele| ele >= 0 && ele <= 7 }
  end

  def dup
    @board.dup
  end

end
