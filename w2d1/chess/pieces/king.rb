require_relative 'piece'
require_relative "stepping"

class King < Piece
  include Stepping

  MOVE_DIFF = [
   [-1, -1],
   [-1,  1],
   [-1, -1],
   [-1,  1],
   [ 1, -1],
   [ 1,  1],
   [ 1, -1],
   [ 1,  1]
  ]

  # moves = get_moves(@moves_diff)

end
