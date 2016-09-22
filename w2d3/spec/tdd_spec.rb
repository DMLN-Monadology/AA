require 'rspec'
require 'tdd'
require 'towers'

describe "#my_uniq" do
  it "should remove duplicates" do
    array = [1,2,3,3,1,2,5,4,4]
    expect(array.my_uniq).to eq([1,2,3,5,4])
  end

  it "should not augment array if all elements are unique" do
    array = (1..5).to_a
    expect(array.my_uniq).to eq(array)
  end

end

describe "#two_sum" do

  it "should return pairs correctly ordered ascending" do
    array = [-1, 0, 2, -2, 1]
    expect(array.two_sum).to eq([[0, 4], [2, 3]])
  end

  it "should return empty array when no pairs exist" do
    array = [1,2,3,4,5]
    expect(array.two_sum).to be_empty
  end

  it "should return smaller second elements first" do
    array = [1, -1, -1, 5]
    expect(array.two_sum).to eq([[0,1], [0,2]])
  end
end

describe "#my_tranpose" do

  it "should tranpose correctly" do
    array = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8]
  ]
    expect(array.my_tranpose).to eq([[0, 3, 6],
                                    [1, 4, 7],
                                    [2, 5, 8]])
                                  end

  it "should not modify original array" do
    array = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8]
  ]
  array.my_tranpose
  expect(array).to eq([
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8]
])
  end
end

describe "#stock_picker" do

  it "should output the highest profitable pair" do
    stock_prices = [1,4,3,6,2,7,34,8,9]
    expect(stock_prices.stock_picker).to eq([0,6])
  end

  it "should not sell before buying" do
    stock_prices = [34,4,3,6,2,7,1,8,9]
    output = stock_prices.stock_picker
    expect(output[0]).to be < output[1]
  end


end

describe Towers do

  let(:towers) do (Towers.new)
  end

  describe '#initialize' do
    it "should create three towers with the first tower containing 4 pieces" do
      expect(towers.piles).to eq([[4, 3, 2, 1], [], []])
    end
  end

  describe '#move' do
    it "should move the disc when valid" do
      towers.move(0, 1)
      expect(towers.piles).to eq([[4, 3, 2], [1], []])
    end

    it "should not place larger discs on smaller discs" do
      towers.move(0, 1)
      expect { towers.move(0, 1) }.to raise_error("Can't place disc")
    end

    it "should raise error if given non existent first pile" do
      expect { towers.move(-3, 2)}.to raise_error("nonexistent pile")
    end

    it "should raise error if given non existent second pile" do
      expect { towers.move(0, 10)}.to raise_error("nonexistent pile")
    end

    it "should raise error if selecting a first pile with a no discs" do
      expect { towers.move(1,2) }.to raise_error("no discs in that pile")
    end
  end

  describe '#won?' do
    it "should return false on initialize" do
      expect(towers.won?).to be false
    end

    it "should return true when won" do
      towers.piles = [[], [4, 3, 2, 1], []]
      expect(towers.won?).to be true
    end

    it "should return false when it has not won" do
      towers.move(0,1)
      towers.move(0,2)
      towers.move(1,2)
      expect(towers.won?).to be false
    end 


end




end
