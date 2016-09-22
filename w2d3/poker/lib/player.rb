require_relative 'hand'
class Player
  attr_reader :hand, :wallet
  def initialize(deck)
    @hand = Hand.new(deck)
    @wallet = 100
  end
end
