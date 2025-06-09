source 'http://rubygems.org'

gem 'bundler'

gem 'rails', '~> 7.0.5'
gem 'concurrent-ruby', '1.3.4' # until rails 7.1 https://www.devgem.io/posts/resolving-the-loggerthreadsafelevel-error-in-rails-after-bundle-update
gem 'nokogiri'
gem 'mysql2'

gem 'unicorn', group: :production

group :development do
  gem 'quiet_safari'
  gem 'thin'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails', '~> 2.5.1', :require => false
  gem 'cucumber'
  gem 'launchy'    # So you can do Then show me the page
  gem 'test-unit'
  gem 'rubyzip'  # So you can inspect epub files
end

gem 'escape_utils'
gem 'haml'

gem 'rubypants'
gem 'sanitize'
gem 'mechanize', ">= 2.7.7"

gem 'charlock_holmes'

# https://github.com/ruby/net-imap/issues/16#issuecomment-803086765
gem "net-http"
