require_relative 'board.rb'

class Minesweeper
  def initialize(difficulty)
    if difficulty == 1
      number_of_mines = 6
    elsif difficulty == 2
      number_of_mines = 12
    elsif difficulty == 3
      number_of_mines = 20
    else
      number_of_mines = 80
    end

    @board = Board.new(number_of_mines)
  end

  def play_turn
    @board.display
    pos = get_pos
    command = get_command
    execute_command(pos, command)
  end

  def run
    play_turn until game_over?
    if @board.lose?
      puts "Xp"
      puts "You exploded!"
    else
      puts "*Puts on sunglasses*"
      puts "You found them all and lived!"
    end
  end

  def get_command
    begin
      puts "What would you like to do at that position?"
      puts "Enter 1 to reveal, 2 to flag"
      command = Integer(gets.chomp)
      until [1, 2].include?(command)
        puts "Invalid command"
        command = Integer(gets.chomp)
      end
    rescue
      puts "Invalid command"
      retry
    end
    command
  end

  def execute_command(pos, command)
    if command == 1
      reveal(pos)
    else
      flag(pos)
    end
  end

  def get_pos
    begin
      puts "Please enter a position (e.g. \"3, 4\")"
      parse_pos(gets.chomp)
    rescue
      puts "Invalid position"
      retry
    end
  end

  def parse_pos(pos)
    pos.split(",").map { |num| num.to_i }
  end

  def reveal(pos)
    @board.reveal(pos)
  end

  def flag(pos)
    @board[pos].set_flag
  end


  def game_over?
    @board.lose? || @board.won?
  end
end

def get_difficulty
  begin
    puts "Choose your difficulty:"
    puts "1: Easy"
    puts "2; Medium"
    puts "3: Hard"
    puts "4: Hardcore"

    gets.chomp.to_i
  rescue
    puts "Invalid difficulty"
    retry
  end
end

if __FILE__ == $PROGRAM_NAME

  game = Minesweeper.new(get_difficulty)
  game.run
end
