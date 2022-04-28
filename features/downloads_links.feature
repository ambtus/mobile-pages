Feature: links in downloads

Scenario: link to page in downloaded html
  Given a page exists
  When I am on the page's page
    And I view the content
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
  When I am on the page's page
    And I follow "Edit Raw HTML"
    And I fill in "pasted" with 'This is a <a href="http://test.sidrasue.com/parts/1.html">test</a>!'
    And I press "Update Raw HTML"
    And I view the content
  Then "test" should link to "http://test.sidrasue.com/parts/1.html"

Scenario: end notes link to rating
  Given a page exists
  When I am on the page's page
     And I view the content
  Then Rate "Page 1" should link to its rate page

Scenario: end notes link to next chapter of same book
  Given a series exists
  When I am on the page with title "Prologue"
    And I view the content
  Then "Next" should link to the content for "Cliffhanger"

Scenario: end notes link to next book of same series
  Given a series exists
  When I am on the page with title "Book1"
    And I view the content
  Then "Next" should link to the content for "Book2"

Scenario: end notes link to first chapter of next book in same series
  Given a series exists
  When I am on the page with title "Cliffhanger"
    And I view the content
  Then "Next" should link to the content for "Season2"

Scenario: end notes link to next single in same series
  Given a series exists
  When I am on the page with title "Epilogue"
    And I view the content
  Then "Next" should link to the content for "Extras"

Scenario: no end notes link to Next if there is no next part (on last part)
  Given a series exists
  When I am on the page with title "Extras"
    And I view the content
  Then I should NOT see "Next"

Scenario: no end notes link to Next if there is no next part (all at once)
  Given a series exists
  When I am on the page with title "Series"
    And I view the content
  Then I should NOT see "Next"

