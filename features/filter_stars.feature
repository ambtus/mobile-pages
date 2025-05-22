Feature: stars

Scenario: check before filter on stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I press "Find"
  Then I should see "page0" within ".pages"
    And I should see "page5" within ".pages"
    And I should see "page4" within ".pages"
    And I should see "page3" within ".pages"

Scenario: search for 5 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I click on "stars_5"
    And I press "Find"
  Then I should see "page5" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: search for 4 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I click on "stars_4"
    And I press "Find"
  Then I should see "page4" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: search for 3 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I click on "stars_3"
    And I press "Find"
  Then I should see "page3" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: search for historical stars
   Given the following pages
      | title                |  stars | last_read  |
      | The Mysterious Affair|  9     | 2009-01-01 |
      | Nancy Drew           |  3     | 2009-02-01 |
      | Orient Express       |  1     | 2009-03-01 |
      | Hardy Boys           |        | |
  When I am on the filter page
  When I click on "stars_other"
    And I press "Find"
  Then I should see "Orient Express"
    And I should see "The Mysterious Affair"
    But I should NOT see "Nancy Drew"
    And I should NOT see "Hardy Boys"
