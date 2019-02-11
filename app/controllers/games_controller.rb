class GamesController < ApplicationController
  def new
    @start_time = Time.now
    @letters = []

    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    word = params[:word]
    letters = params[:letters]
    start_time = Time.parse(params[:start_time])
    end_time = Time.now
    time_taken = end_time - start_time
    @score = compute_score(word, time_taken)
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
