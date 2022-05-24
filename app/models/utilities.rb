module Utilities
  # stuff used during testing or development

  # make page.inspect easier to read in DEBUG Rails statements
  def inspect
     regexp = /([\d-]+)( \d\d:\d\d[\d:.+ ]+)/
     super.match(regexp) ? super.gsub(regexp, '\1') : super
  end

  def all_html; parts.blank? ? edited_html : parts.map(&:all_html).join; end

  def self.create_from_hash(hash)
    Rails.logger.debug "Utilities.create_from_hash(#{hash})"
    tag_types = Hash.new("")
    Tag.types.each {|tt| tag_types[tt] = hash.delete(tt.downcase.pluralize.to_sym) }
    inferred_fandoms = hash.delete(:inferred_fandoms)
    page = Page.create!(hash)
    tag_types.compact.each {|key, value| page.send("add_tags_from_string", value, key)}
    if page.parts.blank?
      page.update last_read: hash[:last_read], stars: hash[:stars] || 10
      page.update_read_after if hash[:read_after].blank?
    else
      page.parts.update_all last_read: hash[:last_read], stars: hash[:stars] || 10, read_after: hash[:read_after]
      page.update_from_parts
    end
    page.add_fandoms_to_notes(inferred_fandoms.split(",")) if inferred_fandoms
    Rails.logger.debug "created test page #{page.inspect}"
    page
  end

  def set_raw_from(filename)
    FileUtils.cp(Rails.root + "features/html/#{filename}.html", raw_html_file_name)
    build_clean_from_raw
    set_meta
  end

end
