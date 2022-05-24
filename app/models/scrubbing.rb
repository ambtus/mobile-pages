module Scrubbing

  ### scrubbing content (removing top and bottom nodes) is done on clean text

  def nodes(content = scrubbed_html)
    Nokogiri::HTML(content).xpath('//body').children
  end

  def top_nodes
    nodes[0, 20].map {|n| n.to_s.chomp }
  end

  def bottom_nodes
    nodeset = nodes[-20, 20] || nodes
    nodeset.map {|n| n.to_s.chomp }
  end

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
    File.open(self.edited_html_file_name, 'w:utf-8') { |f| f.write(content) }
    self.set_wordcount
  end

  ## but if it doesn't exist (I haven't edited) use the scrubbed version
  def edited_html
    if parts.blank?
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


end
