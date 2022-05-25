module Soon
  LABELS = %w{Reading Soonest Soon Default Later Eventually}

  def soon_label; LABELS[soon]; end

  def set_reading # Reading
    self.update soon: 0
    return self
  end

  def reset_soon # after reading
    self.update soon: 3
    return self
  end

end
