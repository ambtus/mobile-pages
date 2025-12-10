# frozen_string_literal: true

def create_local_page(raw_name, url = nil)
  page = local_page(url: url)
  page.raw_html = get_raw_from(raw_name)
  fake_initial_fetch(page)
  page
end

def create_local_parent(raw_nav_name, url = nil)
  page = local_page(url: url)
  page.navigate_html = get_raw_from(raw_nav_name)
  fake_initial_fetch(page)
  page
end

def recreate_local_page(raw_name, url)
  page = local_page(url: url)
  copy_raw_from raw_name, page
  fake_initial_fetch(page)
  page
end

def fake_initial_fetch(page)
  Rails.logger.debug { 'fake initial fetch' }

  if page.url.present?
    Rails.logger.debug { "  for url #{page.url}" }
    if page.ao3?
      page.fetch_ao3(refetch: false)
    elsif page.url.match?('sidrasue.com')
      page.initial_fetch
    else
      page.set_meta
    end
  elsif page.base_url.present?
    Rails.logger.debug { "  for base_url #{page.base_url}" }
    page.update! type: Book
    if page.base_url.match?(/fanfiction.net/)
      Rails.logger.debug 'setting url for book'
      page.url = page.base_url.delete('*')
    end
    match = page.url_substitutions.match('-')
    array = if match
              match.pre_match.to_i..match.post_match.to_i
            else
              page.url_substitutions.split
            end
    count = 1
    array.each do |sub|
      url = page.base_url.gsub('*', sub.to_s)
      chapter = Page.find_by url: url
      if chapter
        chapter.update!(position: count, parent_id: page.id)
        Rails.logger.debug { "found #{chapter.inspect}" }
      else
        title = "Part #{count}"
        Rails.logger.debug { "creating new chapter with title: #{title}" }
        chapter = Chapter.create!(title: title, url: url, position: count, parent_id: page.id)
        chapter.initial_fetch if chapter.url.match?('sidrasue.com')
      end
      count = count.next
    end

  elsif page.urls.present?
    Rails.logger.debug { "  for multiple urls #{page.urls}" }
    page.update! type: Book
    page.parts_from_urls(page.urls, refetch: false)
    page.parts.each do |part|
      part.initial_fetch if part.url.match?('sidrasue.com')
    end
  else
    Rails.logger.debug '  for page without url(s) [doing nothing]'
  end
  Rails.logger.debug { "  created: #{page.inspect}" }
  page
end

def create_from_hash(hash)
  Rails.logger.debug { "creating from #{hash}" }
  tag_types = Hash.new('')
  Tag.types.each { |tt| tag_types[tt] = hash.delete(tt.downcase.pluralize.to_sym) }
  inferred_fandoms = hash.delete(:inferred_fandoms)
  page = Page.create!(hash)
  if page.url&.match('sidrasue.com')
    page.initial_fetch
  else
    fake_initial_fetch(page)
  end
  if page.errors.map(&:type).include? %(couldn't resolve host name)
    skip_this_scenario 'This is a pending scenario because the network is down'
  end
  tag_types.compact.each { |key, value| page.send(:add_tags_from_string, value, key) }
  if page.can_have_parts?
    if hash[:last_read] || hash[:updated_at] || hash[:read_after]
      page.parts.update_all last_read: hash[:last_read], stars: hash[:stars] || 10, read_after: hash[:read_after],
updated_at: hash[:updated_at]
    elsif hash[:stars]
      page.parts.each { |p| p.rate_today(hash[:stars]) }
    end
    page.update_from_parts
  elsif hash[:last_read] || hash[:updated_at] || hash[:read_after]
    page.update last_read: hash[:last_read], stars: hash[:stars] || 10, updated_at: hash[:updated_at]
    page.update_read_after if hash[:read_after].blank?
  elsif hash[:stars]
    page.rate_today(hash[:stars])
  end
  page.update position: hash[:position]
  page.add_fandoms_to_notes(inferred_fandoms.split(',')) if inferred_fandoms
  page.set_meta
  page.set_wordcount
  Rails.logger.debug { "created test page #{page.inspect}" }
  page
end
