# restart rails if changed

class DefaultFormBuilder < ActionView::Helpers::FormBuilder

  #Adds default placeholder directly inline to a form text field
  #Accepts all the options normally passed to form.text_field
  #If the text field is not the default, don't blur it (it's been set elsewhere)
  def text_field(method, default = nil, options = {})
    #Check to see if default for this field has been supplied and humanize the field name if not.
    default_text = method.to_s.humanize
    text = default || default_text
    if text == default_text
      text = method.to_s.humanize
      options = {:maxlength => 255, :size => 30, :class => "gray-input", :value => text, :onblur=>"if(this.value == '') { this.value='#{text}';this.style.color = '';}", :onfocus=>"if (this.value == '#{text}') {this.value='';this.style.color = 'black';}"}.merge options
    else 
      text = default
      options = {:maxlength => 255, :size => 30, :value => text }.merge options
    end
    super(method, options)
  end
  def text_area(method, default = nil, options = {})
    #Check to see if default for this field has been supplied and humanize the field name if not.
    text = default || method.to_s.humanize
    #Finally hand off to super to deal with the display of the label
    options = {:class => "gray-input", :value => text, :onblur=>"if(this.value == '') { this.value='#{text}';this.style.color = '';}", :onfocus=>"if (this.value == '#{text}') {this.value='';this.style.color = 'black';}"}.merge options
    super(method, options)
  end

end
