class Towers
  attr_accessor :piles

  def initialize
    @piles = [[4, 3, 2, 1], [], []]
  end

  def play
    until won?
      p @piles
      puts "from which pile would you like to move?"
      from = gets.chomp.to_i
      puts "to which pile would you like the piece moved?"
      to = gets.chomp.to_i
      move(from,to)
    end
  end

  def move(from, to)
    unless (0..2).include?(from) && (0..2).include?(to)
      raise("nonexistent pile")
    end
    if !@piles[to].empty? && !(@piles[from].last < @piles[to].last)
      raise("Can't place disc")
    end
    raise("no discs in that pile") if @piles[from].empty?
    @piles[to].push(@piles[from].pop)
  end

  def won?
    @piles[0].empty? && ( @piles[1] == [4,3,2,1] || @piles == [4,3,2,1]  )
  end
end

# it "should raise error if selecting a first pile with a no discs" do
#   expect { towers.move(1,2) }.to raise_error("no discs in that pile")
# end

# a = Towers.new
# a.play
