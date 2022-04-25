Feature: filter on size

Scenario: any selected by default
  When I am on the filter page
  Then "size_any" should be checked

Scenario: check before filter on a size
  Given pages with all possible sizes exist
  When I am on the filter page
    And I press "Find"
  Then I should see "Drabble" within ".pages"
    And I should see "Short" within ".pages"
    And I should see "Medium" within ".pages"
    And I should see "Medium2" within ".pages"
    And I should see "Long" within ".pages"
    And I should see "Long2" within ".pages"
    And I should see "Epic" within ".pages"

Scenario: filter drabble
  Given pages with all possible sizes exist
  When I am on the filter page
    And I choose "size_drabble"
    And I press "Find"
  Then I should see "Drabble" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: filter short
  Given pages with all possible sizes exist
  When I am on the filter page
    And I choose "size_short"
    And I press "Find"
  Then I should see "Short" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: filter medium
  Given pages with all possible sizes exist
  When I am on the filter page
    And I choose "size_medium"
    And I press "Find"
  Then I should see "Medium" within ".pages"
    And I should see "Medium2" within ".pages"
    And the page should NOT contain css "#position_3"

Scenario: filter long
  Given pages with all possible sizes exist
  When I am on the filter page
    And I choose "size_long"
    And I press "Find"
  Then I should see "Long" within ".pages"
    And I should see "Long2" within ".pages"
    And the page should NOT contain css "#position_3"

Scenario: filter epic
  Given pages with all possible sizes exist
  When I am on the filter page
    And I choose "size_epic"
    And I press "Find"
  Then I should see "Epic" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: filter longer
  Given pages with all possible sizes exist
  When I am on the filter page
    And I choose "size_longer"
    And I press "Find"
  Then I should see "Long" within ".pages"
    And I should see "Long2" within ".pages"
    And I should see "Epic" within ".pages"
    And the page should NOT contain css "#position_4"

Scenario: filter shorter
  Given pages with all possible sizes exist
  When I am on the filter page
    And I choose "size_shorter"
    And I press "Find"
  Then I should see "Drabble" within ".pages"
    And I should see "Short" within ".pages"
    And the page should NOT contain css "#position_3"
