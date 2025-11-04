Feature: get more

Scenario: check before if there are no more pages
  Given 5 pages exist
  When I am on the pages page
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 5" within "#position_5"

Scenario: if there are no more pages
  Given 5 pages exist
  When I am on the pages page
    And I press "Next"
  Then I should see "No pages found"
    And I should NOT see "Page 1"
    And the page should NOT contain css "#position_1"

Scenario: limit 5
  Given 11 pages exist
  When I am on the pages page
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 5" within "#position_5"
    And I should NOT see "Page 6"
    And I should NOT see "Page 10"
    And I should NOT see "Page 11"

Scenario: press next
  Given 11 pages exist
  When I am on the pages page
    And I press "Next"
  Then I should see "Page 6" within "#position_1"
    And I should see "Page 10" within "#position_5"
    And I should NOT see "Page 5"
    And I should NOT see "Page 11"

Scenario: next remembers count
  Given 11 pages exist
  When I am on the pages page
    And I press "Next"
    And I press "Next"
  Then I should see "Page 11" within "#position_1"
    And the page should NOT contain css "#position_2"
    And I should NOT see "Page 6"
    And I should NOT see "Page 10"
