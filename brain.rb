class Brain
  attr_accessor :start_state, :word, :load
  def initialize(load=false)
		self.load = load
		if self.load == false	
		  @start_states = ['new game', 'new', 'load']
    	self.start_state = gets.chomp until @start_states.include?(self.start_state)
    	word_list = File.open("word_list.txt")
    	@easy_list = []
    	@normal_list = []
    	@hard_list = []
    	self.word = ''
    	load_dictionary(word_list)
		end
  end

  def load_dictionary(word_list)
    word_list.readlines.each do |line|
      line.chomp!
      @easy_list.push(line) if line.length > 4 && line.length < 7
      @normal_list.push(line) if line.length >= 7 && line.length <= 9
      @hard_list.push(line) if line.length >= 10
    end

    puts "#{@easy_list.length} Words loaded into the easy dictionary"
    puts "#{@normal_list.length} Words loaded into the normal dictionary"
    puts "#{@hard_list.length} Words loaded into the hard dictionary"
  end

  def get_secret_word(difficulty)
    self.word = @easy_list.sample.upcase if difficulty == 'easy'
    self.word = @normal_list.sample.upcase if difficulty == 'normal'
    self.word = @hard_list.sample.upcase if difficulty == 'hard'
		#close dictionaries for faster saving
		@easy_list = []
		@normal_list = []
		@hard_list = []
  end

  def check_guess(guess)
    if self.word.include?(guess)
      true
    else
      false
    end
  end

	def resolve(game_end)
    puts "Sorry, That's too bad, the word was #{self.word}!" if game_end == false
		puts "CONGRATULATIONS, YOU WIN" if game_end == true
	end
end
