Then('the page should be hidden') do
  assert Page.first.hidden?
end

Then('{string} should be hidden') do |string|
  assert Page.find_by_title(string).hidden?
end

Then('the page should NOT be hidden') do
  assert !Page.first.hidden?
end

Then('the page should be conned') do
  assert Page.first.con?
end

Then('{string} should be conned') do |string|
  assert Page.find_by_title(string).con?
end

Then('the page should NOT be conned') do
  assert !Page.first.con?
end

Then('{string} should be proed') do |string|
  assert Page.find_by_title(string).pro?
end

Then('the page should NOT be proed') do
  assert !Page.first.pro?
end
