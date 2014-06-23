class Hangman	

	def initialize
		@end_of_game = false
		@guesses = 6
		@missed_guesses = []
		puts "\n\nWelcome to the greatest hangman game ever conceived"
		print "\nWould you like to load a previous game (y/n)?  "
		response = gets.chomp
		response.downcase == 'y' ? load_game : begin_game
	end

	def begin_game
		puts "\nYou can save your game at sny time by typing 'save'.\n"
		puts "LET US BEGIN"
		@secret_word = get_word
		game_loop
	end

	def load_game

	end

	def get_word
		contents = File.readlines '5desk.txt'
		contents.select! {|word| word.chomp.length.between?(5,12) }
		contents.sample.chomp.upcase
	end

	def game_loop
		while true
			check_game
			break if @end_of_game
			each_turn
		end
		play_again
	end

	def check_game 
		ran_out_guesses if @guesses <= 0
		won_game if @secret_word == @secret_word.downcase
	end

	def play_again
		print "\nWould you like to play again (y/n)?  "
		u_input = gets.chomp
		new_g=Hangman.new if u_input == 'y'
	end


	def ran_out_guesses
		puts "\nSorry, you ran out of guesses"
		puts "\nThe word was #{@secret_word.upcase}\n"
		@end_of_game = true
	end


	def won_game
		puts "\nCongrats! You got it!"
		print "Would you like to play again (y/n)?  "
		u_input = gets.chomp
		@end_of_game = true
		u_input.downcase == 'y' ? game=Hangman.new : end_game
	end

	def each_turn
		puts "\nGuesses left: #{@guesses}"
		puts "Failed guesses: #{@missed_guesses.join(', ')}\n\n\n"
		draw
		guess 
	end

	def draw
		@secret_word.split('').each do |letter|
			print letter==letter.downcase ? "#{letter} " : "_ "
		end
		puts "\n\n"
	end

	def guess
		print "\nYour guess?  "
		@guess = gets.chomp.downcase
		@guess.length > 1 ? several_letters : one_letter
	end

	def several_letters
		if @guess == 'save'
			save_game
		else
			puts "\nYou can only guess one letter at a time"
			each_turn
		end
	end

	def one_letter 
		if @secret_word.include?(@guess) || @missed_guesses.include?(@guess)
			puts "\n\nYou already guessed that"
			each_turn
		else
			@secret_word.include?(@guess.upcase) ? right_guess : wrong_guess
		end
	end


	def save_game
		#yaml
	end

	def wrong_guess
		puts "\n\nSorry guy. '#{@guess}' is not in the word"
		@guesses -= 1
		@missed_guesses << @guess 
	end

	def right_guess
		@secret_word.gsub!("#{@guess.upcase}", "#{@guess}")
	end

end

game = Hangman.new