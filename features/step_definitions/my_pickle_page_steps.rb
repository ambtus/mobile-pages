# create a page
Given /a titled page exists(?: with #{capture_fields})?$/ do |fields|
  if fields.blank?
    fields = 'title: "1"'
  elsif !fields.match("title")
    fields = fields + ', title: "default"' 
  end
  create_model("page", fields)
end
# create many pages
Given /(\d+) titled pages exist$/ do |count|
  count.to_i.times do |i|
   create_model("page", "title: \"page #{(i+1).to_s}\"")
   Kernel::sleep 1
  end
end
