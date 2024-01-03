#!/usr/bin/env ruby
#
# parse-rules.rb
# tool to generate generic rule booklet .tex files
# run ./parse-rules.rb -h for command line options
# 
# e.g. 
# $ ruby parse-rules.rb --version v0.83 --output ../../test1.tex --rule-file ../../40k-horde-mode-markdown/rules/core-rules.md --template ../templates/core-rules-book.tex.erb
# $ ruby parse-rules.rb --version v0.83 --output ../../test2.tex --rule-file ../../40k-horde-mode-markdown/rules/reinforcement-points-purchase-table.md --template ../templates/reinforcement-points-purchase-table.tex.erb
require_relative '../lib/tools'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: parse-rules.rb [options]"

  opts.on("-v", "--version VERSION", "Set VERSION to be printed to the outputfile.") do |v|
    options[:version] = v
  end
  opts.on("-r", "--rule-file PATH", "PATH to .md file containing the core rules") do |r|
    options[:rules] = r
  end
  opts.on("-t", "--template PATH", "PATH to .erb file containing the ERB-template") do |t|
    options[:template] = t
  end
  opts.on("-o", "--output PATH", "PATH to where the output should be written to. If empty, STDOUT will be ued") do |o|
    options[:output] = o
  end
end.parse!

#set defaults if empty
if not options[:version]
  options[:version] = ""
end

tex_output = markdown_to_tex(options[:rules], options[:template], options[:version])

if options[:output]
  File.open(options[:output], 'w') { |f| f.write(tex_output) }
else
  puts tex_output
end