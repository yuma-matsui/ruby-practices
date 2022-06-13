# frozen_string_literal: true

require_relative 'display'
require_relative 'modules/ls'

class LS::DetailedDisplay < LS::Display
  def print
    # path == Fileの場合表示しない
    puts "total #{total_size}" unless @files.size == 1
    @files.each { |file| puts file_info(file.info) }
  end

  private

  def total_size
    @files.map { |file| file.info[:blocks] }.sum
  end

  def file_info(info)
    str = "#{first_half_info(info)} #{latter_half_info(info)} #{file_path_or_name(info)}"
    str += " -> #{info[:symlink]}" unless info[:symlink].nil?
    str
  end

  def first_half_info(info)
    "#{info[:ftype]}#{info[:permission]}#{info[:nlink]}"
  end

  def latter_half_info(info)
    "#{info[:owner_name]} #{info[:group_name]} #{info[:size]} #{info[:time_stamp]}"
  end

  # path == Fileの場合の分岐のため切り出し
  def file_path_or_name(info)
    @files.size == 1 ? info[:path] : info[:file_name]
  end
end
