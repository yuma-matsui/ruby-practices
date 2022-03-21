# frozen_string_literal: true

require_relative 'array_effects'

class LS
  # 出力時の最大横列数
  MAX_WIDTH = 3

  include ArrayEffects

  def initialize(path)
    path ||= './'
    inspect_path(path) unless path == './'
    @files = Dir.children(path)
    execute_file_effector
    print_files
  end

  private

  # コマンドライン引数のチェック
  def inspect_path(path)
    return if File.directory?(path)

    if !File.exist?(path)
      puts "ls: #{path}: No such file or directory"
    elsif File.file?(path)
      puts File.basename(path)
    end
    exit
  end

  # 取得した配列の操作
  def execute_file_effector
    insert_space_into_file_name
    excludes_secret
    sorts
  end

  # ファイル表示の際の横列数
  def column_num
    (@files.size.to_f / MAX_WIDTH).ceil
  end

  # 横1列に表示されるファイルを格納した配列を要素に持つ配列
  def init_records
    records = []
    column_num.times do |i|
      records <<
        @files
        .each_slice(column_num)
        .map { |column| column[i] }
    end
    records
  end

  def print_files
    records = init_records
    records.each { |record| puts record.join("\t") }
  end
end
