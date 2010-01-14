module ApplicationHelper

  def onblur_text_tag(name, default = nil, options = {})
    text = default || name.to_s.humanize
    options = {:class => "gray-input", :onblur=>"if(this.value == '') { this.value='#{text}';this.style.color = '';}", :onfocus=>"if (this.value == '#{text}') {this.value='';this.style.color = 'black';}"}.merge options
    text_field_tag name, default, options 
  end

end
