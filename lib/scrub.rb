module Scrub 

  def self.to_xhtml(body)
    Scrub.minimize(body.children).to_xhtml(:encoding => 'utf8').gsub("&#13;", '')
  end

  def self.regularize_body(html)
    replacements = [
                   [ '&#151;', '&#8212;' ],
                   [ '&#146;', '&#8217;' ],
                   [ '&#145;', '&#8216;' ],
                   [ '&#148;', '&#8221;' ],
                   [ '&#147;', '&#8220;' ],
                   [ '&nbsp;', ' ' ],
                   ]
    replacements.each do |replace|
      html.gsub!(replace.first, replace.last)
    end
    html.gsub!(/[\s]+/, " ")
    doc = Nokogiri::HTML(html)
    body = doc.xpath('//body').first
    Scrub.remove_scripts(body) if body
  end

  def self.minimize(nodeset)
    nodeset = Scrub.remove_blanks(nodeset)
    Scrub.remove_surrounding(nodeset)
  end
  
  def self.sanitize_html(html)
    html = Sanitize.clean(html, :elements => [ 'a', 'b', 'big', 'blockquote', 'br', 'center', 'div', 'dt', 'em', 'i', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'hr', 'img', 'li', 'p', 'small', 'strike', 'strong', 'sub', 'sup', 'u'], :attributes => { 'a' => ['href'], 'div' => ['id', 'class'], 'img' => ['align', 'alt', 'height', 'src', 'title', 'width'] })
    html.gsub!(/<p> ?<\/p>/, "<br />")
    html.gsub!(/(<br \/> ?){3,}/, "<hr />")
    html.gsub!(/<br \/> ?<br \/>/, "<p>")
    html.gsub!(/<a><\/a>/, "")
    html
  end

  def self.html_to_text(html)
    return "" unless html
    text = html.gsub(/<a .*?>(.*?)<\/a>/m) {|s| " [#{$1}] " unless $1.blank?}
    text = text.gsub(/<\/?b>/, "\*")
    text = text.gsub(/<\/?big>/, "\*")
    text = text.gsub(/<\/?blockquote>/, "")
    text = text.gsub(/<br \/>/, "\n")
    text = text.gsub(/<\/?center>/, "")
    text = text.gsub(/<\/?div.*?>/, "\n")
    text = text.gsub(/<dt>/, "")
    text = text.gsub(/<\/dt>/, ": ")
    text = text.gsub(/<\/?em.*?>/, "_")
    text = text.gsub(/<\/?i>/, "_")
    text = text.gsub(/<h1>(.*?)<\/h1>/) {|s| "\# #{$1} \#" unless $1.blank?}
    text = text.gsub(/<h2>(.*?)<\/h2>/) {|s| "\#\# #{$1} \#\#" unless $1.blank?}
    text = text.gsub(/<\/?h\d.*?>/, "\*")
    text = text.gsub(/<hr \/>/, "______________________________\n")
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
    text = text.gsub(/<br \/>/, "\n")
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

  private
  
    def self.remove_surrounding(nodeset)
      return nodeset unless nodeset.is_a? Nokogiri::XML::NodeSet
      if nodeset.size == 1 && nodeset.first.is_a?(Nokogiri::XML::Element)
        return Scrub.remove_surrounding(nodeset.children)
      end
      nodeset
    end
  
    def self.remove_blanks(nodeset)
      nodeset.each do |top_node|
        nodeset.delete(top_node) if (top_node.is_a?(Nokogiri::XML::Text) && top_node.blank?)
      end
      nodeset
    end

    def self.remove_scripts(body)
      body.traverse do |node|
        case node.name
          when 'script'
            node.children.each{|child| child.remove}
            node.remove
        end
      end
      body
    end

end
