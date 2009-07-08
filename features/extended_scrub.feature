Feature: Extended Scrub

 Scenario: scrub everything between two nodes
  Given I have no pages
    And the following page
    | title    | url |
    | entities | http://www.rawbw.com/~alice/entities.html |
    And I am on the homepage
    And I follow "Read"
    And I follow "Scrub"
  When I check boxes "2 8"
    And I check "inclusive"
    And I press "Scrub"
  Then I should see "Chris was antsy"
    And I should not see "Content Removed"
    And I should not see "As the stags"
    And I should not see "All fiction, all for fun"
