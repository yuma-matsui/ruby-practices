# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :frame

  def initialize(first_shot, second_shot, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot)
    @third_shot = Shot.new(third_shot)
    @frame = init_frame
  end

  def score
    frame.map(&:score).sum
  end

  private

  def init_frame
    return [first_shot, second_shot, third_shot] unless third_shot.mark.nil?

    if first_shot.mark == 'X'
      [first_shot]
    else
      [first_shot, second_shot]
    end
  end
end
