module Rate
  UNREAD = "unread"
  UNREAD_PARTS_DATE = Date.new(1967) # year first fanzine published. couldn't have read before that ;)
  UNFINISHED = "unfinished"

  def unread_parts
    unreads = parts.where(:last_read => [nil, UNREAD_PARTS_DATE])
    Rails.logger.debug "DEBUG: found #{unreads.size} unread parts"
    unreads
  end
  def read_parts
    reads = parts.where.not(:last_read => [nil, UNREAD_PARTS_DATE])
    Rails.logger.debug "DEBUG: found #{reads.size} read parts"
    reads
  end

  def unread?; last_read.blank?; end
  def read?
     answer = last_read.present? && last_read != UNREAD_PARTS_DATE
     #Rails.logger.debug "DEBUG: read? #{last_read} #{answer}"
     return answer
  end
  def unread_parts?
     answer = last_read == UNREAD_PARTS_DATE
     #Rails.logger.debug "DEBUG: unread_parts? #{last_read} #{answer}"
     return answer
  end

  def earliest; Page.where(:parent_id => nil).order(:read_after).first.read_after - 1.day || Date.yesterday; end

  def make_first # Read Now
    self.update_attribute(:read_after, earliest)
    parent.make_first if self.parent
    return self
  end

  def reset_read_after # Read Later (default)
    self.update_read_after
    self.parent.update_read_after if self.parent
    self.parent.parent.update_read_after if self.parent && self.parent.parent
  end

  def calculated_read_after
    if stars == 9
      Date.today + 5.years
    elsif unread? || unread_parts? || stars == 10
      created_at
    else
      case stars
        when 5
          last_read + 6.months
        when 4
          last_read + 1.year
        when 3
          last_read + 2.years
        when 2
          last_read + 3.years
        when 1
          last_read + 4.years
        else
          raise "unexpected last_read/stars #{last_read}/#{stars}"
      end
    end
  end

  def update_read_after
    self.update!(read_after: calculated_read_after)
    Rails.logger.debug "DEBUG: new read after: #{self.read_after}"
    return self
  end

  def rate_today(stars, all="No")
    Rails.logger.debug "DEBUG: rate today #{stars} #{all}"
    if parts.empty?
      update! stars: stars
      update! last_read: Time.now unless stars == "9"
      Rails.logger.debug "DEBUG: setting read after to #{calculated_read_after}"
      update! read_after: calculated_read_after
    else
      parts_to_be_rated = all == "Yes" ? parts : unread_parts
      Rails.logger.debug "DEBUG: rating #{parts_to_be_rated.size} parts"
      parts_to_be_rated.update_all stars: stars
      parts_to_be_rated.update_all last_read: Time.now unless stars == "9"
      update_from_parts
    end
    parent.update_from_parts if self.parent
    parent.parent.update_from_parts if parent && parent.parent
  end

  def update_from_parts
    return self unless parts.any?
    Rails.logger.debug "DEBUG: updating #{self.title} #{self.class} from parts"
    update_last_read
    update_stars
    update_read_after
    remove_outdated_downloads
    set_wordcount(false)
  end

  def update_last_read
    return self unless parts.any?
    last_reads = parts.map(&:last_read)
    if last_reads.compact.empty?
      self.update!(last_read: nil)
    elsif last_reads.include?(nil)
      self.update!(last_read: UNREAD_PARTS_DATE)
    else
      self.update!(last_read: last_reads.sort.first)
    end
    Rails.logger.debug "DEBUG: new last read: #{self.last_read}"
    return self
  end

  def update_stars
    return self unless parts.any?
    stars = parts.map(&:stars).compact.without(10)
    mode = stars.mode
    highest = stars.sort.last || 10
    Rails.logger.debug "DEBUG: mode: #{mode}, highest: #{highest}"
    if mode
      self.update!(stars: mode)
    else
      self.update!(stars: highest)
    end
    Rails.logger.debug "DEBUG: new stars: #{self.stars}"
    return self
  end


end
