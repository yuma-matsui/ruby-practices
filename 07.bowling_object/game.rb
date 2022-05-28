# frozen_string_literal: true

require_relative 'score_record'
require_relative 'frames'
require_relative 'frame'

class Game
  attr_reader :game

  def initialize(marks)
    score_record = ScoreRecord.generate(marks)
    frames = Frames.generate(score_record)
    @game = generate_game(frames)
  end

  def score
    score = 0
    game.each_with_index do |frame, index|
      next_frame = game[index + 1] unless index == 9
      score += calc_score(frame, next_frame, index)
    end
    score
  end

  private

  def generate_game(frames)
    frames.map { |frame| Frame.new(*frame) }
  end

  def calc_score(frame, next_frame, index)
    if frame.frame.size == 3
      frame.score
    elsif (frame.frame.size == 1) && (next_frame.frame.size == 1)
      10 + next_frame.score + game[index + 2].first_shot.score
    elsif frame.frame.size == 1
      10 + next_frame.first_shot.score + next_frame.second_shot.score
    elsif frame.score == 10
      10 + next_frame.first_shot.score
    else
      frame.score
    end
  end
end
