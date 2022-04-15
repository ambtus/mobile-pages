Feature: stars

Scenario: search for 4 & 5 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I choose "stars_better"
    And I press "Find"
  Then I should see "page5"
    And I should see "page4"
    And "better" should be checked
    But I should NOT see "page3"
    And I should NOT see "page2"
    And I should NOT see "page1"

Scenario: search for 5 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I choose "stars_5"
    And I press "Find"
  Then I should see "page5"
    And "5" should be checked
    But I should NOT see "page4"
    And I should NOT see "page3"
    And I should NOT see "page2"
    And I should NOT see "page1"

Scenario: search for 4 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I choose "stars_4"
    And I press "Find"
  Then I should see "page4"
    And "4" should be checked
    But I should NOT see "page5"
    And I should NOT see "page3"
    And I should NOT see "page2"
    And I should NOT see "page1"

Scenario: search for 3 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I choose "stars_3"
    And I press "Find"
  Then I should NOT see "page5"
    And I should NOT see "page4"
    And I should NOT see "page2"
    And I should NOT see "page1"
    But I should see "page3"

Scenario: search for 2 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I choose "stars_2"
    And I press "Find"
  Then I should NOT see "page5"
    And I should NOT see "page4"
    And I should NOT see "page3"
    But I should see "page2"
    But I should NOT see "page1"

Scenario: search for 1 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I choose "stars_1"
    And I press "Find"
  Then I should NOT see "page5"
    And I should NOT see "page4"
    And I should NOT see "page3"
    And I should NOT see "page2"
    But I should see "page1"

Scenario: search for 1 & 2 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I choose "stars_worse"
    And I press "Find"
  Then I should NOT see "page5"
    And I should NOT see "page4"
    And I should NOT see "page3"
    But I should see "page2"
    And I should see "page1"

