Feature: filter tag cache

Scenario: find a series with fandom and author cache does work
  Given tags exist
    And Counting Drabbles exists
    And Iterum Rex exists
  When I am on the filter page
    And I select "Sidra"
    And I select "Harry Potter"
    And I click on "Series"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "Counting Drabbles"
    But I should NOT see "Iterum Rex"

Scenario: wrong fandom
  Given tags exist
    And Counting Drabbles exists
  When I am on the filter page
    And I select "Sidra"
    And I select "Popslash"
    And I click on "Series"
    And I press "Find"
  Then I should see "No pages found"
    And I should NOT see "Counting Drabbles"

Scenario: wrong author
  Given tags exist
    And Counting Drabbles exists
  When I am on the filter page
    And I select "esama"
    And I select "Harry Potter"
    And I click on "Series"
    And I press "Find"
  Then I should see "No pages found"
    And I should NOT see "Counting Drabbles"

