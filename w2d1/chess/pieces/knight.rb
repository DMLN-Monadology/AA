require_relative 'piece'
require_relative "stepping"

class Knight < Piece
  include Stepping

  def symbol
    "\u2658"
  end

  MOVE_DIFF = [
   [-2, -1],
   [-2,  1],
   [-1, -2],
   [-1,  2],
   [ 1, -2],
   [ 1,  2],
   [ 2, -1],
   [ 2,  1]
  ]

end
