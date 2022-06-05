# frozen_string_literal: true

require_relative 'frame'

class Game
  MAX_SHOTS_NUMBER = 21

  def self.print_score(marks)
    new(marks).score
  end

  def initialize(marks)
    @frames = generate_frames(marks)
  end

  def score
    score = @frames.map(&:score).sum
    @frames.each do |frame|
      score += add_extra_score(frame) if frame.strike? || frame.spare?
    end
    score
  end

  private

  def generate_frames(marks)
    score_record = init_record(marks)
    frames = init_frames(score_record)
    frames.map.with_index { |frame, index| Frame.new(index, *frame) }
  end

  def init_record(marks)
    marks.split(',').each_with_object([]) do |mark, records|
      records << mark
      records << '0' if (records.size < 18) && (mark == 'X')
    end
  end

  def init_frames(score_record)
    frames = []
    last_frame_extra_shot = score_record.pop if extra_shot?(score_record)

    score_record.each_slice(2) { |frame| frames << frame }
    frames.last.push(last_frame_extra_shot) unless last_frame_extra_shot.nil?
    frames
  end

  def extra_shot?(score_record)
    score_record.size == MAX_SHOTS_NUMBER
  end

  def add_extra_score(frame)
    next_frame = @frames[frame.order + 1]
    after_next_frame = @frames[frame.order + 2]
    calc_extra_score(frame, next_frame, after_next_frame)
  end

  def calc_extra_score(frame, next_frame, after_next_frame)
    if frame.strike? && next_frame.strike?
      next_frame.score + after_next_frame.first_shot.score
    elsif frame.strike?
      next_frame.first_shot.score + next_frame.second_shot.score
    else
      next_frame.first_shot.score
    end
  end
end
