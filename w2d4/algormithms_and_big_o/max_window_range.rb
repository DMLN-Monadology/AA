require_relative 'stackqueue.rb'
require 'benchmark'

def windowed_max_range(array, window_size)
  current_max_range = 0
  start = 0
  finish = window_size - 1

  while finish < array.length # O(n) ( window_size * 2 )
    max, min = array[start], array[start] # 1
    (start..finish).each do |idx| # window_size ( 2 )
      max = array[idx] if array[idx] > max
      min = array[idx] if array[idx] < min
    end

    current_max_range = max - min if max - min > current_max_range
    start += 1
    finish += 1
  end

  current_max_range
end # O((n - m) * m) => (9 / 10 n) * n / 10 = 9 n^2 / 100 = O(n^2)

# p windowed_max_range([1, 0, 2, 5, 4, 8], 2) == 4
# p windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5
# p windowed_max_range([1, 0, 2, 5, 4, 8], 4) == 6
# p windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6


def good_windowed_max_range(array, window_size)
  current_max_range = 0
  finish = window_size - 1
  st = MinMaxStackQueue.new

  (0...finish).each do |idx|
    st.enqueue(array[idx])
  end

  while finish < array.length
    st.enqueue(array[finish])
    max = st.max
    min = st.min

    current_max_range = max - min if max - min > current_max_range
    st.dequeue
    finish += 1
  end

  current_max_range
end # O(n)

# p good_windowed_max_range([1, 0, 2, 5, 4, 8], 2) == 4
# p good_windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5
# p good_windowed_max_range([1, 0, 2, 5, 4, 8], 4) == 6
# p good_windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6

[100, 1000, 10_000, 100_000].each do |size|

  array = (1..size).to_a.shuffle
  window = size / 10
  Benchmark.bm(3) do |x|
    puts "testing #{size}..."
    x.report("windowed_max_range:      ") { windowed_max_range(array, window)  }

    x.report("good_windowed_max_range: ") { good_windowed_max_range(array, window)   }
  end
end
