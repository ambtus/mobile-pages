# restart rails if changed

class DefaultFormBuilder < ActionView::Helpers::FormBuilder

  #Adds default placeholder directly inline to a form text field
  #Accepts all the options normally passed to form.text_field
  def text_field(method, default = nil, options = {})
    #Check to see if default for this field has been supplied and humanize the field name if not.
    text = default || method.to_s.humanize
    #Finally hand off to super to deal with the display of the label
    options = {:class => "gray-input", :value => text, :onblur=>"if(this.value == '') { this.value='#{text}';this.style.color = '';}", :onfocus=>"if (this.value == '#{text}') {this.value='';this.style.color = 'black';}"}.merge options
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
