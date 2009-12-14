#!/usr/bin/ruby
# TeXrb generator
# Copyright (C) 2009 Alexander Potashev

require 'erb'


raise "Expected exactly one command-line argument" if not ARGV.size == 1
input_filename = ARGV[0]
output_filename = (input_filename =~ /^((.+)\.tex)rb$/ and $1)

raise "The command-line argument must be " +
	"a filename ending with .texrb" if output_filename.nil?

begin
	File.open(input_filename, 'r') do |f|
		@input_text_lines = f.readlines
	end
rescue Errno::ENOENT => e
	puts e.message
	exit
end

@input_text_lines.each_with_index do |ln,i|
	if ln.rstrip =~ /^\\input\{(.+)\}$/
		sub_fn = $1 + '.texrb'
		raise "File specified in \\input{...} doesn't exist " +
			"(#{sub_fn})" if not File.exist?(sub_fn)

		@input_text_lines[i] = File.open(sub_fn, 'r').readlines
	end
end

@input_text = @input_text_lines.flatten.join

erb = ERB.new(@input_text, 0, '')

if File.exist?(output_filename)
	raise "Output file already exists: #{output_filename}"
end

File.open(output_filename, 'w') do |f|
	f.puts(erb.result)
end
