Feature: Extended Scrub

 Scenario: jump to end
  Given the following page
    |title | url |
    | Title | http://test.sidrasue.com/p.html |
  When I am on the homepage
    And I follow "Read"
    And I follow "Scrub"
  Then I follow "Jump to end"

 Scenario: remove surrounding div
  Given the following page
    |title | url |
    | Title | http://test.sidrasue.com/divs.html |
  When I am on the homepage
    And I follow "Read"
    And I follow "Scrub"
  When I press "Remove surrounding div"
  Then I should see "Surrounding div removed"
  When I check boxes "2"
  And I press "Scrub"
  Then I should not see "3"

 Scenario: remove surrounding blockquote
  Given the following page
    |title | url |
    | Title | http://test.sidrasue.com/blockquote.html |
  When I am on the homepage
    And I follow "Read"
    And I follow "Scrub"
  When I press "Remove surrounding div"
  Then I should see "Surrounding div removed"
  When I check boxes "2"
  And I press "Scrub"
  Then I should not see "3"

