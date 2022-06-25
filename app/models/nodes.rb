module Nodes

  ### scrubbing content (removing top and bottom nodes)

  def nodes(content = edited_html)
    Nokogiri::HTML(content).xpath('//body').children
  end

  def top_nodes
    nodes[0, 20].map {|n| n.to_s.chomp }
  end

  def bottom_nodes
    nodeset = nodes[-20, 20] || nodes
    nodeset.map {|n| n.to_s.chomp }
  end

  def nodes_above(number); nodes[0,number]; end

  def nodes_below(number); nodes[number ..]; end

  def remove_nodes(top, bottom)
    nodeset = nodes
    top.to_i.times { nodeset.shift }
    bottom.to_i.times { nodeset.pop }
    self.scrubbed_html=nodeset.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
    self.set_wordcount
  end

  def edited_html_file_name
    self.mydirectory + "edited.html"
  end

  def edited_html=(content)
    remove_outdated_downloads
    body = Scrub.sanitize_html(content)
    File.open(self.edited_html_file_name, 'w:utf-8') { |f| f.write(body) }
    self.set_wordcount
  end

  ## but if it doesn't exist (I haven't edited) use the scrubbed version
  def edited_html
    begin
      File.open(self.edited_html_file_name, 'r:utf-8') { |f| f.read }
    rescue Errno::ENOENT
      begin
        File.open(self.scrubbed_html_file_name, 'r:utf-8') { |f| f.read }
      rescue Errno::ENOENT
        ""
      end
    end
  end

  ### scrubbing notes (removing top and bottom nodes)

  def note_nodes
    nodes = Nokogiri::HTML.fragment(self.notes).children
    if nodes.size == 1
      content = Scrub.remove_surrounding(notes)
      Nokogiri::HTML.fragment(content).children
    else
      return nodes
    end
  end

  def top_note_nodes
    note_nodes[0, 5].map {|n| n.to_s.chomp }
  end

  def bottom_note_nodes
    nodeset = note_nodes[-5, 5] || note_nodes
    nodeset.map {|n| n.to_s.chomp }
  end

  def remove_note_nodes(top, bottom)
    nodeset = note_nodes
    top.to_i.times { nodeset.shift }
    bottom.to_i.times { nodeset.pop }
    new=nodeset.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
    Rails.logger.debug "new notes: #{new}"
    update! notes: new, scrubbed_notes: true
    remove_outdated_downloads
  end

  ### Read html is what I would read for an audio book, and also how I edit

  def read_html
    array = nodes.to_a
    array.each_with_index do |node, index|
      header = (index.modulo(10) == 0) ? "<h2>!!!!!SLOW DOWN AND ENUNCIATE!!!!!</h2>" : ""
      anchor = "<a id=section_#{index} href=/pages/#{self.id}/edit?section=#{index}>#{index}</a>"
      type = nodes.at(index).name
      array[index]=nodes.at(index).replace "#{header}<#{type}>#{anchor} #{nodes.at(index).inner_html}</#{type}>"
    end
    array.map(&:to_html).join
  end

  ### editing content (changing text inside a node)

  def section(index)
    nodes.at(index)
  end

  def edit_section(index, new)
    array = nodes.to_a
    array[index]=nodes.at(index).replace(new)
    self.edited_html=array.map(&:to_html).join
  end

end
