# Restart required even in development mode when you modify this file.

# A list of all the methods defined here to prevent breaking rails by overwriting something in use
%w{chip strip_quotes with_quotes create_hash normalize boring? split_comma squash clean}.each do |meth|
 raise "#{meth} is already defined in String class" if String.method_defined?(meth)
end

class String

  def chip; self[1..-1]; end

  def strip_quotes; self.chip.chop; end ##TODO raise errors if not quoted

  def with_quotes; '"' + self + '"'; end

  def create_hash(on1 = ' AND ', on2 = ': ', extra = false, pre = "")
    array = self.split(on1).pulverize.without("")
    hash = {}

    array.each do |pair|
      key_value = pair.split(on2)
      if key_value[0].is_a?(String) && key_value[1].is_a?(String)
        key = key_value[0]
        key = key.gsub(pre, "") unless pre.blank?
        key = key.to_sym
        value = key_value[1].strip_quotes
        value = value.chop if extra
        hash[key] = value
      end
    end

    return hash
  end

  def normalize
    url = URI.extract(self, URI.scheme_list.keys.map(&:downcase)).first.to_s
    url = url.sub(/^http:/, 'https:') if url.match("^http://archiveofourown.org/")
    url = url.chop if url.match("^https://archiveofourown.org/") && url.match("/$")
    url = url.sub(/#workskin$/, '')
    url
  end

  #TODO there must be a better way to do this
  def boring?
    %w{Part Chapter temp Title Page}.each do |boring|
      return true if boring == self
      return true if boring == self.match(/^\d+\. (.*) \d+$/)[1] rescue nil
      return true if boring == self.match(/^(.*) \d+$/)[1] rescue nil
    end
    return false
  end

  def split_comma; self.split(",").map(&:squish); end

  def squash; self.gsub(/\s/, ''); end
  def clean; self.delete('^a-zA-Z0-9'); end

end
