# frozen_string_literal: true

Given('The Prepared Mind exists') do
  series = create_local_page 'pm', 'http://clairesnook.com/fiction/the-prepared-mind/'

  work1 = create_local_page 'pm1', 'http://clairesnook.com/fiction/dice-in-the-mirror-free-enoughs-enough-trope-bingo-2020-2021/'
  work2 = create_local_page 'crazy', 'http://clairesnook.com/fiction/crazy-little-thing/'

  series.add_part(work1.url)
  series.add_part(work2.url)

  series.rebuild_meta
end

Given('Earthbound Misfit exists') do
  book = create_local_page 'em', 'http://clairesnook.com/fiction/earthbound-misfit/'
  chapter1 = create_local_page 'em1', 'http://clairesnook.com/fiction/earthbound-misfit-chapter-one-to-chapter-seven/'
  chapter2 = create_local_page 'em2', 'http://clairesnook.com/fiction/earthbound-misfit-chapter-eight-to-chapter-fourteen/'
  book.add_chapter(chapter1.url)
  book.add_chapter(chapter2.url)

  book.update_from_parts
  book.rebuild_meta
end

Given('Almost Paradise exists') do
  book = create_local_page 'ap', 'http://clairesnook.com/fiction/almost-paradise/'

  chapter1 = create_local_page 'ap1', 'http://clairesnook.com/fiction/almost-paradise-chapter-one-to-four/'

  chapter2 = create_local_page 'art', 'http://clairesnook.com/fiction/almost-paradise-art-by-fashi0n/'
  book.add_chapter(chapter1.url)
  book.add_chapter(chapter2.url)

  book.update_from_parts
  book.rebuild_meta
end

Given('Shadowwings exists') do
  series = create_local_page 'sw', 'http://clairesnook.com/fiction/shadowwings/'

  work1 = create_local_page 'swg', 'http://clairesnook.com/fiction/shadowwings-genesis/'

  work2 = create_local_page 'swr', 'http://clairesnook.com/evil-author-day/revelations-ead-2021/'

  series.add_part(work1.url)
  series.add_part(work2.url)

  series.update_from_parts
  series.rebuild_meta
end

Given('If Heaven Falls exists') do
  create_local_page 'ihf', 'http://clairesnook.com/fiction/if-heaven-falls/'
end
