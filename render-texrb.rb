#!/usr/bin/ruby
# TeXrb generator
# Copyright (C) 2009 Alexander Potashev

require 'erb'


raise if not ARGV.size == 1
input_filename = ARGV[0]
output_filename = (input_filename =~ /^((.+)\.tex)rb$/ and $1)

File.open(input_filename, 'r') do |f|
	@input_text = f.readlines.join
end

erb = ERB.new(@input_text, 0, '')

if File.exist?(output_filename)
	raise "Output file already exists: #{output_filename}"
end

File.open(output_filename, 'w') do |f|
	f.puts(erb.result)
end
