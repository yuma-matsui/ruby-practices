# frozen_string_literal: true

require_relative 'display'
require_relative 'modules/ls'

class LS::DisplayWithL < LS::Display
  def print
    # 指定されたpathがファイルの場合表示しない
    puts "total #{total_size}" unless @files.size == 1
    @files.each do |file|
      info = file.info
      puts file_info(info)
    end
  end

  private

  def total_size
    @files.map { |file| file.info[:blocks] }.sum
  end

  def file_info(info)
    str = "#{info[:ftype]}#{info[:permission]}#{info[:nlink]} #{info[:owner_name]} #{info[:group_name]} #{info[:size]} #{info[:time_stamp]} #{info[:file_name]}"
    str += " -> #{info[:symlink]}" unless info[:symlink].nil?
    str
  end
end
