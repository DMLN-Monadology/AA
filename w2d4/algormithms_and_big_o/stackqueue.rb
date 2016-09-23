class MyQueue
  def initialize
    @store = []
  end

  def enqueue(ele)
    @store.unshift(ele)
  end

  def dequeue(ele)
    @store.pop
  end

  def peek
    @store.last
  end

  def size
    @store.count
  end

  def empty?
    @store.empty?
  end

end



class MyStack
  def initialize
    @store = []
  end

  def pop
    @store.pop[0]
  end

  def push(ele)
    if empty?
      new_max = ele
      new_min = ele
    else
      new_max = (ele > max ? ele : max)
      new_min = (ele < min ? ele : min)
    end
    @store << [ele, new_min, new_max]
  end

  def peek
    return nil if empty?
    @store.last[0]
  end

  def size
    @store.count
  end

  def empty?
    @store.empty?
  end

  def max
    return nil if empty?
    @store.last[2]
  end

  def min
    return nil if empty?
    @store.last[1]
  end
end





class MinMaxStackQueue

  def initialize
    @in_box = MyStack.new
    @out_box = MyStack.new
  end

  def dequeue
    transfer if @out_box.empty?

    @out_box.pop
  end

  def enqueue(ele)
    @in_box.push(ele)

  end

  def peek
    transfer if @out_box.empty?

    @out_box.peek
  end

  def size
    @in_box.size + @out_box.size
  end

  def empty?
    @out_box.empty? && @in_box.empty?
  end

  def max
    return nil if empty?
    max_array = []
    max_array << @out_box.max unless @out_box.empty?
    max_array << @in_box.max unless @in_box.empty?
    max_array.max
  end

  def min
    return nil if empty?
    min_array = []
    min_array << @out_box.min unless @out_box.empty?
    min_array << @in_box.min unless @in_box.empty?
    min_array.min
  end

  private

  def transfer
    until @in_box.empty?
      @out_box.push(@in_box.pop)
    end
  end
end
