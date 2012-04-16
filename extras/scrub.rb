# coding: utf-8

module Scrub
  def self.sanitize_version
    return 1
  end

  # regularize imported html to fix garbled encodings
  #    clean up whitespace and remove javascript
  #    returns what's inside the <body> elements
  #    to be saved as raw_html (raw == pre-sanitized)
  #    called before saving to raw_html file, and nowhere else
  def self.regularize_body(html)
    return html if html.blank?
    html = html.encode("utf-8")
    replacements = [
                   [ '&#13;', '' ],
                   [ '&#151;', '&#8212;' ],
                   [ '&#146;', '&#8217;' ],
                   [ '&#145;', '&#8216;' ],
                   [ '&#148;', '&#8221;' ],
                   [ '&#147;', '&#8220;' ],
                   [ '&nbsp;', ' ' ],
                   [ 'Â<A0>', ' '],
                   [ 'â€”', "—" ],
                   [ 'â€“', "—" ],
                   [ 'â€¦', '…'],
                   [ 'Ã©', 'é'],
                   [ 'â€œ', '“'],
                   [ 'â€˜', '‘'],
                   [ 'â€™', '’'],
                   [ 'â€', '”'],
                   ]
    replacements.each do |replace|
      html = html.gsub(replace.first, replace.last)
    end
    html.gsub!(/[\s]+/, " ")
    doc = Nokogiri::HTML(html)
    body = doc.xpath('//body').first
    body.traverse do |node|
      case node.name
        when 'script'
          node.children.each{|child| child.remove}
          node.remove
      end
    end
    nodeset = body.children
    nodeset.each do |top_node|
      nodeset.delete(top_node) if (top_node.is_a?(Nokogiri::XML::Text) && top_node.blank?)
    end
    nodeset.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
  end

  # sanitize
  def self.sanitize_html(html)
    return html unless html.is_a? String
    # remove most formatting
    html = Sanitize.clean(
      html,
      :elements => [ 'a', 'b', 'big', 'blockquote', 'br', 'center',
                     'div', 'dt', 'em', 'i', 'h1', 'h2', 'h3', 'h4',
                     'h5', 'h6', 'hr', 'img', 'li', 'p', 'small',
                     'strike', 'strong', 'sub', 'sup', 'u'],
      :attributes => { 'a' => ['href'],
                       'img' => ['align', 'alt', 'height', 'src', 'title', 'width'] })
    # remove anchor links
    html.gsub!(/<a><\/a>/, "")
    # alright drives me batty
    html.gsub!(/([Aa])lright/) {|s| $1 + "ll right"}
    # extra breaks inside paragraphs
    html.gsub!(/<p><br ?\/?>/, "<p>")
    html.gsub!(/<br ?\/?><\/p>/, "</p>")
    # more than two breaks are probably a section
    html.gsub!(/(<br ?\/?>){3,}/, '<hr />')
    # when sections are taken care of, multiple breaks are a paragraph
    html.gsub!(/(<br ?\/?>?){2,}/, '<p>')
    # multiple empty paragraphs are probably a section
    html.gsub!(/(<p><\/p>){2,}/, '<hr />')
    # remove empty paragraphs
    html.gsub!(/(<p><\/p>)/, "")
    # remove stray paragraphs around sections
    html.gsub!(/<p><hr \/>/, '<hr />')
    html.gsub!(/<hr \/><\/p>/, '<hr />')
    # common section designations
    html.gsub!(/_{5,}/, '<hr />')
    # condense multiple sections
    html.gsub!(/(<hr \/>){2,}/, '<hr />')
    # style sections
    html.gsub!(/<hr \/>/, '<hr width="80%"/>')
    # remove back_to_back bold and italic
    html.gsub!(/<\/b>([_., -]*)<b>/) {|s| $1}
    html.gsub!(/<\/i>([_., -]*)<i>/) {|s| $1}
    html
  end

  def self.remove_surrounding(html)
    return html unless html.is_a? String
    doc = Nokogiri::HTML(html)
    body = doc.xpath('//body').first
    nodeset = body.children
    while nodeset.size == 1 && nodeset.first.is_a?(Nokogiri::XML::Element)
      nodeset = nodeset.first.children
      nodeset.each do |top_node|
        nodeset.delete(top_node) if (top_node.is_a?(Nokogiri::XML::Text) && top_node.blank?)
      end
    end
    nodeset.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
  end


  def self.fetch(url)
    return if url.blank?
    agent = Mechanize.new { |a| a.log = Logger.new("#{Rails.root}/log/mechanize.log") }
    auth = MyWebsites.getpwd(url)
    agent.auth(auth[:username], auth[:password]) if auth
    content = agent.get(MyWebsites.geturl(url))
    if url.match(/livejournal/) && content.forms.first.try(:button).try(:name) == "adult_check"
       form = content.forms.first
       content = agent.submit(form, form.buttons.first)
    end
    return content.body.force_encoding(agent.page.encoding)
  end

end
