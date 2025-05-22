Feature: filter by wip

Scenario: check before filter (default)
  Given pages with all possible wips exist
  When I am on the filter page
    And I press "Find"
  Then I should see "wip"
    And I should see "finished"
    And I press "Next"
  Then the page should contain css "#position_1"
    But the page should NOT contain css "#position_2"

Scenario: wip
  Given pages with all possible wips exist
  When I am on the filter page
    And I click on "wip_Yes"
    And I press "Find"
  Then I should see "wip book" within "#position_1"
    And I should see "wip series" within "#position_2"
    And I should see "wip series with wip book"
    And the page should NOT contain css "#position_4"

Scenario: wip (only books)
  Given pages with all possible wips exist
  When I am on the filter page
    And I click on "wip_Yes"
    And I click on "type_Book"
    And I press "Find"
  Then I should see "wip book" within "#position_1"
    And I should see "wip book2 of finished series with wip book"
    And I should see "wip book1 of wip series with wip book"
    And the page should NOT contain css "#position_4"

Scenario: not wip
  Given pages with all possible wips exist
  When I am on the filter page
    And I click on "wip_No"
    And I press "Find"
  Then I should see "finished book" within "#position_1"
    And I should see "finished series" within "#position_2"
    And I should see "finished series with wip book" within "#position_3"
    And the page should NOT contain css "#position_4"

Scenario: not wip (only books)
  Given pages with all possible wips exist
  When I am on the filter page
    And I click on "wip_No"
    And I click on "type_Book"
    And I click on "parent_No"
    And I press "Find"
  Then I should see "finished book" within "#position_1"
    And the page should NOT contain css "#position_2"
