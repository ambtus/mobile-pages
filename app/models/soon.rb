module Soon
  LABELS = %w{Reading Reread Soonest Soon Default Someday Eventually}

  def soon_label; LABELS[soon + 1]; end

  def set_reading
    new_soon = self.unread? ? -1 : 0
    self.update soon: new_soon
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
