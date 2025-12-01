module TagShortNames
  def short_names
    if name =~ /([^(]*) \((.*)\)/
      true_name = ::Regexp.last_match(1)
      aka_string = ::Regexp.last_match(2)
      akas = aka_string.split(', ')
      [true_name, *akas]
    else
      [name]
    end
  end

  def base_name = short_names.first
end
