# frozen_string_literal: true

class StringContent
  def initialize(text)
    @text = text
  end

  def word_count
    @text.split(' ').size
  end

  def line_count
    @text.split("\n").size
  end

  def byte_count
    @text.bytesize
  end
end
