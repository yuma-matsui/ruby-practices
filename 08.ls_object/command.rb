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
    @display = display_or_detailed_display
    inspect_path unless @path == './'
    @files = Dir.entries(@path).sort
    apply_effects!
  end

  def display
    @display.print(@files)
  end

  private

  def display_or_detailed_display
    @options[:l] ? LS::DetailedDisplay : LS::Display
  end

  # コマンドライン引数のチェック
  def inspect_path
    return if File.directory?(@path)

    if !File.exist?(@path)
      puts "ls: #{@path}: No such file or directory"
    elsif @options[:l]
      file = FileInfo.new(@path)
      # Dislayクラスの初期化には配列を渡す必要がある
      @display.print([file])
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
