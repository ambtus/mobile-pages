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
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam.'
end

def truncated_note
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet…'
end
