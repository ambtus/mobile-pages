# frozen_string_literal: true

Then('{string} should be hidden') do |string|
  assert Page.find_by(title: string).hidden?
end

Then('{string} should be conned') do |string|
  assert Page.find_by(title: string).con?
end

Then('{string} should be proed') do |string|
  assert Page.find_by(title: string).pro?
end

Then('the page should NOT be proed') do
  assert !Page.first.pro?
end
