# frozen_string_literal: true

# Givens are data preparation and prerequisite operations.

Given("the page's directory is missing") do
  FileUtils.rm_rf(Page.first.mydirectory)
end

Given('{string} is a(n) {string}') do |name, type|
  Rails.logger.debug { "creating #{type} with name #{name}" }
  Tag.find_or_create_by!(name: name, type: type)
end
