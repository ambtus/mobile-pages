# frozen_string_literal: true

Capybara.configure do |config|
  config.match = :prefer_exact
end

require 'zip'
