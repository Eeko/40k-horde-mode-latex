#!/usr/bin/env ruby
#
# parse-rules.rb
# tool to generate generic rule booklet .tex files
# run ./parse-rules.rb -h for command line options
# 
# e.g. 
# $ ruby parse-rules.rb --version v0.83 --output ../../test1.tex --rule-file ../../40k-horde-mode-markdown/rules/core-rules.md --template ../templates/core-rules-book.tex.erb
# $ ruby parse-rules.rb --version v0.83 --output ../../test2.tex --rule-file ../../40k-horde-mode-markdown/rules/reinforcement-points-purchase-table.md --template ../templates/reinforcement-points-purchase-table.tex.erb
# $ ruby parse-rules.rb --version v0.83 --output ../../test3.tex --rule-file ../../40k-horde-mode-markdown/spawn-tables/space-marines.md --template ../templates/spawn-table.tex.erb
# $ ruby parse-rules.rb --version v0.83 --output ../../test4.tex --rule-file ../../40k-horde-mode-markdown/cards/secret/saboteur.md --template ../templates/secret-objective-card.tex.erb
require_relative '../lib/tools'
require 'optparse'
require 'pathname'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: parse-rules.rb [options]"

  opts.on("-v", "--version VERSION", "Set VERSION to be printed to the outputfile.") do |v|
    options[:version] = v
  end
  opts.on("-r", "--rule-file PATH", "PATH to .md file containing the game rules") do |r|
    options[:rules] = r
  end
  opts.on("-t", "--template PATH", "PATH to .erb file containing the ERB-template") do |t|
    options[:template] = t
  end
  opts.on("-o", "--output PATH", "PATH to where the output should be written to. If empty, STDOUT will be used") do |o|
    options[:output] = o
  end
  opts.on "-c", "--croplines", "render crop lines to the output." do |c|
    options[:croplines] = c
  end
end.parse!

#set defaults if empty
if not options[:version]
  options[:version] = ""
end

if not (options[:template] and options[:rules])
  abort("-t and -r switches are required. See ./parse-rules.rb -h for help.")
end

# check if rulefile is a file
if File.file?(options[:rules])
  tex_output = markdown_to_tex(options)
  if options[:output]
    File.open(options[:output], 'w') { |f| f.write(tex_output) }
  else
    puts tex_output
  end
elsif File.directory?(options[:rules]) # if the rulefile is a path
  if options[:output] == nil
    abort("The -o switch should point to a directory if -r targets a directory")
  elsif not File.directory?(options[:output]) 
    abort("The -o switch should also point to a directory if -r is a directory")
  end
  # process whole directory of .md files with one shot
  Dir.glob("#{options[:rules]}/*.md").each do |f|
    basename = File.basename(f, ".*")
    single_file_options = options.dup
    single_file_options[:rules] = f
    tex_output = markdown_to_tex(single_file_options)
    File.open("#{options[:output]}/#{basename}.tex", 'w') { |f| f.write(tex_output) }
  end
else
  abort("The path given with -r switch should point to a single file or directory. See ./parse-rules.rb -h for help.")
end



