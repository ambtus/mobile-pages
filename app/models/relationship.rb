class Relationship < Tag

  def self.names
    self.by_name.map(&:name)
  end

end
