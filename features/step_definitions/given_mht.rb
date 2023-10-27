Given('part {int} exists') do |int|
  chapter = Chapter.create!(title: "part#{int}")
  chapter.update!(url: "http://www.matthewhaldemantime.com/InThisLand/inthisland#{int}.html")
  chapter.set_raw_from("inthisland#{int}")
end
