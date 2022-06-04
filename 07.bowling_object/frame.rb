# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :order, :shots

  def initialize(index, first_shot, second_shot, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot)
    @third_shot = Shot.new(third_shot)
    @order = index
    @shots = init_frame
  end

  def score
    @shots.map(&:score).sum
  end

  def last?
    (@shots.size == 3) || (@order == 9)
  end

  def strike?
    @shots.size == 1
  end

  def spare?
    (@shots.size == 2) && (score == 10)
  end

  private

  def init_frame
    return [@first_shot, @second_shot, @third_shot] unless @third_shot.mark.nil?

    if @first_shot.mark == 'X'
      [@first_shot]
    else
      [@first_shot, @second_shot]
    end
  end
end
