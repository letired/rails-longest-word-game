class PagesController < ApplicationController
  SCRABBLE_SCORES = {
    "A" => 1, "B" => 3, "C" => 3, "D" => 2,
    "E" => 1, "F" => 4, "G" => 2, "H" => 4,
    "I" => 1, "J" => 8, "K" => 5, "L" => 1,
    "M" => 3, "N" => 1, "O" => 1, "P" => 3,
    "Q" => 10, "R" => 1, "S" => 1, "T" => 1,
    "U" => 1, "V" => 4, "W" => 4, "X" => 8,
    "Y" => 4, "Z" => 10
  }

  ENGLISH_WORDS_URL = "https://raw.githubusercontent.com/dwyl/english-words/master/words.txt"
  ENGLISH_WORDS = open(ENGLISH_WORDS_URL).read.tr("\n", " ").split(" ").drop(52)

  def game
    @grid = generate_grid(params[:grid_size].to_i)
    @time = Time.now.to_i
  end

  def grid
  end

  def score
    time = Time.now - Time.at(params[:time].to_i)
    grid = params[:grid].chars
    attempt = params[:attempt].upcase
    @result = run_game(attempt, grid, time)
  end

  private

  def generate_grid(grid_size)
   letters = []
   SCRABBLE_SCORES.each do |l, x|
     1.upto(120 / x) do
       letters << l
     end
   end
   grid = []
   1.upto(grid_size) { grid << letters.sample }

   return grid
  end

  def run_game(attempt, grid, time)
    # TODO: runs the game and return detailed hash of result
    # check if attempt is a valid word
    result = Hash.new
    if check_attempt_in_grid(attempt, grid) && check_if_word(attempt)
      result[:score] = compute_score(attempt, time)
      result[:grid] = grid
      result[:attempt] = attempt
      result[:message] = "Great work!"
    elsif !check_attempt_in_grid(attempt, grid) && !check_if_word(attempt)
      result[:message] = "Both not a word and not in the grid"
      result[:attempt] = attempt
      result[:grid] = grid
      result[:score] = 0
    elsif !check_attempt_in_grid(attempt, grid)
      result[:message] = "Not in the grid"
      result[:attempt] = attempt
      result[:grid] = grid
      result[:score] = 0
    elsif !check_if_word(attempt)
      result[:message] = "Not an english word"
      result[:attempt] = attempt
      result[:grid] = grid
      result[:score] = 0
    end
    result
  end


  def check_attempt_in_grid(attempt, grid)
    attempt.chars.all? { |char| grid.count(char) >= attempt.count(char) }
  end

  def check_if_word(attempt)
    ENGLISH_WORDS.include?(attempt.downcase)
  end

  def compute_score(attempt, time)
    attempt.length* (30 - time.round)
  end

end
