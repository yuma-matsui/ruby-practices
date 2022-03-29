# frozen_string_literal: true

require_relative 'effects'

class LS
  # 出力時の最大横列数
  MAX_WIDTH = 3
  OPTIONS = {
    a: Effects.excludes_secret!,
    r: Effects.reverse!
  }.freeze

  def initialize(path, opts)
    path ||= './'
    inspect_path(path) unless path == './'
    options = init_options(opts)
    @files = init_files(path, options)
  end

  def print_files
    insert_space_into_file_name!
    records = init_records
    records.each { |record| puts record.join("\t") }
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

  # オプションの判定
  def init_options(opts)
    options = {
      a: true,
      r: false
    }
    opts.each do |key, val|
      options[key] = !options[key] if val
    end
    options
  end

  # 表示ファイルの初期化
  def init_files(path, options)
    files = Dir.entries(path).sort
    apply_effects(files, options)
  end

  # 各オプションに対応した配列操作
  def apply_effects(files, options)
    options.each do |key, val|
      OPTIONS[key].call(files) if val
    end
    files
  end

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
