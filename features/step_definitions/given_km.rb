Given('The Awakening exists') do
  book = Book.create!(title: "temp")
  book.update!(url: "https://keiramarcos.com/fan-fiction/the-awakening/")
  book.set_raw_from("ta")

  chapter1 = Chapter.create!(title: "temp", parent_id: book.id, position: 1)
  chapter1.update!(url: "https://keiramarcos.com/2009/03/the-awakening-part-one-five/")
  chapter1.set_raw_from("ta1")

  chapter2 = Chapter.create!(title: "temp", parent_id: book.id, position: 2)
  chapter2.update!(url: "https://keiramarcos.com/2009/03/the-awakening-part-six-ten/")
  chapter2.set_raw_from("ta2")

  book.rebuild_meta.set_wordcount(false)
end
