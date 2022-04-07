Feature: page size

Scenario: check before filter on a size
  Given pages with all possible sizes exist
  When I am on the homepage
  Then I should see "Drabble" within "#position_1"
    And I should see "Short" within "#position_2"
    And I should see "Medium" within "#position_3"
    And I should see "Long" within "#position_4"
    And I should see "Medium2" within "#position_5"
    And I should see "Long2" within "#position_6"
    And I should see "Epic" within "#position_7"

Scenario: filter drabble
  Given pages with all possible sizes exist
  When I am on the homepage
    And I choose "size_drabble"
    And I press "Find"
  Then I should see "Drabble" within "#position_1"
    And I should NOT see "Short"
    And I should NOT see "Medium"
    And I should NOT see "Long"
    And I should NOT see "Epic"

Scenario: filter short
  Given pages with all possible sizes exist
  When I am on the homepage
    And I choose "size_short"
    And I press "Find"
  Then I should see "Short" within "#position_1"
    But I should NOT see "Drabble"
    And I should NOT see "Medium"
    And I should NOT see "Long"
    And I should NOT see "Epic"
    And I should NOT see "Part"

Scenario: filter medium
  Given pages with all possible sizes exist
  When I am on the homepage
    And I choose "size_medium"
    And I press "Find"
  Then I should see "Medium" within "#position_1"
    And I should see "Medium2" within "#position_2"
    And I should NOT see "Drabble"
    And I should NOT see "Short"
    And I should NOT see "Long"
    And I should NOT see "Epic"

Scenario: filter long
  Given pages with all possible sizes exist
  When I am on the homepage
    And I choose "size_long"
    And I press "Find"
  Then I should see "Long" within "#position_1"
    And I should see "Long2" within "#position_2"
    And I should NOT see "Drabble"
    And I should NOT see "Short"
    And I should NOT see "Medium"
    And I should NOT see "Epic"
    And I should NOT see "Part"

Scenario: filter epic
  Given pages with all possible sizes exist
  When I am on the homepage
    And I choose "size_epic"
    And I press "Find"
  Then I should see "Epic" within "#position_1"
    And I should NOT see "Drabble"
    And I should NOT see "Short"
    And I should NOT see "Medium"
    But I should NOT see "Long"
    And I should NOT see "Part"

Scenario: filter longer
  Given pages with all possible sizes exist
  When I am on the homepage
    And I choose "size_longer"
    And I press "Find"
  Then I should see "Long" within "#position_1"
    And I should see "Long2" within "#position_2"
    And I should see "Epic" within "#position_3"
    And I should NOT see "Drabble"
    And I should NOT see "Short"
    And I should NOT see "Medium"
    And I should NOT see "Part"

Scenario: filter shorter
  Given pages with all possible sizes exist
  When I am on the homepage
    And I choose "size_shorter"
    And I press "Find"
  Then I should see "Drabble" within "#position_1"
    And I should see "Short" within "#position_2"
    But I should NOT see "Medium"
    And I should NOT see "Long"
    And I should NOT see "Epic"
