#!/usr/bin/ruby
# TeXrb generator
# Copyright (C) 2009 Alexander Potashev

require 'erb'


raise "Expected exactly one command-line argument" if not ARGV.size == 1
input_filename = ARGV[0]
output_filename = (input_filename =~ /^((.+)\.tex)\.erb$/ and $1)

raise "The command-line argument must be " +
	"a filename ending with .tex.erb" if output_filename.nil?

begin
	@input_text_lines = File.open(input_filename, 'r').readlines
rescue Errno::ENOENT => e
	puts e.message
	exit
end

@input_text_lines.each_with_index do |ln,i|
	if ln.rstrip =~ /^\\input\{(.+)\}$/
		sub_fn = $1 + '.tex.erb'
		raise "File specified in \\input{...} doesn't exist " +
			"(#{sub_fn})" if not File.exist?(sub_fn)

		@input_text_lines[i] = File.open(sub_fn, 'r').readlines
	end
end

result = ERB.new(@input_text_lines.flatten.join, 0, '').result

raise "Output file already exists: " +
	"#{output_filename}" if File.exist?(output_filename)
File.open(output_filename, 'w').puts(result)

