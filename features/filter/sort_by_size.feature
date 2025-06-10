Feature: sort by size

Scenario: sort by shortest
  Given pages with all possible sizes exist
  When I am on the filter page
    And I click on "sort_by_shortest"
    And I press "Find"
  Then I should see "Drabble" within "#position_1"
    And I should see "Short" within "#position_2"
    And I should see "Medium" within "#position_3"
    And I should see "Medium2" within "#position_4"
    And I should see "Long" within "#position_5"
  When I press "Next"
  Then I should see "Long2" within "#position_1"
    And I should see "Epic" within "#position_2"

Scenario: sort by longest
  Given pages with all possible sizes exist
  When I am on the filter page
    And I click on "sort_by_longest"
    And I press "Find"
  Then I should see "Medium" within "#position_5"
    And I should see "Medium2" within "#position_4"
    And I should see "Long" within "#position_3"
    And I should see "Long2" within "#position_2"
    And I should see "Epic" within "#position_1"
  When I press "Next"
  Then I should see "Drabble" within "#position_2"
    And I should see "Short" within "#position_1"
