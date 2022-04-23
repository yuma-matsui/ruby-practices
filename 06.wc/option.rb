# frozen_string_literal: true

require 'optparse'

class Option
  OPTIONS = %w[l].freeze

  attr_reader :options

  def initialize
    option = OptionParser.new
    @options = {}
    init_options(option)
    option.parse!(ARGV, into: @options)
  end

  private

  def init_options(option)
    OPTIONS.each { |opt| option.on("-#{opt}") }
  end
end
