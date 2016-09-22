require 'rspec'
require 'game'

describe Card do
  describe '#initalize' do

    it "should set value and suit" do
      card=Card.new(13, :spade)
      expect(card.value).to eq(13)
      expect(card.suit).to eq(:spade)
    end

    it "should not initialize when given invalid value" do
        expect {Card.new(100, :heart)}.to raise_error("invalid value")
    end

    it "should not initialize when given invalid suit" do
        expect {Card.new(10, :ruby)}.to raise_error("invalid suit")
    end

  end


end

describe Deck do
  subject(:deck) {Deck.new}
  describe '#initialize' do


    it "should make a 52 card deck" do
      expect(deck.deck.length).to eq(52)
    end

    it "should be shuffled" do
      new_deck = Deck.new
      expect(deck.deck).not_to eq(new_deck.deck)
    end

    it "should have 13 of each suit" do
      sample = [:spade, :heart, :diamond, :club].sample
      expect(deck.deck.count {|card| card.suit == sample}).to eq(13)
    end

    it "should have 4 of each value" do
      sample = rand(1..13)
      expect(deck.deck.count {|card| card.value == sample}).to eq(4)
    end
  end

  describe "#draw" do
    it "draws a card" do
      expect(deck.draw.class).to eq(Card)
    end

    it "removes a card" do
      deck.draw
      expect(deck.deck.length).to eq(51)
    end
  end

end

describe Hand do
  subject(:deck) {Deck.new}
  subject(:hand) {Hand.new(deck)}


  subject(:ace_heart) {Card.new(1, :heart)}
  subject(:king_heart) {Card.new(13, :heart)}
  subject(:queen_heart) {Card.new(12, :heart)}
  subject(:jack_heart) {Card.new(11, :heart)}
  subject(:ten_heart) {Card.new(10, :heart)}

  subject(:ace_spade) {Card.new(1, :spade)}
  subject(:king_spade) {Card.new(13, :spade)}
  subject(:queen_spade) {Card.new(12, :spade)}
  subject(:jack_spade) {Card.new(11, :spade)}
  subject(:ten_spade) {Card.new(10, :spade)}

  subject(:two_spade) {Card.new(2, :spade)}
  subject(:three_spade) {Card.new(3, :spade)}
  subject(:four_spade) {Card.new(4, :spade)}
  subject(:five_spade) {Card.new(5, :spade)}
  subject(:six_spade) {Card.new(6, :spade)}

  subject(:king_diamond) {Card.new(13, :diamond)}

  subject(:king_club) {Card.new(13, :club)}


  describe '#initialize' do

    it 'should initialize with 5 cards drawn' do
      expect(hand.cards.length).to eq(5)
    end
  end

  describe '#calculate_hand' do

    it 'should return the high card as the hand' do
      hand.cards = [king_heart, ace_heart, jack_heart , ten_heart , five_spade]
      expect(hand.hand).to eq(:high_card)
    end

    it 'should return pair if a pair is owned ' do
      hand.cards = [king_heart, king_spade, jack_heart , ten_heart , five_spade]
      expect(hand.hand).to eq(:pair)
    end

    it 'should return two pair if 2 pairs is owned ' do
      hand.cards = [king_heart, king_spade, jack_heart , jack_spade, five_spade]
      expect(hand.hand).to eq(:two_pair)
    end

    it 'should return three of a kind if owned ' do
      hand.cards = [king_heart, king_spade, king_diamond, five_spade, jack_spade]
      expect(hand.hand).to eq(:three_of_a_kind)
    end

    it 'should return straight if owned ' do
      hand.cards = [king_heart, queen_spade, jack_heart, ten_spade, ace_heart]
      expect(hand.hand).to eq(:straight)
    end

    it 'should return flush if owned' do
      hand.cards = [two_spade, three_spade, four_spade, ace_spade, king_spade]
      expect(hand.hand).to eq(:flush)
    end

    it 'should return full_house if owned' do
      hand.cards = [king_heart, king_diamond, king_spade, queen_heart, queen_spade]
      expect(hand.hand).to eq(:full_house)
    end

    it 'should return four of a kind if owned' do
      hand.cards = [king_heart, king_spade, king_diamond, king_club, two_spade]
      expect(hand.hand).to eq(:four_of_a_kind)
    end

    it 'should return straight_flush' do
      hand.cards = [ace_spade, two_spade, three_spade, four_spade, five_spade]
      expect(hand.hand).to eq(:straight_flush)
    end

    it 'should return royal flush' do
      hand.cards = [ace_heart, king_heart, queen_heart, jack_heart, ten_heart]
      expect(hand.hand).to eq(:royal_flush)
    end

    it 'should return the highest card in hand' do
      hand.cards = [king_diamond, two_spade, queen_spade, jack_heart, ten_heart]
      expect(hand.hand).to eq(:high_card)
    end

  end



  describe '#best_hand' do

    subject(:deck) {Deck.new}

    it 'should return the ordinally higher hand' do
      full_house = Hand.new(deck)
      full_house.cards = [king_heart, king_diamond, king_spade, queen_heart, queen_spade]
      straight = Hand.new(deck)
      straight.cards = [king_heart, queen_spade, jack_heart, ten_spade, ace_heart]
      expect(Hand.best_hand(full_house, straight)).to eq(full_house)
    end

    it 'should handle ties with values when hands tie ordinally ' do
      stronger_straight = Hand.new(deck)
      stronger_straight.cards = [king_heart, queen_spade, jack_heart, ten_spade, ace_heart]
      weaker_straight = Hand.new(deck)
      weaker_straight.cards = [two_spade, three_spade, four_spade, five_spade, ace_heart]
      expect(Hand.best_hand(stronger_straight, weaker_straight)).to eq(stronger_straight)
    end

    it 'should handle ties with suits when hands tie ordinally' do
      stronger_straight = Hand.new(deck)
      stronger_straight.cards = [king_heart, queen_spade, jack_heart, ten_heart, ace_spade]
      weaker_straight = Hand.new(deck)
      weaker_straight.cards = [king_spade, queen_heart, jack_spade, ten_spade, ace_heart]
      expect(Hand.best_hand(stronger_straight, weaker_straight)).to eq(stronger_straight)
    end
  end

end


describe Player do
  subject(:deck) {Deck.new}
  subject(:player) {Player.new(deck)}
  describe '#initialize' do

    it 'initializes with a hand' do
      expect(player.hand.cards.length).to eq(5)
    end

    it 'initializes with wallet' do
      expect(player.wallet.class).to be(Fixnum)
    end

  end

  describe '#discard' do

    it 'discard cards & replaces when prompted to' do
      cards_to_go = player.hand[0..2]
      to_go = [0,1,2]
      player.discard(to_go)
      expect(player.hand[0..2]).to_not eq(cards_to_go)
    end

  end

end
