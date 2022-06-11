source 'http://rubygems.org'

gem 'bundler'

gem 'rails'
gem 'nokogiri'
gem 'mysql2'

gem 'unicorn', group: :production

gem 'logging'
gem 'logging-rails'

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


# https://github.com/ruby/net-imap/issues/16#issuecomment-803086765
gem "net-http"
