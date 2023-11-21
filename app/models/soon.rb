module Soon
  ####          0       1      2      3       4
  LABELS = %w{Reading Soonest Sooner Default Someday}

  def soon_label; LABELS[soon]; end

  def set_reading
    self.update soon: 0
    return self
  end

  def reset_soon # after reading
    self.update soon: 3
    return self
  end

  def move_soon_up
    return unless parent.present?
    Rails.logger.debug "moving #{self.soon_label} to parent"
    parent.update soon: self.soon
    self.reset_soon
    parent.move_soon_up
  end

end
