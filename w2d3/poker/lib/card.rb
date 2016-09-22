class Card

  attr_reader :suit
  attr_accessor :value

  def initialize(value, suit)
    suits = [:heart, :spade, :diamond, :club]
    raise "invalid value" if !(1..13).include?(value)
    raise "invalid suit" if !suits.include?(suit)
    @value = value
    @suit = suit
  end



end
