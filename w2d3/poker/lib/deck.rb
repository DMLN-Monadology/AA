require_relative 'card'

class Deck

  attr_reader :deck

  def initialize
    @deck = populate_deck
  end

  def populate_deck
    deck = []
    values = (1..13).to_a
    suits = [:heart, :spade, :diamond, :club]
    suits.each do |suit|
      values.each do |value|
        deck.push(Card.new(value, suit))
      end
    end
    deck.shuffle!


  end

  def draw
    @deck.pop
  end

end


# value, suit)
