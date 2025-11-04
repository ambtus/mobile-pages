# frozen_string_literal: true

Then('I should see a horizontal rule') do
  assert page.html.include?('<hr')
end

Then('I should see two horizontal rules') do
  assert(/<hr.*<hr/.match(page.html.squish))
end

Then('I should see three horizontal rules') do
  assert(/<hr.*<hr.*<hr/.match(page.html.squish))
end

Then('I should NOT see a horizontal rule') do
  assert page.html.exclude?('<hr')
end

Then('I should NOT see two horizontal rules') do
  assert !/<hr.*<hr/.match(page.html.squish)
end

Then('I should NOT see three horizontal rules') do
  assert !/<hr.*<hr.*<hr/.match(page.html.squish)
end

Then('I should NOT see four horizontal rules') do
  assert !/<hr.*<hr.*<hr.*<hr/.match(page.html.squish)
end

Then('last read should be today') do
  Rails.logger.debug { "comparing #{Page.first.last_read.to_date} with #{Date.current}" }
  assert_equal Date.current, Page.first.last_read.to_date
end

Then('last read should be {string}') do |date|
  Rails.logger.debug { "comparing #{Page.first.last_read.to_date} with #{date.to_date}" }
  assert_equal date.to_date, Page.first.last_read.to_date
end

Then('the read after date should be {string}') do |string|
  Rails.logger.debug { "comparing #{Page.first.read_after} with #{string}" }
  assert_equal string, Page.first.read_after.to_date.to_s
end

Then('the read after date should be {int} year(s) from now') do |int|
  diff = Page.first.read_after.year - Time.zone.today.year
  Rails.logger.debug { "comparing #{Page.first.read_after.year} with #{Time.zone.today.year} (#{diff})" }
  assert_equal int, diff
end
