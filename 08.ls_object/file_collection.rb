# frozen_string_literal: true

require_relative 'file_info'
require_relative 'option'
require_relative 'display'
require_relative 'display_with_l'
require_relative 'modules/ls'

class LS::FileCollection
  def self.display(path)
    new(path).display
  end

  def initialize(path)
    @path = path || './'
    @options = Option.new.options
    inspect_path unless @path == './'
    @files = Dir.entries(@path).sort
    apply_effects!
  end

  def display
    @options[:l] ? LS::DisplayWithL.print(@files) : LS::Display.print(@files)
  end

  private

  # コマンドライン引数のチェック
  def inspect_path
    return if File.directory?(@path)

    if !File.exist?(@path)
      puts "ls: #{@path}: No such file or directory"
    elsif @options[:l]
      file = FileInfo.new(@path)
      # Dislayクラスの初期化には配列を渡す必要がある
      LS::DisplayWithL.print([file])
    else
      puts File.basename(@path)
    end
    exit
  end

  # 各オプションに対応した配列操作
  def apply_effects!
    @files.reject! { |f| f.start_with?('.') } unless @options[:a]
    @files.reverse! if @options[:r]
    @files.map! { |file| FileInfo.new("#{@path}/#{file}") } if @options[:l]
  end
end
