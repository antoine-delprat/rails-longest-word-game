class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @letters
  end

  def score
    @guess = params[:guess]
    @letters = params[:letters]

    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    results_api = URI.open(url).read
    results = JSON.parse(results_api)

    guess_array = @guess.chars
    guess_upcase = guess_array.map { |x| x.upcase }
    guess_upcase.sort!
    # length = guess_upcase.length

    letters = @letters.split.sort
    # letters_verif = letters[0..length - 1]

    if results['found'] == true && results['length'] <= letters.length && guess_upcase.to_set.subset?(letters.to_set)
      @score = results['length'] * results['length']
      session[:score] = @score if session[:score].nil?
      session[:score] += @score if session[:score] >= 0
      @message = "Well done! You found : #{@guess} from #{@letters} - Your score is: #{@score}"
    elsif results['found'] == true
      @message = "Sorry but #{@guess} can't be built out of #{@letters}"
      @score = 0
    else
      @message = "Sorry but #{@guess} does not seem to be an english word..."
      @score = 0
    end
  end
end
