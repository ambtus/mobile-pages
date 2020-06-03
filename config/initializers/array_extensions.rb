# Restart required even in development mode when you modify this file.

%w{join_hr join_comma pulverize}.each do |meth|
 raise "#{meth} is already defined in Array class" if Array.method_defined? meth
end

class Array

  def join_hr; reject(&:blank?).join('<hr width="80%"/>'); end

  def join_comma; reject(&:blank?).join(", "); end

  def pulverize; flatten.reject(&:blank?).uniq; end

end
