Feature: soon

Scenario: quick links
  Given I am on the mini page
  Then I should see "Reading Next"
    But I should NOT see "Default Someday"
    And I should NOT see "Soon"

Scenario: reading page
  Given pages with all possible soons exist
  When I am on the reading page
  Then I should see "now reading" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: next page
  Given pages with all possible soons exist
  When I am on the soonest page
  Then I should see "read next" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: filter on reading
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Reading"
    And I press "Find"
  Then I should see "now reading" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: filter on soonest
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Soonest"
    And I press "Find"
  Then I should see "read next" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: filter on sooner
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Sooner"
    And I press "Find"
  Then I should see "read sooner" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: filter on default
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Default"
    And I press "Find"
  Then I should see "default" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: filter on someday
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Someday"
    And I press "Find"
  Then I should see "read later" within ".pages"
    And the page should NOT contain css "#position_2"

