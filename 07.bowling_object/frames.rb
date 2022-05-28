# frozen_string_literal: true

class Frames
  MAX_SHOTS_NUMBER = 21

  def self.generate(score_record)
    frames = []
    last_frame_extra_shot = score_record.pop if score_record.size == MAX_SHOTS_NUMBER

    score_record.each_slice(2) { |frame| frames << frame }
    frames.last.push(last_frame_extra_shot) unless last_frame_extra_shot.nil?
    frames
  end
end
