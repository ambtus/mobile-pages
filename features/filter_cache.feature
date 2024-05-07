Feature: filter tag cache

Scenario: find a series with fandom and author tags doesn't work
  Given tags exist
    And Counting Drabbles exists
  When I am on the filter page
    And I select "Sidra"
    And I select "Harry Potter"
    And I click on "Series"
    And I press "Find"
  Then I should see "No pages found"
    And I should NOT see "Counting Drabbles"

Scenario: find a series with fandom and author cache does work
  Given tags exist
    And Counting Drabbles exists
    And Iterum Rex exists
  When I am on the filter page
    And I fill in "page_tag_cache" with "Sidra, Harry Potter"
    And I click on "Series"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "Counting Drabbles"
    But I should NOT see "Iterum Rex"

Scenario: wrong fandom
  Given tags exist
    And Counting Drabbles exists
  When I am on the filter page
    And I fill in "page_tag_cache" with "Sidra, Popslash"
    And I click on "Series"
    And I press "Find"
  Then I should see "No pages found"
    And I should NOT see "Counting Drabbles"

Scenario: wrong author
  Given tags exist
    And Counting Drabbles exists
  When I am on the filter page
    And I fill in "page_tag_cache" with "esama, Harry Potter"
    And I click on "Series"
    And I press "Find"
  Then I should see "No pages found"
    And I should NOT see "Counting Drabbles"

Scenario: tag cache doesn't find aka
  Given a page exists with authors: "dick (boba)" AND title: "dicks' book"
    And a page exists with authors: "jane (boba)" AND title: "jane's book"
  When I am on the filter page
    And I fill in "page_tag_cache" with "boba"
    And I press "Find"
  Then I should see "No pages found"

Scenario: tag cache does find basename
  Given a page exists with authors: "dick (boba)" AND title: "dicks' book"
    And a page exists with authors: "jane (boba)" AND title: "jane's book"
  When I am on the filter page
    And I fill in "page_tag_cache" with "dick"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "dicks' book"
    But I should NOT see "jane's book"
