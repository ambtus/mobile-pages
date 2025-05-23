module ApplicationHelper

  # if there is a value (the value is not nil):
  #  the value is black and can be edited when clicked
  # if there is NOT a value (the value is nil):
  #  the hint is grey and disappears when clicked
  def hinted_text_field_tag(name, value = nil, hint = "Click and enter text", options={})
    value = value.nil? ? hint : value
    color = (value == hint) ? "gray-input" : "black-input"
    options = {:class => "#{color}", :onblur=>"if(this.value == '') { this.value='#{hint}';this.style.color = '';}", :onfocus=>"if (this.value == '#{hint}') {this.value='';this.style.color = 'black';}"}.merge(options.stringify_keys)
    text_field_tag name, value, options
  end

  def hinted_text_area_tag(name, value = nil, hint = "Click and enter text", options={})
    value = value.nil? ? hint : value
    color = (value == hint) ? "gray-input" : "black-input"
    options = {:class => "#{color}", :onblur=>"if(this.value == '') { this.value='#{hint}';this.style.color = '';}", :onfocus=>"if (this.value == '#{hint}') {this.value='';this.style.color = 'black';}"}.merge(options.stringify_keys)
    text_area_tag name, value, options
  end

  def download_url_for_page(page, format)
    url_for page.download_url(format)
  end

  def link_to_tag(tag, name)
    if tag.is_a? Author
      link_to name, author_path(tag)
    elsif tag.is_a? Fandom
      link_to name, fandom_path(tag)
    else
      link_to_tag_pages(tag, name)
    end
  end

  def link_to_tag_pages(tag, name)
     link_to name, pages_path(find: tag.base_name)
  end

end
