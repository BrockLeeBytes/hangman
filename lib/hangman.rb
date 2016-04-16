class Word

  attr_accessor :answer

  def create_answer
  	open_word_list
  	reduce_word_list(@word_list, 5, 12)
  	@answer = random_word(@word_list)
  end

  def open_word_list
    @word_list = File.open("5desk.txt")
    @word_list = @word_list.collect {|word| word.chomp}
  end 

  def reduce_word_list(word_list, lower_limit, upper_limit)
    word_list.keep_if {|word| word.length > lower_limit && word.length < upper_limit}
  end

  def random_word(word_list)
    word_list[rand(word_list.length)]
  end

end

class Game

  attr_reader :guess, :hidden_word, :incorrect_guesses

  def initialize
  	@incorrect_guesses = []
  	@guess = " "
  end

  def player_guess
  	puts "What is your guess?"
  	puts "\n"
  	@guess = gets.chomp.downcase
  end

  def create_hidden_word(answer)
    @hidden_word = Array.new(answer.length, "*")
  end

  def update_hidden_word(answer, guess)
  	answer.split("").each_with_index do |letter, index|
  	  if letter.downcase == guess
  		@hidden_word[index] = answer[index]
  	  end
  	end
  end

  def add_incorrect_guess(guess)
  	incorrect_guesses.push(guess)
  end

  def check_guess(answer, guess)
  	if answer.downcase.include? guess
  		update_hidden_word(answer, guess)
  	else
  		add_incorrect_guess(guess)
  	end
  end

  def win_message
  	puts "You guessed the word!"
  end

  def win?(answer, hidden_word)
  	if answer == hidden_word.join("")
  		return true
  	end
  end

  def lose_message
  	puts "Sorry, this guy's dead!"
  end

end

class Screen

  def initialize
  	@pics = [
      "       |  +===+     |
       |  |   |	    |
       |      |     |
       |      |     |
       |      |     |
       |      |     |
       |=======     |",

      "       |  +===+     |
       |  |   |	    |
       |  O   |     |
       |      |     |
       |      |     |
       |      |     |
       |=======     |",

     "       |  +===+     |
       |  |   |	    |
       |  O   |     |
       |  |   |     |
       |      |     |
       |      |     |
       |=======     |",

      "       |  +===+     |
       |  |   |	    |
       |  O   |     |
       | /|   |     |
       |      |     |
       |      |     |
       |=======     |",

      "       |  +===+     |
       |  |   |	    |
       |  O   |     |
       | /|\\  |     |
       |      |     |
       |      |     |
       |=======     |",

       "       |  +===+     |
       |  |   |	    |
       |  O   |     |
       | /|\\  |     |
       | /    |     |
       |      |     |
       |=======     |",

       "       |  +===+     |
       |  |   |	    |
       |  O   |     |
       | /|\\  |     |
       | / \\  |     |
       |      |     |
       |=======     |"
    ]
  end


  def display(hidden_word, guess, incorrect_guesses)
    header
    word_display(hidden_word)
    guess_display(guess)
    misses_display(incorrect_guesses)
    header
    pic_display(incorrect_guesses)
    header
  end

  def word_display(hidden_word)
  	puts "Word: #{hidden_word.join(" ")}"
  end

  def guess_display(guess)
  	puts "Guess: #{guess}"
  end

  def misses_display(incorrect_guesses)
  	puts "Misses: #{incorrect_guesses.join(",")}"
  end
  
  def header
  	puts "+" + ("=" * 30) + "+"
  end

  def pic_display(incorrect_guesses)
  	puts @pics[incorrect_guesses.length]
  end

end

def game_script
  word = Word.new
  game = Game.new
  screen = Screen.new

  word.create_answer
  game.create_hidden_word(word.answer)

  until game.incorrect_guesses.length == 6
  	screen.display(game.hidden_word, game.guess, game.incorrect_guesses)
  	game.player_guess
  	game.check_guess(word.answer, game.guess)
  	if game.win?(word.answer, game.hidden_word)
  		screen.display(game.hidden_word, game.guess, game.incorrect_guesses)
  		game.win_message
  		break
  	end
  end
  if game.incorrect_guesses.length == 6
  	screen.display(game.hidden_word, game.guess, game.incorrect_guesses)
  	game.lose_message
  	puts "The answer was #{word.answer}"
  end
end

game_script