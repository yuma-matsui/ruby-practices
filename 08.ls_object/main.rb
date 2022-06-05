#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'ls'

LS.new(ARGV[0]).print_files
