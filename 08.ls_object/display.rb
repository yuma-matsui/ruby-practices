# frozen_string_literal: true

require_relative 'modules/ls'

class LS::Display
  # 出力時の最大横列数
  MAX_WIDTH = 3

  def self.print(files)
    new(files).print
  end

  def initialize(files)
    @files = files
  end

  def print
    insert_space_into_file_name!
    records = init_records
    records.each { |record| puts record.join("\t") }
  end

  private

  # 空白を挿入してファイル名を20文字に統一
  def insert_space_into_file_name!
    @files.map! { |file| file.ljust(20) }
  end

  # 横1列に表示されるファイルを格納した配列を要素に持つ配列
  def init_records
    Array.new(column_num) do |i|
      @files.each_slice(column_num).map { |column| column[i] }
    end
  end

  # ファイル表示の際の横列数
  def column_num
    (@files.size.to_f / MAX_WIDTH).ceil
  end
end
