# frozen_string_literal: true

## Thens are for verifications and assertions

## I should see ##

Then('I should NOT see {string} before {string} within {string}') do |string1, string2, parent|
  text = Regexp.new(string1 + '
' + string2)
  within(parent) { assert_no_text(text) }
end

## I should have ##

Then('I should have no authors') do
  assert_equal 0, Author.count
end

Then('I should have {int} tag(s)') do |int|
  Rails.logger.debug { "curent tags: #{Tag.all.map(&:name)}" }
  assert_equal int, Tag.count
end

## It should

Then('the {string} field should NOT contain {string}') do |field, text|
  assert !page.has_field?(field, with: text)
end

## selections and check
