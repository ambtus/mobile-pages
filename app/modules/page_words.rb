# frozen_string_literal: true

module PageWords
  SIZES = %w[drabble short medium long epic].freeze

  DRABBLE_MAX = 300
  SHORT_MAX = 3_000
  MED_MAX   = 30_000
  LONG_MAX = 300_000

  def new_wordcount(recount = true)
    if parts.size.positive?
      Rails.logger.debug { "getting wordcount for #{title} from parts" }
      parts.each(&:set_wordcount) if recount
      parts.sum(:wordcount)
    elsif recount && has_content?
      Rails.logger.debug { "getting wordcount for #{title} by recounting" }
      body = Nokogiri::HTML(edited_html).xpath('//body').first
      if body.blank?
        0
      else
        count = 0
        body.traverse do |node|
          if node.is_a? Nokogiri::XML::Text
            words = node.inner_text.gsub('--', '—').gsub(/(['’‘-])+/, '')
            count += words.scan(/[a-zA-Z0-9À-ÿ_]+/).size
          end
        end
        if count.zero?
          Rails.logger.debug { "setting wordcount for #{title} to -1 because body but no text implies image only" }
          -1
        else
          count
        end
      end
    else
      Rails.logger.debug { "getting wordcount for #{title} from previous count" }
      wordcount || 0
    end
  end

  def set_wordcount(recount = true)
    # Rails.logger.debug "#{self.title} old wordcount: #{self.wordcount} and size: #{self.size}"
    newwc = new_wordcount(recount)
    size_word = 'drabble'
    if newwc
      size_word = 'short' if newwc > DRABBLE_MAX
      size_word = 'medium' if newwc > SHORT_MAX
      size_word = 'long' if newwc > MED_MAX
      size_word = 'epic' if newwc > LONG_MAX
    end
    Rails.logger.debug { "#{title} new wordcount: #{newwc} and size: #{size_word}" }
    update! wordcount: newwc, size: size_word
    self
  end
end
