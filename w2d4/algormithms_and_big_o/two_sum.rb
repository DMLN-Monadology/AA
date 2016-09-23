require 'benchmark'

def bad_two_sum(array, target)
  array.each_with_index do |el1, idx1|
    array.each_with_index do |el2, idx2|
      next if idx2 <= idx1

      return true if el1 + el2 == target
    end
  end

  false
end # O(n^2)

def ok_two_sum(array, target)
  array.sort!
  start = 0
  finish = array.length - 1

  until start == finish
    if array[start] + array[finish] < target
      start += 1
    elsif array[start] + array[finish] > target
      finish -= 1
    else # they have to equal here
      return true
    end
  end
  false
end # O(n log n)


def pair_sum?(array, target)
  hash = Hash.new([])

  array.each_with_index do |ele, idx|
    hash[ele] = idx
  end

  array.each_with_index do |ele, idx|
    return true if hash[ele] != idx
  end
  false
end # O(n)

[1000, 10_000, 1_000_000, 10_000_000].each do |size|

  # array0 = Array.new(size/5, 0)
  # array1 = Array.new(size/5, 1)
  # array2 = Array.new(size/5, 2)
  # array3 = Array.new(size/5, 3)
  # array4 = Array.new(size/5, 4)
  # array = array0 + array1 + array2 +array3 +array4
  # array << 5 << 5
  array = (1..size).to_a.shuffle
  target = 10
  Benchmark.bm(3) do |x|
    puts "testing #{size}..."
    # x.report("bad_two_sum:") { bad_two_sum(array, target) }

    x.report("ok_two_sum:") { ok_two_sum(array, target)  }

    x.report("pair_sum:") { pair_sum?(array, target)   }
  end
end
