Then('the page should be hidden') do
  assert Page.first.hidden?
end
Then('{string} should be hidden') do |string|
  assert Page.find_by_title(string).hidden?
end

Then('the page should NOT be hidden') do
  assert !Page.first.hidden?
end
