Feature: soon

Scenario: reading page
  Given pages with all possible soons exist
  When I am on the reading page
  Then I should see "now reading" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: soonest page
  Given pages with all possible soons exist
  When I am on the soonest page
  Then I should see "read next" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: soon page
  Given pages with all possible soons exist
  When I am on the soon page
  Then I should see "read soon" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: filter on now (all three of the above)
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Now"
    And I press "Find"
  Then I should see "now reading" within ".pages"
    And I should see "read next" within ".pages"
    And I should see "read soon" within ".pages"
    And the page should NOT contain css "#position_4"

Scenario: filter on default
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Default"
    And I press "Find"
  Then I should see "default" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: filter on later
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Someday"
    And I press "Find"
  Then I should see "read later" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: filter on eventually
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Eventually"
    And I press "Find"
  Then I should see "read eventually" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: filter on never (all three of the above)
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Never"
    And I press "Find"
  Then I should see "default" within ".pages"
    And I should see "read later" within ".pages"
    And I should see "read eventually" within ".pages"
    And the page should NOT contain css "#position_4"
