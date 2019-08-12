require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    player_word = params[:word]
    in_grid = player_word.chars.all? do |char|
      player_word.count(char) <= params[:letters].downcase.count(char)
    end
    unless in_grid
      return @message = 'Sorry but #{player_word} can\'t be built o'\
      "ut of #{params[:letters]}"
    end

    response = open("https://wagon-dictionary.herokuapp.com/#{player_word}")
    json = JSON.parse(response.read)
    in_api = json['found']

    unless in_api
      return @message = "Sorry but #{player_word} does not seem to be a v"\
      'alid English word'
    end

    @message = "Congraltulations! #{player_word} is a valid English word!"
  end
end
