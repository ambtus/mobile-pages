# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'cucumber/rails'
DatabaseCleaner.strategy = :transaction

Capybara.configure do |config|
  config.match = :prefer_exact
end

require 'zip'
Rails.root.glob('test_helpers/helper_files/*.rb').each { |f| require f }
PageDownload
