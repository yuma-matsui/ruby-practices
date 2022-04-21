# frozen_string_literal: true

require_relative 'option'
require_relative 'wc'

opt = Option.new
WC.new(opt.options, ARGV).print_info
