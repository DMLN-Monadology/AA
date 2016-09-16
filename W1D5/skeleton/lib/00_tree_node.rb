  # require 'byebug'

class PolyTreeNode

  attr_reader :value, :parent
  attr_accessor :children

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent= (parent)
    if parent != @parent
      old_parent = @parent
      @parent = parent
      unless parent.nil? || parent.children.include?(self)
        parent.add_child(self)
      end

      old_parent.children.delete(self) unless old_parent.nil?
    end
  end

  def add_child(child_node)
    @children << child_node
    child_node.parent = self
  end

  def remove_child(child_node)
    if !@children.include?(child_node)
      raise "#{child_node} is not a child of #{self}"
    end
    @children.delete(child_node)
    child_node.parent = nil
  end

  def dfs(target_value)
    return self if @value == target_value

    @children.each do |child|
      answer = child.dfs(target_value)
      return answer if answer
    end

    nil
  end

  def bfs(target_value)
    queue = [self]

    until queue.empty?
      current_node = queue.shift
      return current_node if current_node.value == target_value
      queue += current_node.children
    end
    nil
  end

end
