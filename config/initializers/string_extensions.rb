# frozen_string_literal: true

# Restart required even in development mode when you modify this file.

# A list of all the methods defined here to prevent breaking rails by overwriting something in use
%w[chip strip_quotes with_quotes normalize split_comma squash clean next_numeric].each do |meth|
  raise "#{meth} is already defined in String class" if String.method_defined?(meth)
end

class String
  def chip = self.[](1..)

  # #TODO raise errors if not quoted
  def strip_quotes = chip.chop

  def with_quotes = "\"#{self}\""

  def normalize
    url = URI.extract(self, URI.scheme_list.keys.map(&:downcase)).first.to_s
    if url.match?('fanfiction.net')
      url = url.sub('m.fanfiction', 'www.fanfiction')
      url = url.sub(/^http:/, 'https:')
      url = url.sub(Regexp.new('/s/(.*)/(.*)/.*'), '/s/\1/\2')
      url = url.chop if url.match?('/$')
    end
    if url.match?('archiveofourown.org')
      url = url.sub(/^http:/, 'https:')
      url = url.chop if url.match?('/$')
      url = url.sub(/#workskin$/, '')
    end
    url
  end

  def split_comma = split(',').map(&:squish)

  def squash = gsub(/\s/, '')
  def clean = delete('^a-zA-Z0-9')

  def next_numeric
    last_number = scan(/\d+/).last
    next_number = last_number.next
    reverse.sub(last_number.reverse, next_number.reverse).reverse
  end
end
