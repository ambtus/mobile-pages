# coding: utf-8

module Scrub

  def self.agent
    @agent ||= Mechanize.new { |a|
      a.log = Logger.new("#{Rails.root}/log/mechanize.log")
      a.open_timeout = 10
      a.read_timeout = 10
    }
  end

  # regularize imported html to fix garbled encodings
  #    clean up whitespace and remove javascript
  #    returns what's inside the <body> elements
  #    to be saved as raw_html (raw == pre-sanitized)
  #    called before saving to raw_html file, and nowhere else
  def self.regularize_body(html)
    begin
      return html if html.blank?
    rescue ArgumentError
      html = html.encode("UTF-8", "windows-1252")
    end
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
                   [ ' ', ' '],
                   [ '<o:p>', '<p>' ],
                   [ '</o:p>', '</p>' ],
                   ]
    begin
      replacements.each do |replace|
        html = html.gsub(replace.first, replace.last)
      end
    rescue Encoding::CompatibilityError
      d = CharlockHolmes::EncodingDetector.detect(html)
      html = html.encode("UTF-8", d[:encoding], invalid: :replace, replace: "•")
      replacements.each do |replace|
        html = html.gsub(replace.first, replace.last)
      end
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

  def self.strip_html(html);  Sanitize.fragment(html, elements: 'hr').strip.gsub(/ *<hr> */, "; "); end

  def self.sanitize_and_strip(html); strip_html(sanitize_html(html)); end

  def self.remove_extra_formatting(html)
    Sanitize.clean(
      html,
      :elements => [ 'a', 'b', 'big', 'blockquote', 'br', 'center',
                     'div', 'dt', 'em', 'i', 'h1', 'h2', 'h3', 'h4',
                     'h5', 'h6', 'hr', 'img', 'li', 'p', 'small',
                     'strike', 'strong', 'sub', 'sup', 'u'],
      :attributes => { 'a' => ['href'],
                       'img' => ['align', 'alt', 'height', 'src', 'title', 'width'] })
  end

  # sanitize
  def self.sanitize_html(html)
    return "" if html.blank?
    html = Scrub.remove_extra_formatting(html)
    # remove empty divs
    html.gsub!(/<div>\s*<\/div>/, "")
    html = Scrub.remove_surrounding(html)

    # remove anchor links
    html.gsub!(/<a><\/a>/, "")
    # alright drives me batty
    html.gsub!(/([Aa])lright/) {|s| $1 + "ll right"}
    # charka => chakra
    html.gsub!(/([Cc])harka/) {|s| $1 + "hakra"}
    # chocked => choked
    html.gsub!(/([Cc])hocked/) {|s| $1 + "hocked"}
    # remove back_to_back bold and italic
    html.gsub!(/<\/b>([_., -]*)<b>/) {|s| $1}
    html.gsub!(/<\/i>([_., -]*)<i>/) {|s| $1}
    # remove empty bold and italic and underline
    html.gsub!(/<u><\/u>/) {|s| $1}
    html.gsub!(/<i><\/i>/) {|s| $1}
    html.gsub!(/<b><\/b>/) {|s| $1}
    # fix weird quotes being used for curly quotes
    html.gsub!('`', '‘')
    html.gsub!('´', '’')

    # extra breaks inside paragraphs
    html.gsub!(/<p><br ?\/?>/, "<p>")
    html.gsub!(/<br ?\/?><\/p>/, "</p>")
    # extra breaks inside divs
    html.gsub!(/<div><br ?\/?>/, "<div>")
    html.gsub!(/<br ?\/?><\/div>/, "</div>")
    # more than two breaks are probably a section
    html.gsub!(/(<br ?\/?>){3,}/, '<hr>')
    # when sections are taken care of, multiple breaks are a paragraph
    html.gsub!(/(<br ?\/?>?){2,}/, '<p>')

    # a few left-over empty paragraphs are probably a section
    # but too many are just extraneous whitespace
    total_paragraphs = html.scan(/<p>/).count
    empty_paragraphs = html.scan(/<p>\s*<\/p>/).count
    if empty_paragraphs > 0  && total_paragraphs/empty_paragraphs > 5
      html.gsub!(/<p>\s*<\/p>/, '<hr>')
    else
      html.gsub!(/<p>\s*<\/p>/, '')
    end

    # common section designation
    html.gsub!(/_{5,}/, '<hr>')
    # less common section designation
    html.gsub!(/~{10,}/, '<hr>')
    html.gsub!(/\*{10,}/, '<hr>')
    # remove stray paragraphs around sections
    html.gsub!(/<p>\s*<hr>/, '<hr>')
    html.gsub!(/<hr>\s*<\/p>/, '<hr>')
    # remove stray divs around sections
    html.gsub!(/<div>\s*<hr ?\/?>/, '<hr>')
    html.gsub!(/<hr ?\/?>\s*<\/div>/, '<hr>')

    # condense multiple sections
    html.gsub!(/(\s*<hr ?\/?>\s*){2,}/, '<hr>')
    # remove beginning section
    html.gsub!(/^<hr ?\/?>/, '')
    # remove end section
    html.gsub!(/<hr ?\/?>$/, '')

    # style sections
    html.gsub!(/<hr>/, '<hr width="80%"/>')

    Scrub.remove_surrounding(html)
  end

  def self.remove_surrounding(html)
    if html.is_a?(String) && !html.empty?
      doc = Nokogiri::HTML(html)
      body = doc.xpath('//body').first
      nodeset = body.children
      while nodeset.size == 1 && nodeset.first.is_a?(Nokogiri::XML::Element)
        break if nodeset.first.children.blank?
        nodeset = nodeset.first.children
        nodeset.each do |top_node|
          nodeset.delete(top_node) if (top_node.is_a?(Nokogiri::XML::Text) && top_node.blank?)
        end
      end
      nodeset.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
    else
     ""
    end
  end


  def self.fetch_html(url)
    raise if url.blank?
    auth = MyWebsites.getpwd(url)
    Scrub.agent.add_auth(url, auth[:username], auth[:password]) if auth
    if url.match("archiveofourown.org")
       Rails.logger.debug "ao3 fetch #{url}"
       content = Scrub.agent.get(url)
       if Scrub.agent.page.uri.to_s == "https://archiveofourown.org/"
         Rails.logger.debug "ao3 redirected back to homepage"
         raise
       end
       unless content.links.third.text.match(auth[:username])
         Rails.logger.debug "ao3 sign in"
         content = Scrub.agent.get("https://archiveofourown.org/users/login?restricted=true")
         form = content.forms.first
         username_field = form.field_with(:name => 'user[login]')
         username_field.value = auth[:username]
         password_field = form.field_with(:name => 'user[password]')
         password_field.value = auth[:password]
         content = Scrub.agent.submit(form, form.buttons.first)
         content = Scrub.agent.get(url)
        end
    else
      content = Scrub.agent.get(Websites.geturl(url))
      if content.forms.first.try(:button).try(:name) == "adult_check"
         Rails.logger.debug "adult check"
         form = content.forms.first
         content = Scrub.agent.submit(form, form.buttons.first)
      end
    end
    return content.body.force_encoding(Scrub.agent.page.encoding)
  end

  def self.get_ao3_works_from_list(work_list, parent=Page.new)
    works = []
    work_list.each_with_index do |work_id, index|
      count = index + 1
      url = "https://archiveofourown.org/works/#{work_id}"
      work = Page.find_by_url(url)
      if work.nil?
        #do its chapters exist?
        possibles = Page.where("url LIKE ?", url + "/chapters/%")
      end
      if possibles
        possibles.each do |p|
          if p.parent && p.parent == parent
           Rails.logger.debug "selecting from my first level possibles #{p.title}"
           work = p
           break
          elsif p.parent && p.parent.parent.nil?
           Rails.logger.debug "selecting from unclaimed first level possibles #{p.parent.title}"
           work = p.parent
           break
          elsif p.parent && p.parent && p.parent.parent == parent
            Rails.logger.debug "selecting from my second level possibles #{p.parent.title}"
            work = p.parent
            break
          elsif p.parent && p.parent.parent && p.parent.parent.parent.nil?
            Rails.logger.debug "selecting from unclaimed second level possibles #{p.parent.parent.title}"
            work = p.parent.parent
            break
          end
        end
      end
      if work
        if work.position == count && work.parent_id == parent.id
          Rails.logger.debug "work already exists, skipping #{work.title} in position #{count}"
        elsif parent.id
          Rails.logger.debug "work already exists, updating #{work.title} with position #{count} and parent_id #{parent.id}"
          work.update!(position: count, parent_id: parent.id)
        else
          Rails.logger.debug "work already exists, skipping #{work.title}"
        end
      elsif parent.id
        Rails.logger.debug "work does not yet exist, creating ao3/works/#{work_id} in position #{count} and parent_id #{parent.id}"
        work = Book.create!(:url => url, :position => count, :parent_id => parent.id, :title => "temp").set_wordcount
        sleep 5 unless count == work_list.size
        works << work
      else
        Rails.logger.debug "work does not yet exist, creating ao3/works/#{work_id}"
        work = Book.create!(:url => url, :title => "temp").set_wordcount
        sleep 5 unless count == work_list.size
        works << work
      end
    end
    return works
  end

end
