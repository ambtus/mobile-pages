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

  def make_first
    earliest = Page.where(:parent_id => nil).order(:read_after).first.read_after || Date.today
    self.update_attribute(:read_after, earliest - 1.day)
    if self.parent
      parent = self.parent
      parent.update_attribute(:read_after, earliest - 1.day) if parent
      grandparent = parent.parent if parent
      grandparent.update_attribute(:read_after, earliest - 1.day) if grandparent
    end
    return self
  end

  def make_unfinished
    Rails.logger.debug "DEBUG: making #{title} unfinished"
    self.update!(stars: 9, last_read: nil, read_after: Date.today + 5.years)
    return self
  end

  def read_today
    self.update!(last_read: Time.now)
    parent.update_last_read if parent
    return self
  end

  def rate(stars)
    self.update!(stars: stars)
    parts.each{|p| p.update!(stars: stars) && p.update_read_after} if parts.any?
    return self
  end

  def rate_unread(stars)
    Rails.logger.debug "DEBUG: stars for unread: #{stars}"
    self.unread_parts.each do |part|
      Rails.logger.debug "DEBUG: updating #{part.title} with stars: #{stars}"
      part.update!(last_read: Time.now, stars: stars)
    end
    return self
  end

  def update_last_read
    return self unless parts.any?
    last_reads = self.parts.map(&:last_read)
    if last_reads.compact.empty?
      self.update!(last_read: nil)
    elsif last_reads.include?(nil)
      self.update!(last_read: UNREAD_PARTS_DATE)
    else
      self.update!(last_read: last_reads.sort.first)
    end
    #Rails.logger.debug "DEBUG: new last read: #{self.last_read}"
    return self
  end

  def update_stars
    return self unless parts.any?
    mode = parts.map(&:stars).compact.mode
    highest = parts.map(&:stars).sort.last
    Rails.logger.debug "DEBUG: mode: #{mode}, highest: #{highest}"
    if mode
      self.update!(stars: mode)
    else
      self.update!(stars: highest)
    end
    #Rails.logger.debug "DEBUG: new stars: #{self.stars}"
    return self
  end

  def update_read_after
    return self if stars == 9
    if last_read
      Rails.logger.debug "DEBUG: last read: #{self.last_read.to_date}"
      new_read_after = case stars
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
      end
    else
      Rails.logger.debug "DEBUG: created at: #{self.created_at.to_date}"
      new_read_after = created_at
    end
    self.update!(read_after: new_read_after)
    Rails.logger.debug "DEBUG: new read after: #{self.read_after}"
    return self
  end

  def cleanup(recount = true)
    update_last_read.update_stars.remove_outdated_downloads.set_wordcount(recount)
  end



end
