# frozen_string_literal: true

require 'optparse'

class Option
  OPTIONS = %w[a r].freeze

  attr_reader :options

  def initialize
    @opt = OptionParser.new
    @options = {}
    init_options
    @opt.parse!(ARGV, into: @options)
  end

  private

  def init_options
    OPTIONS.each { |opt| @opt.on("-#{opt}") }
  end
end
