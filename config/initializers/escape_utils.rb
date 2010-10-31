# fix UTF-8 error messages in cucumber tests
# also speed up html escaping
# See http://openhood.com/rack/ruby/2010/07/15/rack-test-warning/
# and also http://github.com/brianmario/escape_utils
require "escape_utils/html/rack"

# don't escape views - it creates hideous html
#require "escape_utils/html/erb"
#require 'escape_utils/html/haml

module Rack
  module Utils
    def escape(s)
      EscapeUtils.escape_url(s)
    end
  end
end
