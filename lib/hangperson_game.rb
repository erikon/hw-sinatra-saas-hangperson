class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  def initialize(word)
    @word = word.downcase
    @guesses = ""
    @wrong_guesses = ""
  end

  def guess(guess)
    if guess == nil || guess == '' || !(guess =~ /[[:alpha:]]/)
      raise ArgumentError, "Invalid guess"
    end

    guess.downcase!
    if @word.include? guess
      if !@guesses.include? guess
        @guesses << guess
      else
        return false
      end
    else
      if !@wrong_guesses.include? guess
        @wrong_guesses << guess
      else
        return false
      end
    end
    return true
  end

  def word_with_guesses
    res = "-" * @word.length
    for c in 0..(@guesses.length-1)
      for i in 0..(@word.length - 1)
        if @guesses[c] == @word[i]
          res[i] = @guesses[c]
        end
      end
    end
    return res
  end

  def check_win_or_lose
    if !self.word_with_guesses.include? "-"
      return :win
    elsif @wrong_guesses.length == 7
      return :lose
    else
      return :play
    end
  end
  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
