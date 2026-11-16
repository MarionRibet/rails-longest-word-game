require "net/http"
require "json"

class GamesController < ApplicationController
  def new
    range = ('A'..'Z').to_a
    @letters = 10.times.map { range.sample }
  end

  def score
    @word = params[:word].downcase
    @letters = params[:letters].split
    if word_possible?(@letters, @word) == false
      @message = "Sorry but #{params[:word].upcase} can't be built out of #{@letters.join(" ")}"
    else
      api_call(@word)
    end
  end
end

private
  def word_possible?(letters, word)
    word.chars.all? do |letter|
      letters.include?(letter)
    end
  end

  def api_call(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = Net::HTTP.get_response(URI(url))
    data = JSON.parse(response.body)
    if data[:found] == false
      @message = "Sorry but #{word.upcase} does not seem to be a valid English word..."
    else
      @message = "Congratulations! #{word.upcase} is a valid English word!"
    end
  end
