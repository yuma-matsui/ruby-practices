# frozen_string_literal: true

require_relative 'string_content'

class WC
  # 出力整形時(rjust)に渡す引数
  ADJUST_NUMBER = 8

  def initialize(options, files)
    @options = options
    @files = files
  end

  def print_info
    accept_input if @files.empty?
    @files.each do |file|
      inspect(file)
      next unless File.file?(file)

      paragraph = extract_paragraph_from(file)
      puts "#{gen_all_info_array_from(paragraph).join} #{file}"
    end
    puts total_info if @files.size > 1
  end

  private

  def accept_input
    paragraph = StringContent.new(gets(nil))
    puts gen_all_info_array_from(paragraph).join
    exit
  end

  def inspect(file)
    if !File.exist?(file)
      puts "wc: #{file}: open: No such file or directory"
    elsif File.directory?(file)
      puts "wc: #{file}: read: Is a directory"
    end
  end

  def extract_paragraph_from(path)
    StringContent.new(File.new(path).read)
  end

  def gen_all_info_array_from(paragraph)
    lines = paragraph.lines.to_s.rjust(ADJUST_NUMBER)
    words = paragraph.words.to_s.rjust(ADJUST_NUMBER)
    bytesize = paragraph.bytesize.to_s.rjust(ADJUST_NUMBER)
    @options[:l] ? [lines] : [lines, words, bytesize]
  end

  def total_info
    paragraphs =
      @files
      .select { |path| File.file?(path) }
      .map { |path| extract_paragraph_from(path) }
    "#{gen_total_info_array_from(paragraphs).join} total"
  end

  def gen_total_info_array_from(paragraphs)
    lines = paragraphs.map(&:lines).sum.to_s.rjust(ADJUST_NUMBER)
    words = paragraphs.map(&:words).sum.to_s.rjust(ADJUST_NUMBER)
    bytesize = paragraphs.map(&:bytesize).sum.to_s.rjust(ADJUST_NUMBER)
    @options[:l] ? [lines] : [lines, words, bytesize]
  end
end
