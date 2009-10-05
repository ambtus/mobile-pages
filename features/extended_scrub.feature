Feature: Extended Scrub

 Scenario: jump to end
  Given the following page
    |title | url |
    | Title | http://sidrasue.com/tests/p.html |
  When I am on the homepage
    And I follow "Read"
    And I follow "Scrub"
  Then I follow "Jump to end"

