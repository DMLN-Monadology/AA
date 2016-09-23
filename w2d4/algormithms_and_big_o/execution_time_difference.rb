require 'benchmark'

def my_min(array)  #O(n^2)
  min = nil
  array.each do |ele1|
    is_min = true
    array.each do |ele2|
      is_min = false if ele2 < ele1
    end
    min = ele1 if is_min
  end
  min
end



def my_min2(array)
  min = nil
  array.each do |ele|
    if min == nil || ele < min
      min = ele
    end
  end
  min
end


def largest_subsum1(array)
  subsets = []

  array.each_index do |idx1|
    (idx1...array.length).each do |idx2|
      subsets << array[idx1..idx2]
    end
  end

  subsets.max_by {|subset|  subset.reduce(:+) }.reduce(:+)

end

def largest_subsum2(array)
  max_sum = nil
  end_ind = 0
  current_sum = 0

  array.each_with_index do |ele, idx|
    current_sum += ele
    if max_sum.nil? || current_sum > max_sum
      max_sum = current_sum
      end_ind = idx
    end
  end

  (0..end_ind).each do |idx|
    current_sum -= array[idx]
    if current_sum > max_sum
      max_sum = current_sum
    end
  end

  max_sum
end


[10, 100, 1000, 10000].each do |size|
  array = (1..size).to_a.shuffle
  Benchmark.bm(7) do |x|
    puts "testing #{size}"
    x.report("my_min1") { largest_subsum1(array)  }

    x.report("my_min2")  { largest_subsum2(array) }
  end
end
