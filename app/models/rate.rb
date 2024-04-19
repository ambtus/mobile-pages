module Rate
  UNREAD = "unread"
  UNREAD_PARTS_DATE = Date.new(1967) # year first fanzine published. couldn't have read before that ;)

  def unrated?; stars == 10; end
  def stars?; [5,4,3,2,1].include?(self.stars); end
  def star_string
    if stars?
      "#{stars} " + "star".pluralize(stars)
    elsif unrated?
      nil
    else
      Rails.logger.debug "stars are #{self.stars}, should be 5,4,3,2,1 or 10"
      "unknown"
    end
  end

  def unread_parts
    unreads = parts.where(:last_read => [nil, UNREAD_PARTS_DATE])
    Rails.logger.debug "found #{unreads.size} unread parts"
    unreads
  end
  def read_parts
    reads = parts.where.not(:last_read => [nil, UNREAD_PARTS_DATE])
    Rails.logger.debug "found #{reads.size} read parts"
    reads
  end

  def unread?; last_read.blank?; end
  def read?
     answer = last_read.present? && last_read != UNREAD_PARTS_DATE
     #Rails.logger.debug "read? #{last_read} #{answer}"
     return answer
  end
  def unread_parts?
     answer = last_read == UNREAD_PARTS_DATE
     #Rails.logger.debug "unread_parts? #{last_read} #{answer}"
     return answer
  end

  def reset_read_after # Read Later (default)
    self.update_read_after
    self.parent.update_read_after if self.parent
    self.parent.parent.update_read_after if self.parent && self.parent.parent
  end

  def calculated_read_after
    if unread? || unread_parts? || stars == 10
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

  def rate_today(stars, all="No")
    Rails.logger.debug "rate today #{stars} #{all}"
    if parts.empty?
      update! stars: stars
      update! last_read: Time.now unless stars == "9"
      Rails.logger.debug "setting read after to #{calculated_read_after}"
      update! read_after: calculated_read_after
      parent.update_from_parts if self.parent
    else
      parts_to_be_rated = all == "Yes" ? parts : unread_parts
      Rails.logger.debug "rating #{parts_to_be_rated.size} parts"
      parts_to_be_rated.each {|part| part.rate_today(stars, all)}
      update_from_parts
    end
  end

  def update_from_parts
    return self unless parts.any?
    Rails.logger.debug "updating #{self.type} with title #{self.title} from parts"
    update_last_read
    update_stars_from_parts
    update_read_after
    remove_outdated_downloads
    set_wordcount(false)
    parent.update_from_parts if parent
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
    Rails.logger.debug "new last read: #{self.last_read}"
    return self
  end

  def update_stars_from_parts
    stars = parts.map(&:stars).compact.without(10)
    if stars.include?(9)
      self.update!(stars: 9)
    else
      mode = stars.mode
      if mode
        self.update!(stars: mode)
      else
        if stars.empty?
          Rails.logger.debug "no change (no stars)"
        else
          average = stars.sum / stars.size
          self.update!(stars: average)
        end
      end
    end
    Rails.logger.debug "new stars: #{self.stars}"
    return self
  end

  def update_read_after
    self.update!(read_after: calculated_read_after)
    Rails.logger.debug "new read after: #{self.read_after}"
    return self
  end

end
