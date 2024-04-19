Feature: stars

Scenario: check before filter on stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I press "Find"
  Then I should see "page0" within ".pages"
    And I should see "page5" within ".pages"
    And I should see "page4" within ".pages"
    And I should see "page3" within ".pages"
    And I should see "page2" within ".pages"

Scenario: check before filter on stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I press "Find"
    And I press "Next"
  Then I should see "page1" within ".pages"

Scenario: search for 4 & 5 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I click on "stars_Better"
    And I press "Find"
  Then I should see "page5" within ".pages"
    And I should see "page4" within ".pages"
    And the page should NOT contain css "#position_3"

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

Scenario: search for 2 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I click on "stars_2"
    And I press "Find"
  Then I should see "page2" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: search for 1 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I click on "stars_1"
    And I press "Find"
  Then I should see "page1" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: search for 1 & 2 stars
  Given pages with all possible stars exist
  When I am on the filter page
    And I click on "stars_Worse"
    And I press "Find"
  Then I should see "page2" within ".pages"
    And I should see "page1" within ".pages"
    And the page should NOT contain css "#position_3"

