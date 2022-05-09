# encoding=utf-8

class Series < Page

  def fetch_ao3
    Rails.logger.debug "DEBUG: fetch_ao3 series #{self.id}"
    fetch_raw && get_works_from_ao3 && set_meta && update_from_parts
  end

  def get_works_from_ao3
    work_list = raw_html.scan(/work-(\d+)/).flatten.uniq
    Rails.logger.debug "DEBUG: work list for #{self.id}: #{work_list}"
    work_list.each_with_index do |work_id, index|
      count = index + 1
      url = "https://archiveofourown.org/works/#{work_id}"
      work = Page.find_by_url(url)
      if work.nil?
        #do its chapters exist?
        possibles = Page.where("url LIKE ?", url + "/chapters/%")
      end
      if possibles
        possibles.each do |p|
          if p.parent && p.parent == self
           Rails.logger.debug "DEBUG: selecting from my first level possibles #{p.title}"
           work = p
           break
          elsif p.parent && p.parent.parent.nil?
           Rails.logger.debug "DEBUG: selecting from unclaimed first level possibles #{p.parent.title}"
           work = p.parent
           break
          elsif p.parent && p.parent && p.parent.parent == self
            Rails.logger.debug "DEBUG: selecting from my second level possibles #{p.parent.title}"
            work = p.parent
            break
          elsif p.parent && p.parent.parent && p.parent.parent.parent.nil?
            Rails.logger.debug "DEBUG: selecting from unclaimed second level possibles #{p.parent.parent.title}"
            work = p.parent.parent
            break
          end
        end
      end
      if work
        if work.position == count && work.parent_id == self.id
          Rails.logger.debug "DEBUG: work already exists, skipping #{work.title} in position #{count}"
        else
          Rails.logger.debug "DEBUG: work already exists, updating #{work.title} with position #{count} and parent_id #{self.id}"
          work.update!(position: count, parent_id: self.id)
        end
      else
        Rails.logger.debug "DEBUG: work does not yet exist, creating ao3/works/#{work_id} in position #{count} and parent_id #{self.id}"
        Book.create!(:url => url, :position => count, :parent_id => self.id, :title => "temp").set_wordcount
        sleep 5 unless count == work_list.size
      end
    end
    return true
  end

end
