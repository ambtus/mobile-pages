Feature: get more

Scenario: check before if there are no more pages
  Given 10 pages exist
  When I am on the homepage
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 10" within "#position_10"

Scenario: if there are no more pages
  Given 10 pages exist
  When I am on the homepage
    And I press "Next"
  Then I should see "No pages found"
    And I should NOT see "Page 1"
    And the page should NOT contain css "#position_1"

Scenario: limit 10
  Given 21 pages exist
  When I am on the homepage
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 10" within "#position_10"
    And I should NOT see "Page 11"
    And I should NOT see "Page 20"
    And I should NOT see "Page 21"

Scenario: press next
  Given 21 pages exist
  When I am on the homepage
    And I press "Next"
  Then I should see "Page 11" within "#position_1"
    And I should see "Page 20" within "#position_10"
    And I should NOT see "Page 4"
    And I should NOT see "Page 21"

Scenario: next remembers count
  Given 21 pages exist
  When I am on the homepage
    And I press "Next"
    And I press "Next"
  Then I should see "Page 21" within "#position_1"
    And the page should NOT contain css "#position_2"
    And I should NOT see "Page 1"
    And I should NOT see "Page 20"
