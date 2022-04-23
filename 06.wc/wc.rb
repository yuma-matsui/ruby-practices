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

      text = extract_text(file)
      puts formated_items(text_items(text: text, file_name: File.basename(file)), @options[:l])
    end
    puts formated_items(multiple_texts_items, @options[:l]) if @files.size > 1
  end

  private

  def accept_input
    text = StringContent.new(gets(nil))
    puts formated_items(text_items(text: text), @options[:l])
    exit
  end

  def formated_items(text_items, option)
    if option
      "#{format_count(text_items[:line_count])} #{text_items[:file_name]}"
    else
      "#{format_count(text_items[:line_count])}#{format_count(text_items[:word_count])}#{format_count(text_items[:byte_count])} #{text_items[:file_name]}"
    end
  end

  def text_items(text:, file_name: nil)
    {
      file_name: file_name,
      line_count: text.line_count,
      word_count: text.word_count,
      byte_count: text.byte_count
    }
  end

  def inspect(file)
    if !File.exist?(file)
      puts "wc: #{file}: open: No such file or directory"
    elsif File.directory?(file)
      puts "wc: #{file}: read: Is a directory"
    end
  end

  def extract_text(file)
    StringContent.new(File.new(file).read)
  end

  def format_count(count)
    count.to_s.rjust(ADJUST_NUMBER)
  end

  def multiple_texts_items
    texts =
      @files
      .select { |file| File.file?(file) }
      .map { |file| extract_text(file) }
    calc_multiple_texts_items(texts)
  end

  def calc_multiple_texts_items(texts)
    {
      file_name: 'total',
      line_count: texts.map(&:line_count).sum,
      word_count: texts.map(&:word_count).sum,
      byte_count: texts.map(&:byte_count).sum
    }
  end
end
