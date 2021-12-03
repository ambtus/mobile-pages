# Restart required even in development mode when you modify this file.

%w{join_hr join_comma pulverize mode}.each do |meth|
 raise "#{meth} is already defined in Array class" if Array.method_defined? meth
end

class Array

  def join_hr; reject(&:blank?).join('<hr width="80%"/>'); end

  def join_comma; reject(&:blank?).join(", "); end

  def pulverize; flatten.reject(&:blank?).uniq; end

  def mode
    return first if size == 1
    return nil if size == 0
    histogram = self.inject(Hash.new(0)) { |h, n| h[n] += 1; h }
    largest = histogram.values.sort.reverse.first
    not_found = largest == 1 || histogram.values.count(largest) > 1
    not_found ? nil : histogram.invert[largest]
  end
end
