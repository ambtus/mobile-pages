# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'cucumber/rails'
DatabaseCleaner.strategy = :transaction

Capybara.configure do |config|
  config.match = :prefer_exact
end

require 'zip'
