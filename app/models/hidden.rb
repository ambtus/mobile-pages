class Hidden < Tag

  def self.names
    self.all.map(&:name)
  end

end
