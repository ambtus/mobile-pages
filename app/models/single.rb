# encoding=utf-8
# frozen_string_literal: true

class Single < Page
  def fetch_ao3
    Rails.logger.debug { "fetch_ao3 single #{id}" }
    fetch_raw && set_meta
  end

  def get_chapter_list
    html = scrub_fetch("#{url}/navigate")
    if html
      doc = Nokogiri::HTML(html)
      doc.xpath('//ol//a')
    else
      Rails.logger.debug 'unable to navigate'
      false
    end
  end

  def chapter_url
    chapter_list = get_chapter_list
    return false unless chapter_list

    if chapter_list.size == 1
      Rails.logger.debug 'still only one chapter'
      false
    else
      "https://archiveofourown.org#{chapter_list.first['href']}"

    end
  end

  def make_me_a_chapter(passed_url)
    position
    return false unless chapter_url

    book = Book.create!(title: 'temp')
    Rails.logger.debug { "making #{id} into a chapter of Book #{book.id} with #{chapter_url}" }
    if parent
      book.parent_id = parent.id
      book.position = position
    end
    self.parent_id = book.id
    self.position = 1
    book.url = passed_url
    self.url = chapter_url
    self.type = 'Chapter'
    self.title = 'temp'
    save!
    book.save!
    book.fetch_ao3
    self
  end

  # if called from the command line, can pass the new chapter url
  # if called from the web, the chapter has no url until refetched
  def make_me_into_a_chapter(chapter_url = nil)
    book = Book.create!(title: title)
    if parent
      book.parent_id = parent.id
      book.position = position
    end
    self.parent_id = book.id
    self.position = 1
    book.url = url
    self.url = chapter_url
    self.type = 'Chapter'
    self.title = 'temp'
    save!
    book.save!
    move_tags_up
    move_soon_up
    book.rebuild_meta
  end
end
