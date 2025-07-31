# frozen_string_literal: true

# Restart required even in development mode when you modify this file.

%w[join_hr join_comma pulverize mode].each do |meth|
  raise "#{meth} is already defined in Array class" if Array.method_defined? meth
end

class Array
  def join_hr = compact_blank.join('<hr width="80%"/>')

  def join_comma = compact_blank.join(', ')

  def pulverize = flatten.compact_blank.uniq

  def to_p = join_comma.blank? ? nil : "<p>#{join_comma}</p>"

  def mode
    return first if size == 1
    return nil if size.zero?

    histogram = each_with_object(Hash.new(0)) do |n, h|
      h[n] += 1
    end
    largest = histogram.values.max
    not_found = largest == 1 || histogram.values.count(largest) > 1
    not_found ? nil : histogram.invert[largest]
  end
end
