#!/usr/bin/env ruby
#
# generate-multipage-printables.rb
# tool to generate .tex files for generating easier-to-print versions of the game resources.
# generates a .tex file to the same directory where the source file(s) resides in.
# run ./generate-multipage-printables.rb -h for command line options
# 
# e.g. 

require_relative '../lib/tools'
require 'optparse'
require 'pathname'
require 'erb'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: generate-multipage-printables.rb [options]"

  opts.on("-r", "--rule-file PATH", "PATH to .pdf file(s) containing the pages to be formatted for printing") do |r|
    options[:rules] = r
  end
  opts.on("-t", "--template PATH", "PATH to .erb file containing the ERB-template we wish to use") do |t|
    options[:template] = t
  end
  #opts.on("-o", "--output PATH", "PATH to where the output should be written to. If empty, STDOUT will be used") do |o|
  #  options[:output] = o
  #end
  #opts.on "-c", "--croplines", "render crop lines to the output." do |c|
  #  options[:croplines] = c
  #end
end.parse!

if not (options[:template] and options[:rules])
  abort("-t and -r switches are required. See ./generate-multipage-printables.rb -h for help.")
end

# check if the target is a single file to be reformatted with a template
if File.file?(options[:rules])
  erb_template = File.read(options[:template])
  basename = File.basename(options[:rules], ".*")
  pathname = File.dirname(options[:rules])
  pdf_file = basename
  template = ERB.new(erb_template)
  tex_output = template.result(binding)
  File.open("#{pathname}/#{basename}-printable.tex", 'w') { |f| f.write(tex_output) }
elsif File.directory?(options[:rules]) # if the rulefile is a path
  # process whole directory of .md files with one shot
  erb_template = File.read(options[:template])
  file_list = Dir.glob("#{options[:rules]}/*.{pdf,tex}").map {|f| File.basename(f, ".*")}.join(",")
  template = ERB.new(erb_template)
  tex_output = template.result(binding)
  File.open("#{options[:rules]}/pdf-collection-printable.tex", 'w') { |f| f.write(tex_output) }
else
  abort("The path given with -r switch should point to a single file or directory. See ./parse-rules.rb -h for help.")
end



