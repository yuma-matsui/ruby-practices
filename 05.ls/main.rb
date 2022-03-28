#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'ls'
require_relative 'option'

opt = Option.new
ls = LS.new(ARGV[0], opt.options)
ls.print_files
