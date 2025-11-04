# frozen_string_literal: true

def create_remote_page(url)
  page = Page.create!(url: url)
  page.initial_fetch
end

def test_file(filename) = Rails.root + "test_helpers/html_files/#{filename}.html"

def local_page(url = nil)
  url ? Page.create!(url: url) : Page.create!(title: 'Page 1')
end

def get_raw_from(filename) = File.read(test_file(filename))

# for testing on old raw files: doesn't regularize_body
def copy_raw_from(filename, page)
  FileUtils.cp(test_file(filename), page.raw_html_file_name)
  page.build_clean_from_raw
end

def note_file(filename) = File.read(Rails.root + "test_helpers/html_files/#{filename}.html")

def create_hash(string)
  hash = {}
  array = string.split(' AND ').pulverize.without('')
  array.each do |pair|
    key_value = pair.split(': ')
    next unless key_value[0].is_a?(String) && key_value[1].is_a?(String)

    key = key_value[0]
    key = key.to_sym
    value = key_value[1].strip_quotes
    hash[key] = value
  end
  hash[:title] = hash[:title] || 'Page 1'
  hash[:urls] = hash[:urls].split(',').join("\r") if hash[:urls]
  Rails.logger.debug { "created hash: #{hash}" }
  hash
end

def itl = Book.find_or_create_by(title: 'In This Land')

def add_itl_part(int)
  chapter = recreate_local_page "inthisland#{int}", "http://www.matthewhaldemantime.com/InThisLand/inthisland#{int}.html"
  itl.add_chapter chapter.url
  chapter.update title: "Part #{int}"
end

def create_itl
  [9, 504, 604, 606, 831, 889, 894].each do |int|
    add_itl_part(int)
  end
end

def drabble = 1.sentence(100, variance: false)
def short = Array.new(5) { "<p>#{drabble}</p>" }.join
def medium = Array.new(10) { short }.join
def long = Array.new(10) { medium }.join
def epic = Array.new(10) { long }.join
