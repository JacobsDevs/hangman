require_relative 'text'

class DisplayGame
  include HelpText
  attr_accessor :mistake_counter, :winner

  def initialize
    @mistakes = ['|', 'O', '/', '|', '\\', '/', '\\']
    @board_positions = [' ', ' ', ' ', ' ', ' ', ' ', ' ']
    @reveal_word = []
    @buffer = ""
    @guesses = '|                         '
    self.winner = false
		self.mistake_counter = 0
    puts introduction
  end

  def screen
    <<~HEREDOC
                +============================+
		|          HANGMAN           |
		| |-----#{@board_positions[0]}                    |
		| |     #{@board_positions[1]}                    |
		| |    #{@board_positions[2]}#{@board_positions[3]}#{@board_positions[4]}                   |
		| |    #{@board_positions[5]} #{@board_positions[6]}                   |
		| |___________               |
		|                            |
		|  #{display_word}#{@buffer}|
		|                            |
		|       Prior Guesses        |
		#{@guesses}   |
		+============================+
    HEREDOC
  end

  def setup_reveal_word(word)
    word.length.times {@reveal_word.push(' _')}
		(28 - (2 * word.length + 2)).times {@buffer += " "}
  end

  def display_word
    a = ""
    @reveal_word.each {|space| a += space.to_s}
    return a
  end
	
  def error_step(letter)
		if @guesses.include?(letter)
			puts "You already guessed #{letter}"
			puts 'Pick a letter that\'s not in your Prior Guesses'
			return
		end
    @board_positions[self.mistake_counter] = @mistakes[self.mistake_counter]
		prior_guesses(letter)
    self.mistake_counter += 1
  end
	
	def correct(letter, word)
    word.each_char.with_index do |word_letter, index|
			@reveal_word[index] = " #{letter}" if word_letter == letter
		end
		self.winner = true if (@reveal_word.include?(' _') == false)
	end
	
	def prior_guesses(letter)
		@guesses = @guesses.strip
		@guesses += " #{letter}"
		@guesses += " " until @guesses.length == 26
	end
end
