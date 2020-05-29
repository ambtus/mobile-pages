# Restart required even in development mode when you modify this file.

%w{join_hr join_comma}.each do |meth|
 raise "#{meth} is already defined in Array class" if Array.method_defined? meth
end

class Array

  def join_hr; reject(&:blank?).join("<hr>"); end

  def join_comma; reject(&:blank?).join(", "); end

end
