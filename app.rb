require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  before do
    @game = session[:game] || HangpersonGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end

  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    if letter == nil || letter == '' || !(letter =~ /[[:alpha:]]/)
      flash[:message] = "Invalid guess."
      redirect '/show'
    end

    if @game.guesses.include? letter
      flash[:message] = "You have already used that letter."
      redirect '/show'
    end

    if @game.wrong_guesses.include? letter
      flash[:message] = "You have already used that letter."
      redirect '/show'
    end
    @game.guess(letter)
    redirect '/show'
  end

  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    if @game.word != '' && @game.word != nil
      state = @game.check_win_or_lose
      if state == :lose
        redirect '/lose'
      elsif state == :win
        redirect '/win'
      end
      erb :show
    else
      status 404
    end
  end

  get '/win' do
    if @game.word != '' && @game.word != nil && @game.check_win_or_lose == :win
      erb :win
    else
      status 404
    end
  end

  get '/lose' do
    if @game.word != '' && @game.word != nil && @game.check_win_or_lose == :lose
      erb :lose
    else
      status 404
    end
  end

end
