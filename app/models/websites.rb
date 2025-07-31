# frozen_string_literal: true

module Websites
  def self.geturl(url)
    case url
    when /ejournal/, /dreamwidth/
      if url.match?('#comments')
        url.gsub('#comments', '?format=light#comments')
      else
        "#{url}?format=light"
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

    result = case url
             when /insanejournal/, /dreamwidth/
               if url.match?('thread|comments')
                 body.children
               elsif body.at('//blockquote')
                 body.at('//blockquote').next
               else
                 body.children
               end
             when /livejournal/
               if url.match?('thread|comments')
                 body.children
               elsif body.at('//blockquote')
                 body.at('//blockquote').next
               else
                 body.at('article.b-singlepost-body').children
               end
             when /fanfiction.net/
               body.at('div#storytext')
             when /totse2.com/
               body.at('div.disclaim')&.remove
               body.at('table[2]/tr/td/table/tr/td[2]/table/tr[4]/td[2]')
             when /archiveofourown/
               body.search('.landmark').each(&:remove)
               if url.include?('chapter')
                 body.at_xpath("//div[@class = 'userstuff module']")
               else
                 body.at_xpath("//div[@id = 'chapters']")
               end
             when /wraithbait/
               body.at('div.infobox')&.remove
               body.search('div.toplink').each(&:remove)
               body.search('div.chaptertitle').each do |node|
                 node.name = 'h2'
                 node.inner_html = node.inner_text.gsub(' by', '')
               end
               body.at('div#copyright')&.remove
               body.children
             when /grazhir.com/
               body.at('div#content')
             when /wikipedia/
               header = body.at('div#siteSub').to_html
               html = html.match(header).post_match
               first_try = body.at('span#Adaptations')
               if first_try.blank?
                 footer = 'Film, TV or theatrical adaptations'
                 footer = 'Film, television or theatrical adaptations' if html.match(footer).blank?
               else
                 footer = first_try.to_html
               end
               html = html.match(footer).pre_match if footer && html.match(footer)
               Nokogiri::HTML(html).xpath('//body').first
             when /matthewhaldemantime/
               continued_from = body.at('a')
               if continued_from.text.match?('Continued from')
                 header = continued_from.to_html
                 html = html.match(header).post_match
               end
               others = body.search('a')
               10.times do |i|
                 continue_to = others[i + 1]
                 next unless continue_to.text.match?('Continue on')

                 footer = continue_to.to_html
                 html = html.match(footer).pre_match
                 break
               end
               body = Nokogiri::HTML(html).xpath('//body').first
               ps = body.search('p')
               [0, 1, -1, -2].each do |i|
                 ps[i].remove if ps[i] && ps[i].text.blank?
               end
               spans = body.search('span')
               [0, 1, -1, -2, -3].each do |i|
                 spans[i].remove if spans[i] && spans[i].text.blank?
               end
               body
             when /clairesnook.com/, /keiramarcos.com/
               if body.at('div.tab-pane')
                 body.at('div.tab-pane')
               else
                 ps = body.css('div.entry-content p')
                 3.times do |i|
                   next unless ps[i]

                   ps[i].remove if Scrub.strip_html(ps[i]) == '' || ps[i].to_html.include?('<strong>')
                 end
                 divs = body.at('div.entry-content').children
                 divs[-1].remove if Scrub.strip_html(divs[-1]) == ''
                 divs[-2].remove if divs[-2].to_html.include?('Like this')
                 divs[-3].remove if divs[-3].to_html.include?('Share this')
                 body.at('div.entry-content')
               end
             else
               body.children
             end
    return html if result.blank?

    Scrub.remove_surrounding(result.to_xhtml)
  end
end
