class WordsController < ApplicationController
require 'open-uri'
require 'json'

attr_accessor :start_time
  def game
  charset = %w{A C D E F G H J K M N P Q R T V W X Y Z}
  @game = (0...10).map{ charset.to_a[rand(charset.size)] }.join(" ")
  @start_time = Time.now
end

  def score
  # @guess.all
  # chars.all? { |letter| @guess.count(letter) <= @game.count(letter) }
  @guess = params[:query]
  @attempt_letters = @guess.split("").to_a
  @attempt_counts = @attempt_letters.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
  @start_time = params[:start_time]
  @end_time = Time.now
  @time_elapsed = @end_time.to_f - @start_time.to_f
  @time_elapsed_second = ((@time_elapsed % 3600) % 60).to_i
  url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
  word_serialized = open(url).read
  word = JSON.parse(word_serialized)
  if word['found'] == true
    @score = @guess.size - (1 - 1/@time_elapsed_second)
  else
    @score = "Incorrect"
  end

end
end
