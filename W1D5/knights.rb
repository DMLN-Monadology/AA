require_relative 'skeleton/lib/00_tree_node'
require 'byebug'
class KnightPathFinder

  attr_accessor :root, :visited_positions

  def initialize(pos = [0,0])
    @pos = pos
    @visited_positions = [pos]
  end

  def self.valid_moves(pos)
    valid_moves = []
    long_moves = [-2, 2]
    short_moves = [-1, 1]
    long_moves.each do |long_move|
      short_moves.each do |short_move|
        move1 = [pos[0] + long_move, pos[1] + short_move]
        move2 = [pos[0] + short_move, pos[1] + long_move]
        valid_moves += [move1, move2]
      end
    end

    valid_moves.select do |move|
      move.all? do |cord|
        cord >= 0 && cord <= 7
      end
    end
  end

  def new_move_positions(pos)
    unvisited_moves = self.class.valid_moves(pos).reject do |position|
      @visited_positions.include?(position)
    end

    @visited_positions += unvisited_moves
    unvisited_moves
  end

  def build_move_tree
    @root = PolyTreeNode.new(@pos)
    queue = [@root]

    until queue.empty?
      current_node = queue.shift
      children_list = new_move_positions(current_node.value)
      children_list.each do |child|
        child_node = PolyTreeNode.new(child)
        current_node.add_child(child_node)
        child_node.parent = current_node
        queue << child_node
      end
    end
  end

  def find_path(end_pos)
    end_node = @root.bfs(end_pos)
    trace_path_back(end_node)
  end

  def trace_path_back(end_node)
    if end_node.parent == nil
      end_node.value
    else
      [end_node.value] << trace_path_back(end_node.parent)
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  tester = KnightPathFinder.new
  tester.build_move_tree
  p tester.find_path([7,6])

end
