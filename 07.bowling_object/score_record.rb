# frozen_string_literal: true

class ScoreRecord
  def self.generate(marks)
    records = []
    marks.split(',').each do |mark|
      records << mark
      records << '0' if (records.size < 18) && (mark == 'X')
    end
    records
  end
end
