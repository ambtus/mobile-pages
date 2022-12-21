Feature: soon

Scenario: quick links
  Given I am on the mini page
  Then I should see "Reading Next"
    But I should NOT see "Default Someday Eventually"
    And I should NOT see "Soon"

Scenario: next page
  Given pages with all possible soons exist
  When I am on the soonest page
  Then I should see "read next" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: filter on now (reading + all three soons)
  Given pages with all possible soons exist
  When I am on the filter page
    And I click on "Now"
    And I press "Find"
  Then I should see "now reading" within ".pages"
    And I should see "read next" within ".pages"
    And I should see "read sooner" within ".pages"
    And I should see "read soon" within ".pages"
    And the page should NOT contain css "#position_5"

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
