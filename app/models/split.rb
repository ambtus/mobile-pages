module Split

  def create_children(number)
    self.update type: Book
    ch1nodes = nodes_above(number)
    ch1title = ch1nodes.shift.text
    chapter1 = Chapter.create!(title: ch1title, parent_id: self.id, position: 1)
    chapter1.raw_html = ch1nodes.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')

    ch2nodes = nodes_below(number)
    ch2title = ch2nodes.shift.text
    chapter2 = Chapter.create!(title: ch2title, parent_id: self.id, position: 2)
    chapter2.raw_html = ch2nodes.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
  end

  def created_via_split?; url.blank? && File.exist?(raw_html_file_name); end

  def create_sibling(number)
    sibling_nodes = nodes_below(number)
    sibling_title = sibling_nodes.shift.text
    sibling = Chapter.create!(title: sibling_title, parent_id: parent_id, position: position + 1)
    sibling.raw_html = sibling_nodes.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')

    if created_via_split?
      self.raw_html = nodes_above(number).to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
    else
      FileUtils.mv(raw_html_file_name, mydirectory + "raw.before_split.html")
      my_nodes = nodes_above(number)
      self.update title: my_nodes.shift.text
      self.raw_html = my_nodes.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
    end
  end

end
