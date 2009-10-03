Feature: Extended Scrub

 Scenario: jump to end
  Given I have no pages
    And I am on the homepage
    And I fill in "page_url" with "http://sidrasue.com/tests/p.html"
    And I fill in "page_title" with "Title"
    And I press "Store"
    And I follow "Scrub"
  Then I follow "Jump to end"

