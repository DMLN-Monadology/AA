require "byebug"

module Sliding

  ANYTHING = "anything"

  def make_horizontal_diff
    diffs = []
    pos_steps = (1..7).to_a
    neg_steps = (-7..-1).to_a.reverse
    x_direction_pos = pos_steps.map {|step1| steps = [step1, 0]}
    y_direction_pos = pos_steps.map {|step1| steps = [0, step1]}
    diffs << x_direction_pos << y_direction_pos

    x_direction_neg = neg_steps.map {|step1| steps = [step1, 0]}
    y_direction_neg = neg_steps.map {|step1| steps = [0, step1]}
    diffs << x_direction_neg << y_direction_neg

    diffs
  end


  def make_diagonal_diff
    diffs = []
    x_directions = [-1, 1]
    y_directions = [-1, 1]
    x_directions.each do |x_direction|
      y_directions.each do |y_direction|
        one_direction_diffs = (1..7).to_a.map do |diff|
          diff = [x_direction*diff,y_direction*diff]
        end
        diffs << one_direction_diffs
      end
    end
    diffs
  end



  def get_moves#(diff) #diff = nested array of diffs separated according to directions
    # byebug
    case self.class.to_s.to_sym
    when :Queen
      diff = make_diagonal_diff + make_horizontal_diff
    when :Bishop
      diff = make_diagonal_diff
    when :Rook
      diff = make_horizontal_diff
    end

    possible_moves = diff.map do |direction|
      direction.map do |pos|
        pos = [pos[0] + @current_pos[0], pos[1] + @current_pos[1]]
      end
    end

    possible_moves
  end

end
