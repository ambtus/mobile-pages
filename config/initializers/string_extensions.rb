# frozen_string_literal: true

# Restart required even in development mode when you modify this file.

# A list of all the methods defined here to prevent breaking rails by overwriting something in use
%w[chip strip_quotes with_quotes create_hash normalize boring? split_comma squash clean].each do |meth|
  raise "#{meth} is already defined in String class" if String.method_defined?(meth)
end

class String
  def chip = self.[](1..)

  # #TODO raise errors if not quoted
  def strip_quotes = chip.chop

  def with_quotes = "\"#{self}\""

  def create_hash(on1 = ' AND ', on2 = ': ', extra = false, pre = '')
    array = split(on1).pulverize.without('')
    hash = {}

    array.each do |pair|
      key_value = pair.split(on2)
      next unless key_value[0].is_a?(String) && key_value[1].is_a?(String)

      key = key_value[0]
      key = key.gsub(pre, '') if pre.present?
      key = key.to_sym
      value = key_value[1].strip_quotes
      value = value.chop if extra
      hash[key] = value
    end

    hash
  end

  def normalize
    url = URI.extract(self, URI.scheme_list.keys.map(&:downcase)).first.to_s
    if url.match?('fanfiction.net')
      url = url.sub('m.fanfiction', 'www.fanfiction')
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

  # TODO: there must be a better way to do this
  def boring?
    %w[Part Chapter temp Title Page].each do |boring|
      return true if boring == self

      begin
        return true if boring == match(/^\d+\. (.*) \d+$/)[1]
      rescue StandardError
        nil
      end
      begin
        return true if boring == match(/^(.*) \d+$/)[1]
      rescue StandardError
        nil
      end
    end
    false
  end

  def split_comma = split(',').map(&:squish)

  def squash = gsub(/\s/, '')
  def clean = delete('^a-zA-Z0-9')
end
