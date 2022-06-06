Given('The Prepared Mind exists') do
  series = Series.create!(title: "temp")
  series.update!(url: "http://clairesnook.com/fiction/the-prepared-mind/")
  series.set_raw_from("pm")

  work1 = Single.create!(title: "temp", parent_id: series.id, position: 1)
  work1.update!(url: "http://clairesnook.com/fiction/dice-in-the-mirror-free-enoughs-enough-trope-bingo-2020-2021/")
  work1.set_raw_from("pm1")

  work2 = Single.create!(title: "temp", parent_id: series.id, position: 2)
  work2.update!(url: "http://clairesnook.com/fiction/crazy-little-thing/")
  work2.set_raw_from("crazy")

  series.rebuild_meta
end

Given('Earthbound Misfit exists') do
  book = Book.create!(title: "temp")
  book.update!(url: "http://clairesnook.com/fiction/earthbound-misfit/")
  book.set_raw_from("em")

  chapter1 = Chapter.create!(title: "temp", parent_id: book.id, position: 1)
  chapter1.update!(url: "http://clairesnook.com/fiction/earthbound-misfit-chapter-one-to-chapter-seven/")
  chapter1.set_raw_from("em1")

  chapter2 = Chapter.create!(title: "temp", parent_id: book.id, position: 2)
  chapter2.update!(url: "http://clairesnook.com/fiction/earthbound-misfit-chapter-eight-to-chapter-fourteen/")
  chapter2.set_raw_from("em2")

  book.rebuild_meta.set_wordcount(false)
end

