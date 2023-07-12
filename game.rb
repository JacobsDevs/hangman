=begin
Game Class will handle the game functions.

We can start new games or load existing ones
=end
require_relative 'brain'
require_relative 'display'

require 'yaml'

class Game
  def initialize(display=DisplayGame.new, brain=Brain.new, difficulties=['easy', 'normal', 'hard'], difficulty="", valid_guesses=/[A-z]/, load=false)
		@load = load
		@display = display
		@brain = brain
		@difficulties = difficulties
		@difficulty = difficulty
		@valid_guesses = valid_guesses
    if @load == false
			new_game if @brain.start_state.to_s.downcase == 'new game' || @brain.start_state.to_s.downcase == 'new'
    	load_game("save.yaml") if @brain.start_state.to_s.downcase == 'load'
		elsif @load == true
			continue_game
		end
	end

  def new_game
    pick_difficulty
    @brain.get_secret_word(@difficulty)
    @display.setup_reveal_word(@brain.word)
    turn until @display.winner == true || @display.mistake_counter == 7
    system 'clear'
    puts @display.screen
    @brain.resolve(@display.winner)
  end

  def load_game(string)
		data = YAML.load(File.read(string), permitted_classes: [DisplayGame, Symbol, Brain, Regexp])
		p data
		self.initialize(data[:display], data[:brain], data[:difficulties], data[:difficulty], data[:valid_guesses], true)
	end

	def continue_game
		turn until @display.winner == true || @display.mistake_counter == 7
    system 'clear'
    puts @display.screen
    @brain.resolve(@display.winner)
	end

  def save_game
		@brain.start_state = 'load'
		@brain.load = false
		save_object = YAML.dump ({
			:display => @display,
			:brain => @brain,
      :difficulties => @difficulties,
      :difficulty => @difficulty,
      :valid_guesses => @valid_guesses
		})
		File.open("save.yaml", "w") { |file| file.write(save_object)}

	end

  def turn
    puts @display.screen
    puts "What letter do you guess? Additionally, type \'save\' to save."
    letter = gets.chomp.upcase until @valid_guesses.match?(letter)
		if letter == 'SAVE' 
			save_game
	  else
      system 'clear'
      @brain.check_guess(letter)? @display.correct(letter, @brain.word) : @display.error_step(letter)
		end
  end

  def pick_difficulty
    #system 'clear'
    puts 'Choose your difficulty'
    puts 'EASY (5 - 6 Characters) NORMAL (7 - 9 Characters) or HARD (10 - 12 Characters)'
    @difficulty = gets.chomp.downcase until @difficulties.include?(@difficulty)
    puts "Great, lets play a #{@difficulty} game of hangman"
  end
end
