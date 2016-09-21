class Piece

  attr_reader :move_diff

  def initialize(current_pos, color, board = [])
    @moves = []
    @current_pos = current_pos
    @color = color
    @board = board
    @move_diff = nil
  end

  def valid_moves(pos, color, board)
    pos = inbound(pos)
    pos = not_occupied(pos, color, board)
  end

  def inbound(pos)
    pos.map do |direction|
      direction.select do |pos|
        in_bounds?(pos)
      end
    end
  end

  def in_bounds?(destination)
    destination.all? {|ele| ele >= 0 && ele <= 7 }
  end

  # def not_occupied(pos, color)
  #   pos.map do |direction|
  #     direction.each_with_index do |pos, idx|
  #
  #       # if its not empty?
  #       #   then check the color
  #       #   if color doesn't match
  #       #     then break




end
