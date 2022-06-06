module Websites

  def self.geturl(url)
    case url
    when /ejournal/, /dreamwidth/
      if url.match("#comments")
        url.gsub("#comments", "?format=light#comments")
      else
        url + "?format=light"
      end
    else url
    end
  end

  # expects an html string
  def self.getnode(html, url)
    return nil unless html.is_a? String
    doc = Nokogiri::HTML(html)
    body = doc.xpath('//body').first
    return html if body.blank?
    result= case url
            when /insanejournal/, /dreamwidth/
              if url.match("thread|comments")
                body.children
              elsif body.at('//blockquote')
                body.at('//blockquote').next
              else
                body.children
              end
            when /livejournal/
              if url.match("thread|comments")
                body.children
              elsif body.at('//blockquote')
                body.at('//blockquote').next
              else
                body.at('article.b-singlepost-body').children
              end
            when /fanfiction.net/
              body.at('div#storytext')
            when /totse2.com/
              body.at('div.disclaim').remove if body.at('div.disclaim')
              body.at("table[2]/tr/td/table/tr/td[2]/table/tr[4]/td[2]")
            when /archiveofourown/
              body.search(".landmark").each { |node| node.remove }
              if url.match(/chapter/)
                body.at_xpath("//div[@class = 'userstuff module']")
              else
                body.at_xpath("//div[@id = 'chapters']")
              end
            when /wraithbait/
              body.at('div.infobox').remove if body.at('div.infobox')
              body.search("div.toplink").each { |node| node.remove }
              body.search("div.chaptertitle").each do |node|
                node.name = 'h2'
                node.inner_html = node.inner_text.gsub(" by", '')
              end
              body.at('div#copyright').remove if body.at('div#copyright')
              body.children
            when /grazhir.com/
              body.at('div#content')
            when /clairesnook.com/
              if body.at('div.tab-pane')
                body.at('div.tab-pane')
              else
                ps = body.css('div.entry-content p')
                3.times do |i|
                  next unless ps[i]
                  ps[i].remove if Scrub.strip_html(ps[i]) == "" || ps[i].to_html.match(/<strong>/)
                end
                divs = body.at('div.entry-content').children
                divs[-1].remove if Scrub.strip_html(divs[-1]) == ""
                divs[-2].remove if divs[-2].to_html.match(/Like this/)
                divs[-3].remove if divs[-3].to_html.match(/Share this/)
                body.at('div.entry-content')
              end
            else
              body.children
            end
    return html if result.blank?
    result.to_xhtml(:indent_text => '', :indent => 0).gsub("\n",'')
  end

end

