module SpecialTags

  WIP = "WIP"
  TT = "Time Travel"
  FI = "Fix-it"
  OTHER = "Other Fandom"
  CLIFF = "Cliffhanger"
  UNFINISHED = "unfinished"

  def wip_tag; Con.find_or_create_by(name: WIP); end
  def wip_present?; tags.cons.include?(wip_tag);end
  def set_wip; tags.append(wip_tag) unless wip_present? && reset_con; end
  def unset_wip; tags.delete(wip_tag) if wip_present? && reset_con; end

  def tt_tag; Pro.find_or_create_by(name: TT); end
  def tt_present?; tags.pros.include?(tt_tag);end
  def set_tt; tags.append(tt_tag) unless tt_present?; end

  def fi_tag; Pro.find_or_create_by(name: FI); end
  def fi_present?; tags.pros.include?(fi_tag);end
  def set_fi; tags.append(fi_tag) unless fi_present?; end

  def of_tag; Fandom.find_or_create_by(name: OTHER); end
  def of_present?; self.tags.fandoms.include?(of_tag);end
  def set_of; tags.append(of_tag) unless of_present?; end
  def toggle_of
    of_present? ? tags.delete(of_tag) : self.tags.append(of_tag)
    return self
  end

  def cliff_tag; Con.find_or_create_by(name: CLIFF); end
  def cliff_present?; all_tags.include?(CLIFF);end
  def update_cliff(bool)
    if bool == "Yes"
      if parent.blank?
        self.tags.append(cliff_tag)
        self.reset_con
      else
        unless parent.cliff_present?
          Rails.logger.debug "adding cliffhanger to #{parent.title}"
          parent.tags.append(cliff_tag)
          parent.reset_con
        end
      end
    elsif bool == "No"
      if parent.blank?
        self.tags.delete(cliff_tag)
        self.reset_con
      else
        if parent.cliff_present?
          Rails.logger.debug "removing cliffhanger from #{parent.title}"
          parent.tags.delete(cliff_tag)
          parent.reset_con
        end
      end
    else
      raise "why isn’t #{bool} Yes or No?"
    end
  end

  def unfinished_tag; Con.find_or_create_by(name: UNFINISHED); end
  def unfinished_present?; self.tags.include?(unfinished_tag);end
  def update_unfinished(bool)
    if bool == "Yes"
      self.tags.append(unfinished_tag)
    elsif bool == "No"
      self.tags.delete(unfinished_tag)
    else
      raise "why isn’t #{bool} Yes or No?"
    end
    reset_con
  end

end
