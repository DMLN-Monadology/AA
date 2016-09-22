require_relative 'card'
require_relative 'deck'
class Hand

  def self.best_hand(hand1, hand2)
    if HAND_STRENGTH[hand1.hand] > HAND_STRENGTH[hand2.hand]
      hand1
    elsif HAND_STRENGTH[hand1.hand] < HAND_STRENGTH[hand2.hand]
      hand2
    else #if they equal
      self.tie_breaker(hand1, hand2)
    end
  end

  def self.check_suit(*cards) #output card with highest suit , input up to 4
    highest = nil
    cards.each do |card|
      if highest == nil || (SUIT_STRENGTH[card.suit] > SUIT_STRENGTH[highest.suit])
        highest = card
      end
    end
    highest
  end

  def self.tie_breaker(hand1, hand2) #output hand that wins
    high_card1 = nil
    high_card2 = nil
    hand1_sorted = hand1.cards.sort {|card| card.value }
    high_card1 = hand1_sorted[-1]
    if hand1_sorted.select {|card| card.value == 1}.length > 0
      high_card1 = hand1_sorted[0]
    end

    reps1 = hand1_sorted.select {|card| card.value == high_card1.value}.length
    if reps1 > 1
      high_cards = hand1_sorted.select {|card| card.value == high_card1.value}
      high_card1 = check_suit(high_cards)
      if high_card1.value == 1
        high_card1.value == 14
      end
    end

    hand2_sorted = hand2.cards.sort {|card| card.value}
    high_card2 = hand2_sorted[-1]
    if hand2_sorted.select {|card| card.value == 1}.length > 0
      high_card2 = hand2_sorted[0]
    end
    reps2 = hand2_sorted.select {|card| card.value == high_card2.value}.length
    if reps2 > 1
      high_cards = hand2_sorted.select {|card| card.value == high_card2.value}
      high_card2 = check_suit(high_cards)
      if high_card2.value == 1
        high_card2.value == 14
      end
    end

    if high_card1.value > high_card2.value
      return hand1
    elsif high_card1.value < high_card2.value
      return hand2
    else
      if self.check_suit(high_card1, high_card2) == high_card1
        return hand1
      else
        return hand2
      end
    end
  end




  HAND_STRENGTH = {high_card:1,
                  pair:2,
                  two_pair:3,
                  three_of_a_kind:4,
                  straight:5,
                  flush:6,
                  full_house:7,
                  four_of_a_kind:8,
                  straight_flush:9,
                  royal_flush:10}

  SUIT_STRENGTH = {club:1, diamond:2, heart:3, spade:4}


  attr_accessor :cards

  def initialize(deck)
    @cards=fill_cards(deck)

  end

  def fill_cards(deck)
    hand = []
    5.times do
      hand.push(deck.draw)
    end
    hand
  end


  def hand
    if royal_flush?(@cards)
      return :royal_flush
    elsif straight_flush?(@cards)
      return :straight_flush
    elsif four_of_a_kind?(@cards)
      return :four_of_a_kind
    elsif full_house?(@cards)
      return :full_house
    elsif flush?(@cards)
      return :flush
    elsif straight?(@cards)
      return :straight
    elsif three_of_a_kind?(@cards)
      return :three_of_a_kind
    elsif two_pair?(@cards)
      return :two_pair
    elsif pair?(@cards)
      return :pair
    else
      :high_card
    end



  end

  def get_values(cards)
    card_value = []
    cards.each do |card|
      card_value.push(card.value)
    end
    card_value
  end

  def get_suits(cards)
    suits = []
    cards.each do |card|
      suits.push(card.suit)
    end
    suits
  end

  def royal_flush?(cards)
    card_value = get_values(cards)
    suits = get_suits(cards)
    card_value.sort == [1,10,11,12,13] && suits.uniq.length == 1
  end

  def straight_flush?(cards)
    straight?(cards) && flush?(cards)
  end

  def four_of_a_kind?(cards)
    values = get_values(cards)
    values.sort!
    values[0..3].uniq.length == 1 || values[1..4].uniq.length == 1
  end

  def full_house?(cards)
    three_of_a_kind?(cards) && pair?(cards)
  end

  def flush?(cards)
    suits = get_suits(cards)
    return true if suits.uniq.length == 1
    false
  end

  def straight?(cards)
    card_value = get_values(cards)
    card_value.sort!
    if card_value[0] == 1
      return true if card_value[1..4] == [10,11,12,13]
    end
    card_value.each_with_index do |value, idx|
      if idx == 4
        next
      elsif !(card_value[idx+1] == value+1)
        return false
      end
    end
    true
  end

  def three_of_a_kind?(cards)
    values = get_values(cards)
    uniques = values.uniq
    uniques.each do |value|
      return true if values.count(value) == 3
    end
    false
  end

  def two_pair?(cards)
    values = get_values(cards)
    uniques = values.uniq
    pairs = 0
    uniques.each do |value|
      pairs += 1 if values.count(value) == 2
    end
    pairs == 2
  end

  def pair?(cards)
    values = get_values(cards)
    uniques = values.uniq
    uniques.each do |value|
      return true if values.count(value) == 2
    end
    false
  end










end
