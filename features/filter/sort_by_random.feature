Feature: random page

Scenario: can't find a random page if no pages
  When I am on the filter page
    And I click on "sort_by_random"
    And I press "Find"
  Then I should see "No pages"

Scenario: find a random page
  Given a page exists
  When I am on the filter page
    And I click on "sort_by_random"
    And I press "Find"
  Then I should NOT see "No pages found"

Scenario: don’t find unread random pages
  Given a page exists
  When I am on the filter page
    And I click on "unread_Read"
    And I click on "sort_by_random"
    And I press "Find"
  Then I should see "No pages found"

Scenario: do find unread random pages if requested
  Given a page exists
  When I am on the filter page
    And I click on "sort_by_random"
    And I click on "unread_Unread"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "Page 1" within "#position_1"

Scenario: don’t find unfinished random pages
  Given a page exists with stars: "9"
  When I am on the filter page
    And I click on "sort_by_random"
    And I click on "stars_4"
    And I press "Find"
  Then I should see "No pages found"
