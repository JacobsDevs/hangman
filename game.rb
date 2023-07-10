=begin
Game Class will handle the game functions.

We can start new games or load existing ones
=end
require_relative 'brain'
require_relative 'display'

class Game
attr_accessor :game_end

  def initialize
    @display = DisplayGame.new
    @brain = Brain.new
    @difficulties = ['easy', 'normal', 'hard']
    @difficulty = ""
		@valid_guesses = /[A-z]/
    new_game if @brain.start_state.to_s.downcase == 'new game'
    load_game if @brain.start_state.downcase == 'load'
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

  def load_game
    puts 'chyeah'
  end

	def turn
		puts @display.screen
		puts "What letter do you guess?"
		letter = gets.chomp.upcase until @valid_guesses.match?(letter)
		system 'clear'
		@brain.check_guess(letter)? @display.correct(letter, @brain.word) : @display.error_step(letter)
	end

  def pick_difficulty
		#system 'clear'
    puts 'Choose your difficulty'
    puts 'EASY (5 - 6 Characters) NORMAL (7 - 9 Characters) or HARD (10 - 12 Characters)'
    @difficulty = gets.chomp.downcase until @difficulties.include?(@difficulty)
    puts "Great, lets play a #{@difficulty} game of hangman"
  end
end
