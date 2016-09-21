require_relative "board"
require_relative "cursor"
require "colorize"
require "byebug"

class Display
  attr_reader :cursor, :board

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @board = board
  end

  def render
    system("clear")
    puts "  " + (0..7).to_a.join(" ")
    build_grid.each_with_index do |row, idx|
      print "#{idx} "
      puts row.join(" ")
    end
  end

  def build_grid
    @board.board.map.with_index do |row, row_idx|
      build_row(row, row_idx)
    end
  end

  def build_row(row, row_idx)
    row.map.with_index do |piece, col_idx|
      color_options = give_colors(row_idx, col_idx)
      if piece == "_"
        piece.to_s.colorize(color_options)
      else
        piece.symbol.colorize(color_options)
      end 
    end
  end

  def give_colors(row_idx, col_idx)
    # byebug
    if [row_idx, col_idx] == @cursor.cursor_pos
      bg = :yellow
    #elsif
    else
      bg = :blue
    end
    { :background => bg }
  end


  def explore
    while true
      @cursor.get_input
      render
    end
  end

end

if __FILE__== $PROGRAM_NAME
  a = Board.new
  b = Display.new(a)
  b.explore
end
