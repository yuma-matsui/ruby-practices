#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'command'
require_relative 'option'

LS::Command.display(Option.new.options, ARGV[0])
