# frozen_string_literal: true

def note_field(string)
  case string
  when 'page'
    :notes
  when 'end'
    :end_notes
  when 'reader'
    :my_notes
  end
end

def very_long_note
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam sagittis in erat ac maximus. Etiam consectetur turpis duis.'
end

def truncated_short_note
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet…'
end

def truncated_medium_note
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam sagittis in erat ac…'
end

def html_note
  "<p>This.</p><p>is not.</p><p>actually.<p>a very long.</p><p>note<hr />(once you take out the <a href='http://some.domain.com'>html</a>)<br /></p>"
end

def tilde_note
  '<p>Sorry it took so long, I suck at romantic stuff.<br />~~~~~~~~~~~~~~~~~~~~~~~</p><p>Cheers!</p>'
end

def fixed_tilde_note
  '<p>Sorry it took so long, I suck at romantic stuff.<br /></p><hr width="80%" /><p>Cheers!</p>'
end
