class Array

  def my_uniq
    array = []
    self.each do |ele|
      array.push(ele) unless array.include?(ele)
    end
    array
  end

  def two_sum
    pairs = []
    self.each_with_index do |el1, idx1|
      self.each_with_index do |el2, idx2|
        if idx1 >= idx2
          next
        end
        if el1 + el2 == 0
          pairs.push([idx1, idx2])
        end
      end
    end
    pairs
  end

  def my_tranpose
    columns = []
    idx = 0
    while idx < self.count
      one_col = []
      self.each do |row|
        one_col.push(row[idx])
      end
      columns << one_col
      idx += 1
    end
    columns
  end

  def stock_picker
    pairs = []
    profit = 0
    self.each_with_index do |el1, idx1|
      self.each_with_index do |el2, idx2|
        if idx1 >= idx2
          next
        end
        if el2 - el1 > profit
          profit = el2 - el1
          pairs = [idx1, idx2]
        end
      end
    end
    pairs
  end
end
