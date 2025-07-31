# frozen_string_literal: true

Given('Urgency exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/fiction/the-resolute-urgency-of-now-time-travel-trope-bingo-2020-2021/')
  page.set_raw_from('urgency')
end

Given('Time exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/fiction/time-after-time/')
  page.set_raw_from('time')
end

Given('Wish exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/fiction/bingo/i-wish-amnesia-trope-bingo-2020-2021/')
  page.set_raw_from('wish')
end

Given('Secret exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/fiction/the-secret-to-survivin/')
  page.set_raw_from('secret')
end

Given('Crazy exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/fiction/crazy-little-thing/')
  page.set_raw_from('crazy')
end

Given('Something exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/fiction/something-in-my-liberty/')
  page.set_raw_from('something')
end

Given('Art exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/fiction/almost-paradise-art-by-fashi0n/')
  page.set_raw_from('art')
end

Given('Black exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/fiction/black-moon-rising/')
  page.set_raw_from('black')
end

Given('Arm exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/fiction/arm-candy/')
  page.set_raw_from('arm')
end

Given('Serendipity exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/evil-author-day/serendipity-ead-2022/')
  page.set_raw_from('ead')
end

Given('Teen exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/evil-author-day/teen-wolf-meets-the-changeover-ead-2018/')
  page.set_raw_from('teen')
end

Given('Specious exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/fiction/bingo/specious-marriage-of-convenience-trope-bingo-2020-2021/')
  page.set_raw_from('specious')
end

Given('Unreality exists') do
  page = Single.create!(title: 'temp')
  page.update!(url: 'http://clairesnook.com/evil-author-day/unreality-ead-2021/')
  page.set_raw_from('unreality')
end
