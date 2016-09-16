class Tile
  attr_reader :bomb, :hidden, :flag
  attr_accessor :value

  def initialize(bomb)
    @bomb = bomb
    @value = 0   #empty, or number of mines nearby
    @hidden = true
    @flag = false
  end

  def reveal
    @hidden = false
  end

  def set_flag
    @flag = !@flag
  end
end
