require "byebug"
module Stepping

  def get_moves(diff)
    byebug
    possible_moves = []
    diff.each do |shift|
      x = @current_pos[0] + shift[0]
      y = @current_pos[1] + shift[1]
      possible_moves << [[x, y]]
    end

    possible_moves
  end

end
