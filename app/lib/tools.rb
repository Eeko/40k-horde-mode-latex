# tools.rb
# tools utilized by the various scripts in /bin folder

require 'yaml'
require 'kramdown'
require 'erb'
require 'pry'

class String
  # method to remove the yaml frontmatter from jekyll-styled .md files and return the contents of it as a ruby Hash
  def extract_yaml_frontmatter!
    fm_regex = /^---\s*\n(.*)---\s*$/m
    fm_matches = fm_regex.match(self)
    self.replace(self.gsub(fm_matches[0], ""))  # this method removes the frontmatter from the string it's being used on
    return YAML.load(fm_matches[0]) # return a Hash of the YAML content
  end

  # helper to remove titles from the markdowns since we are setting these in the .erb templates
  def strip_title!
    title_regex = /^.*\{\#title\s?\}/
    title_matches = title_regex.match(self)
    self.replace(self.gsub(title_matches[0], "").lstrip)
    return title_matches[0]
  end

  # helper to convert the reinforcement headers to our custom elements which are defined in our TeX .cls file
  def customize_reinforcement_sections!
    section_regex = /^\\section\*\{(?<reinforcement>.*),\s*(?<price>\d+)\s*RP\}/
    self.replace(self.gsub(section_regex, '\outputReinforcementPurchaseTitle{\k<reinforcement>}{\k<price>}'))
  end

  #helper to add the two-column boilerplate used in the spawn tables
  def add_spawn_table_boilerplate!
    section_regex = /\n\\section\*?\{.*label\{roll-results\}/
    self.replace(self.gsub(section_regex, "\\outputUsingSpawnTableBoilerplate\n" + '\0' + "\n\n\\begin{multicols}{2}"))
  end

  #helper to use the right kind of itemization in spawn tables
  def fix_spawn_table_items!
    itemize_regex = /\\begin\{itemize\}/
    item_regex = /\\item\{\}/
    self.replace(self.gsub(itemize_regex, '\\begin{itemize}[leftmargin=*]'))
    self.replace(self.gsub(item_regex, '\\item[]'))
  end

  # helper to create split titles to decide whether to use one or two
  # rows in card titles
  def split_title
    if self.split.size > 1
      cardtitle = [self.split[0..-2].join(" "), self.split[-1]]
    else
      cardtitle = self
    end
    return cardtitle
  end
end

class Kramdown::Document
  # helper function to extract a section from a kramdown document 
  # that starts from a header field matching a markdown ID given in argument
  # and ends to the next header. Returns a new Kramdown::Document with the contents in it
  def extract_kramdown_section_from_md_with_header_id(header_id)
    # find the location of the header given in argument
    header_index = self.root.children.find_index {|c| c.type == :header and c.attr["id"] == header_id}
    next_header_index = self.root.children.find_index.with_index {|c,i| c.type == :header and i > header_index}
    if next_header_index == nil
      next_header_index = self.root.children.size 
    end
    subdocument = Kramdown::Document.new("")
    subdocument.root.children = self.root.children[header_index+1..next_header_index - 1]
    return subdocument
  end

  # helper function to extract a section from a kramdown document 
  # that starts from a header field matching a string given in argument
  # and ends to the next header. Returns a new Kramdown::Document with the contents in it
  def extract_kramdown_section_from_md_with_string(string)
    # find the location of the header given in argument
    header_index = self.root.children.find_index {|c| c.type == :header and c.options[:raw_text] == string}
    next_header_index = self.root.children.find_index.with_index {|c,i| c.type == :header and i > header_index}
    if next_header_index == nil
      next_header_index = self.root.children.size
    end
    subdocument = Kramdown::Document.new("")
    subdocument.root.children = self.root.children[header_index+1..next_header_index - 1]
    #binding.pry
    return subdocument
  end

  # helper function to extract the first header of a markdown
  # file which is then treated as the title of the card. returns a
  # string of the title in question
  def extract_title
    first_header = self.root.children.find {|c| c.type == :header}
    return first_header.options[:raw_text]
  end
end

#function to read the metadata from the rule file and decide which generator to use
#def markdown_to_tex(rules_md_path, template_erb_path, version)
def markdown_to_tex(options)
  markdown_content = File.read(options[:rules])
  metadata = markdown_content.extract_yaml_frontmatter! # removes the frontmatter from the core_rules object
  if metadata["type"] == "core-rules"
    output = generate_rules_tex(markdown_content, options)
  elsif metadata["type"] == "reinforcement-purchase-table"
    output = generate_reinforcement_table_tex(markdown_content, options)
  elsif metadata["type"] == "spawn-table"
    output = generate_spawn_table_tex(markdown_content, metadata.dig("faction"), options)
  elsif metadata["type"] == "secret"
    output = generate_secret_objective_card_tex(markdown_content, metadata.dig("flavor"), options)
  elsif metadata["type"] == "secondary"
    output = generate_secondary_objective_card_tex(markdown_content, metadata.dig("flavor"), options)
  elsif metadata["type"] == "misery"
    output = generate_misery_objective_card_tex(markdown_content, metadata.dig("flavor"), options)
  else
    puts metadata
    output = "No good parser found for content type #{metadata["type"]}!"
  end
  return output
end

# generator for core rule file style of content
def generate_rules_tex(core_rules, options)
  erb_template = File.read(options[:template])
  version = options[:version]
  core_rules.strip_title! # remove the title line as it's defined already in the .erb template
  kramdown_output = Kramdown::Document.new(core_rules, {
    :latex_headers => "title,section,subsection,subsubsection,paragraph,subparagraph",
    :auto_ids => false
  }).to_latex
  template = ERB.new(erb_template)
  return template.result(binding)
end

# generator for reinforcement table content
def generate_reinforcement_table_tex(reinforcement_table, options)
  erb_template = File.read(options[:template])
  version = options[:version]
  reinforcement_table.strip_title! # remove the title line as it's defined already in the .erb template
  kramdown_output = Kramdown::Document.new(reinforcement_table, {
    :latex_headers => "title,section,subsection,subsubsection,paragraph,subparagraph",
    :auto_ids => false
  }).to_latex
  kramdown_output.customize_reinforcement_sections!
  template = ERB.new(erb_template)
  return template.result(binding)
end

# generator for spawn table content
def generate_spawn_table_tex(spawn_table, faction, options)
  erb_template = File.read(options[:template])
  version = options[:version]
  spawn_table.strip_title! # remove the title line as it's defined already in the .erb template
  kramdown_output = Kramdown::Document.new(spawn_table, {
    :latex_headers => "title,section,subsection,subsubsection,paragraph,subparagraph",
    :auto_ids => false
  }).to_latex
  kramdown_output.add_spawn_table_boilerplate!
  kramdown_output.fix_spawn_table_items!
  template = ERB.new(erb_template)
  return template.result(binding)
end

#generator for a secret objective card
def generate_secret_objective_card_tex(secret_card, flavortext, options)
  erb_template = File.read(options[:template])
  version = options[:version]
  croplines = options[:croplines]
  kramdown_content = Kramdown::Document.new(secret_card, {
    :latex_headers => "title,section,subsection,subsubsection,paragraph,subparagraph",
    :auto_ids => false
  })
  cardtitle = kramdown_content.extract_title.split_title
  effect = kramdown_content.extract_kramdown_section_from_md_with_header_id("title")
  template = ERB.new(erb_template)
  return template.result(binding)
end

#generator for a secondary objective card
def generate_secondary_objective_card_tex(secondary_card, flavortext, options)
  erb_template = File.read(options[:template])
  version = options[:version]
  croplines = options[:croplines]
  kramdown_content = Kramdown::Document.new(secondary_card, {
    :latex_headers => "title,section,subsection,subsubsection,paragraph,subparagraph",
    :auto_ids => false
  })
  cardtitle = kramdown_content.extract_title.split_title
  effect = kramdown_content.extract_kramdown_section_from_md_with_header_id("title")
  success = kramdown_content.extract_kramdown_section_from_md_with_string("Success").to_latex
  failure = kramdown_content.extract_kramdown_section_from_md_with_string("Failure").to_latex
  template = ERB.new(erb_template)
  return template.result(binding)
end

#generator for a misery objective card
def generate_misery_objective_card_tex(misery_card, flavortext, options)
  erb_template = File.read(options[:template])
  version = options[:version]
  croplines = options[:croplines]
  kramdown_content = Kramdown::Document.new(misery_card, {
    :latex_headers => "title,section,subsection,subsubsection,paragraph,subparagraph",
    :auto_ids => false
  })
  cardtitle = kramdown_content.extract_title.split_title
  effect = kramdown_content.extract_kramdown_section_from_md_with_header_id("title")
  template = ERB.new(erb_template)
  return template.result(binding)
end