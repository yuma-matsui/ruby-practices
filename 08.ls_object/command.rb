# frozen_string_literal: true

require_relative 'modules/ls'
require_relative 'file_info'
require_relative 'display'
require_relative 'detailed_display'

class LS::Command
  def self.display(options, path)
    new(options, path).display
  end

  def initialize(options, path)
    @path = path || './'
    @options = options
    inspect_path unless @path == './'
    files = init_files
    @display = display_or_detailed_display(files)
  end

  def display
    @display.print
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
      LS::DetailedDisplay.new([file]).print
    else
      puts File.basename(@path)
    end
    exit
  end

  def init_files
    files = Dir.entries(@path).sort
    apply_effects(files)
  end

  # 各オプションに対応した配列操作
  def apply_effects(files)
    files = files.reject { |f| f.start_with?('.') } unless @options[:a]
    files = files.reverse if @options[:r]
    files = files.map { |file| FileInfo.new("#{@path}/#{file}") } if @options[:l]
    files
  end

  def display_or_detailed_display(files)
    @options[:l] ? LS::DetailedDisplay.new(files) : LS::Display.new(files)
  end
end
