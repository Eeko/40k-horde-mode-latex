# tools.rb
# tools utilized by the various scripts in /bin folder

require 'yaml'
require 'kramdown'
require 'erb'


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
end

#function to read the metadata from the rule file and decide which generator to use
def markdown_to_tex(rules_md_path, template_erb_path, version)
  markdown_content = File.read(rules_md_path)
  metadata = markdown_content.extract_yaml_frontmatter! # removes the frontmatter from the core_rules object
  if metadata["type"] == "core-rules"
    output = generate_rules_tex(markdown_content, template_erb_path, version)
  elsif metadata["type"] == "reinforcement-purchase-table"
    output = generate_reinforcement_table_tex(markdown_content, template_erb_path, version)
  else
    puts metadata
    output = "No good parser found for content type #{metadata["type"]}!"
  end
  return output
end

# generator for core rule file style of content
def generate_rules_tex(core_rules, template_erb_path, version)
  erb_template = File.read(template_erb_path)
  core_rules.strip_title! # remove the title line as it's defined already in the .erb template
  kramdown_output = Kramdown::Document.new(core_rules, {
    :latex_headers => "title,section,subsection,subsubsection,paragraph,subparagraph",
    :auto_ids => false
  }).to_latex
  template = ERB.new(erb_template)
  return template.result(binding)
end

# generator for reinforcement table content
def generate_reinforcement_table_tex(reinforcement_table, template_erb_path, version)
  erb_template = File.read(template_erb_path)
  reinforcement_table.strip_title! # remove the title line as it's defined already in the .erb template
  kramdown_output = Kramdown::Document.new(reinforcement_table, {
    :latex_headers => "title,section,subsection,subsubsection,paragraph,subparagraph",
    :auto_ids => false
  }).to_latex
  kramdown_output.customize_reinforcement_sections!
  template = ERB.new(erb_template)
  return template.result(binding)
end