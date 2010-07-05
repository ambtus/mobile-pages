module ApplicationHelper


  def hinted_text_field_tag(name, value = nil, hint = "Click and enter text", options={})
    value = value.nil? ? hint : value
    color = (value == hint) ? "gray-input" : "black-input"
    options = {:class => "#{color}", :onblur=>"if(this.value == '') { this.value='#{hint}';this.style.color = '';}", :onfocus=>"if (this.value == '#{hint}') {this.value='';this.style.color = 'black';}"}.merge(options.stringify_keys)
    text_field_tag name, value, options
  end

  # inside form_for example
  #hinted_text_field_tag :search, params[:search], "Enter name, brand or mfg.", :size => 30
  # => <input id="search" name="search" onblur="if($(this).value == ''){$(this).value = 'Enter name, brand or mfg.'}" onclick="if($(this).value == 'Enter name, brand or mfg.'){$(this).value = ''}" size="30" type="text" value="Enter name, brand or mfg." />

  def hinted_text_area_tag(name, value = nil, hint = "Click and enter text", options={})
    value = value.nil? ? hint : value
    color = (value == hint) ? "gray-input" : "black-input"
    options = {:class => "#{color}", :onblur=>"if(this.value == '') { this.value='#{hint}';this.style.color = '';}", :onfocus=>"if (this.value == '#{hint}') {this.value='';this.style.color = 'black';}"}.merge(options.stringify_keys)
    text_area_tag name, value, options
  end

end
