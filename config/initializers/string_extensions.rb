# Restart required even in development mode when you modify this file.

# A list of all the methods defined here to prevent breaking rails by overwriting something in use
%w{chip strip_quotes create_hash}.each do |meth|
 raise "#{meth} is already defined in String class" if String.method_defined?(meth)
end

class String

  def chip; self[1..-1]; end

  def strip_quotes; self.chip.chop; end

  def create_hash
    array = self.split(' AND ')
    hash = {}

    array.each do |pair|
      key_value = pair.split(': ')
      hash[key_value[0].to_sym] = key_value[1].strip_quotes
    end

    return hash
  end

end
