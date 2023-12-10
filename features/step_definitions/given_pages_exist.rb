Given('Death on the Nile exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://en.wikipedia.org/wiki/Death_on_the_Nile")
  page.set_raw_from("death")
end

Given('Death in the Clouds exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://en.wikipedia.org/wiki/Death_in_the_Clouds")
  page.set_raw_from('clouds')
end

Given('Dumb Witness exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://en.wikipedia.org/wiki/Dumb_Witness")
  page.set_raw_from('dumb')
end

Given('Murder in the Mews exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://en.wikipedia.org/wiki/Murder_in_the_Mews")
  page.set_raw_from('mews')
end
Given('Early Cases exists') do
  page = Single.create!(title: "temp")
  page.update!(url: "https://en.wikipedia.org/wiki/Poirot's_Early_Cases")
  page.set_raw_from('early')
end

Given('Announced exists') do
  page = Page.create!(title: "temp")
  page.update!(url: "https://en.wikipedia.org/wiki/A_Murder_Is_Announced")
  page.set_raw_from('announced')
  page.update!(type: 'Page')
end


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

Given('part {int} exists') do |int|
  chapter = Chapter.create!(title: "part#{int}")
  chapter.update!(url: "http://www.matthewhaldemantime.com/InThisLand/inthisland#{int}.html")
  chapter.set_raw_from("inthisland#{int}")
end
