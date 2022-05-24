Feature: links in downloads

Scenario: link to page in downloaded html
  Given a page exists
  When I read it online
  Then "Page 1" should link to itself

Scenario: links to images should be https
  Given The Picture exists
  When I am on the homepage
    And I follow "ePub" within "#position_1"
  Then the epub html contents for "The Picture" should contain "Ki1qR8E.png"

Scenario: second links to images should be https
  Given Prologue exists
  When I am on the homepage
    And I follow "ePub" within "#position_1"
  Then the epub html contents for "Prologue: After the World Burns" should contain "coverhigh.jpg"

Scenario: regular hrefs should still be http
  Given a page exists
  When I change its raw html to 'This is a <a href="http://test.sidrasue.com/parts/1.html">test</a>!'
    And I read it online
  Then "test" should link to "http://test.sidrasue.com/parts/1.html"

Scenario: end notes link to rating
  Given a page exists
  When I read it online
  Then Rate "Page 1" should link to its rate page

Scenario: end notes link to next chapter of same book
  Given a series exists
  When I read "Prologue" online
  Then Next should link to the content for "Cliffhanger"

Scenario: end notes link to next book of same series
  Given a series exists
  When I read "Book1" online
  Then Next should link to the content for "Book2"

Scenario: end notes link to first chapter of next book in same series
  Given a series exists
  When I read "Cliffhanger" online
  Then Next should link to the content for "Season2"

Scenario: end notes link to next single in same series
  Given a series exists
  When I read "Epilogue" online
  Then Next should link to the content for "Extras"

Scenario: no end notes link to Next if there is no next part (on last part)
  Given a series exists
  When I read "Extras" online
  Then I should NOT see "Next"

Scenario: no end notes link to Next if there is no next part (all at once)
  Given a series exists
  When I read "Series" online
  Then I should NOT see "Next"

