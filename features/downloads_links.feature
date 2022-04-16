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
  Then the epub html contents for "PrologueAfter the World Burns" should contain "coverhigh.jpg"

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
