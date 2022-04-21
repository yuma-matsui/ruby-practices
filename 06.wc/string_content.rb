# frozen_string_literal: true

class StringContent
  def initialize(sentence)
    @sentence = sentence
  end

  def words
    @sentence.split(' ').size
  end

  def lines
    @sentence.split("\n").size
  end

  def bytesize
    @sentence.bytesize
  end
end
