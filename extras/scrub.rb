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
    html.gsub!(/(<br ?\/>?){2,}/, '<p>')
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

  def self.html_to_text(text)
    return "" unless text
    text = text.gsub(/ style="page-break-before:always"/, '')
    text = text.gsub(/ width="80%"/, '')
    text = text.gsub(/<a .*?>(.*?)<\/a>/m) {|s| " [#{$1}] " unless $1.blank?}
    text = text.gsub(/<\/?b>/, "\*")
    text = text.gsub(/<\/?big>/, "\*")
    text = text.gsub(/<\/?blockquote>/, "")
    text = text.gsub(/<br ?\/?>/, "\n")
    text = text.gsub(/<\/?center>/, "")
    text = text.gsub(/<\/?div.*?>/, "\n")
    text = text.gsub(/<dt>/, "")
    text = text.gsub(/<\/dt>/, ": ")
    text = text.gsub(/<\/?em.*?>/, "_")
    text = text.gsub(/<\/?i>/, "_")
    text = text.gsub(/<h1>(.*?)<\/h1>/) {|s| "\# #{$1} \#" unless $1.blank?}
    text = text.gsub(/<h2>(.*?)<\/h2>/) {|s| "\#\# #{$1} \#\#" unless $1.blank?}
    text = text.gsub(/<h3>(.*?)<\/h3>/) {|s| "\#\#\# #{$1} \#\#\#" unless $1.blank?}
    text = text.gsub(/<\/?h\d.*?>/, "\*")
    text = text.gsub(/<hr>/, "______________________________\n")
    text = text.gsub(/<img.*?alt="(.*?)".*?>/) {|s| " [#{$1}] " unless $1.blank?}
    text = text.gsub(/<img.*?>/, "")
    text = text.gsub(/<li>/, "* ")
    text = text.gsub(/<\/?li>/, "")
    text = text.gsub(/<\/?p>/, "\n")
    text = text.gsub(/<small>/, '(')
    text = text.gsub(/<\/small>/, ')')
    text = text.gsub(/<\/?strike>/, "==")
    text = text.gsub(/<\/?strong>/, "\*")
    text = text.gsub(/<sup>/, "^")
    text = text.gsub(/<\/sup>/, "")
    text = text.gsub(/<sub>/, "(")
    text = text.gsub(/<\/sub>/, ")")
    text = text.gsub(/<\/?u>/, "_")
    text = text.gsub(/_([ ,.?-]+)_/) {|s| $1}
    text = text.gsub(/\*([ ,.?-]+)\*/) {|s| $1}
    text = text.gsub(/&amp;/, "&")
    text = text.gsub(/&lt;/, "<")
    text = text.gsub(/&gt;/, ">")
    text = text.gsub(/ +/, ' ').gsub(/\n+ */, "\n\n").gsub(/(\n){4,}/, "\n\n")
    text.strip
  end

  def self.html_to_pml(html, title, author_string)
    return "" unless html
    text = html.gsub(/<a .*?>(.*?)<\/a>/m) {|s| " [#{$1}] " unless $1.blank?}
    text = text.gsub(/<img.*?alt="(.*?)".*?>/) {|s| " [#{$1}] " unless $1.blank?}
    text = text.gsub(/<img.*?>/, "")
    text = text.gsub(/<h1>/, '\p\X0')
    text = text.gsub(/<\/h1>/, '\X0')
    text = text.gsub(/<h2>/, '\p\X1')
    text = text.gsub(/<\/h2>/, '\X1')
    text = text.gsub(/<\/?b>/, '\B')
    text = text.gsub(/<\/?strong>/, '\B')
    text = text.gsub(/<\/?big>/, '\l')
    text = text.gsub(/<\/?blockquote>/, '')
    text = text.gsub(/<br ?\/?>/, "\n")
    text = text.gsub("<center>", '\c')
    text = text.gsub(/<\/center>/, "\n" + '\c' + "\n")
    text = text.gsub(/<\/?div.*?>/, "\n")
    text = text.gsub(/<dt>/, "")
    text = text.gsub(/<\/dt>/, ": ")
    text = text.gsub(/<\/?em.*?>/, '\i')
    text = text.gsub(/<\/?i>/, '\i')
    text = text.gsub(/<\/?h\d.*?>/, '\B')
    text = text.gsub(/<hr \/>/, '\w="50%"')
    text = text.gsub(/<li>/, "* ")
    text = text.gsub(/<\/?li>/, "")
    text = text.gsub(/<\/?p>/, "\n")
    text = text.gsub(/<small>/, '\s')
    text = text.gsub(/<\/small>/, '\s')
    text = text.gsub(/<\/?strike>/, '\o')
    text = text.gsub(/<sup>/, '\Sp')
    text = text.gsub(/<\/sup>/, '\Sp')
    text = text.gsub(/<sub>/, '\Sb')
    text = text.gsub(/<\/sub>/, '\Sb')
    text = text.gsub(/<\/?u>/, '\u')
    text = text.gsub(/_([ ,.?-]+)_/) {|s| $1}
    text = text.gsub(/\*([ ,.?-]+)\*/) {|s| $1}
    text = text.gsub(/&amp;/, "&")
    text = text.gsub(/&lt;/, "<")
    text = text.gsub(/&gt;/, ">")
    text = text.gsub(/ +/, ' ').gsub(/\n+ */, "\n\n").gsub(/(\n){4,}/, "\n\n")
    text = '\vTITLE="' + title + '" AUTHOR="' + author_string +'"\v' + "\n" + text.strip
  end

end
