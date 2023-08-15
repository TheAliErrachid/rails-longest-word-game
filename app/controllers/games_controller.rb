require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @word = params[:word]
    @letters = params[:letters]
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @letters.each { |letter| letter.downcase! }
  end

  def score
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    @letters = params[:letters].upcase.split(' ')

    if test_word(@word, @letters) && word['found']
      @result = "Congratulations! #{@word} is a valid English word!"
    elsif test_word(@word, @letters) == false
      @result = "Sorry but #{@word} can't be built out of #{@letters.join(', ')}"
    else
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    end
  end

  private

  def test_word(word, letters)
    word.upcase.chars.all? { |letter| word.upcase.count(letter) <= letters.count(letter) }
  end
end
