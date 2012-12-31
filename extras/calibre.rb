# gem install libxml-ruby
# ruby -rxml script/rails console

DC = 'dc:http://purl.org/dc/elements/1.1/'
# calibre_directory = "/home/alice/Dropbox/CalibreLibrary"
calibre_directory = "/Users/alice/Dropbox/CalibreLibrary"

Dir.glob("#{calibre_directory}/**/*.epub").each do |epub_filename|

  puts epub_filename

  # grab metadata from opf file
  metadata_filename = File.dirname(epub_filename) + "/metadata.opf"
  doc = XML::Parser.file(metadata_filename).parse
  # parse calibre specific metadata
  meta = doc.root.child.next.children.select {|node| node.name == "meta"}
  names = meta.collect{|node| node.attributes["name"]}.collect{|s| s.split(':').last}
  contents = meta.collect{|node| node.attributes["content"]}

  calibre_data = Hash[*names.zip(contents).flatten]
  tags = doc.find('//dc:subject', DC).map(&:content) - ["FanFiction"]
  tags << "Original" unless (tags.include?("Non Fiction") || tags.include?("FanFiction"))
  calibre_rating = calibre_data["rating"].to_i/2

  page = Page.new
  page.uploaded = true
  page.title = doc.find_first('//dc:title', DC).content
  page.created_at = doc.find_first('//dc:date', DC).content
  page.favorite = 6 - calibre_rating unless calibre_rating == 0
  page.last_read = calibre_data["timestamp"] unless calibre_rating == 0

  original_notes = doc.find_first('//dc:description', DC).content rescue ""
  notes = Scrub.remove_surrounding(Scrub.sanitize_html(Scrub.regularize_body(original_notes)))
  notes.gsub!(/<div>/, "<p>")
  notes.gsub!(/<\/div>/, "</p>")

  # deal with series information
  series = calibre_data["series"]
  series_index = calibre_data["series_index"]
  if series
    if series.match("Advent Calendar")
      tags << "Holiday"
      notes = series + ": Day #{series_index}\n\n" + notes
    else
      parent = Page.find_or_create_by_title_and_uploaded!(series + " Series", true)
      page.parent_id = parent.id
      page.position = series_index.to_i
    end
  end

  page.notes = notes

  page.add_author(doc.find_first('//dc:creator', DC).content)

  page.add_genres_from_string=tags.join(", ")

  page.save!
  `cp \"#{epub_filename}\" \"#{page.download_basename}.epub\"`

  page.wordcount = (File.size(epub_filename) - 95000)/3
  page.set_wordcount(false)

  if page.parent
    parent.genres << page.genres
    parent.cache_genres
    parent.authors << page.authors
    parent.update_attribute(:last_read, page.last_read)
    parent.update_attribute(:favorite, page.favorite) if page.favorite < parent.favorite
    parent.set_wordcount(false)
  end

end
