# TODO: YOU SHOULD DELETE THIS FILE

# If you use these step definitions as basis for your features you will quickly end up
# with features that are:
#
# * Hard to maintain
# * Verbose to read
#
# A much better approach is to write your own higher level step definitions, following
# the advice in the following blog posts:
#
# * https://web.archive.org/web/20161226001629/http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
# * http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/
# * http://www.varvet.com/blog/you-re-cuking-it-wrong

require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

# When("I go back") do
#   case Capybara::current_driver
#   when :selenium, :webkit
#     page.execute_script('window.history.back()')
#   else
#     if page.driver.respond_to?(:browser)
#       visit page.driver.browser.last_request.env['HTTP_REFERER']
#     else
#       visit page.driver.last_request.env['HTTP_REFERER']
#     end
#   end
# end
