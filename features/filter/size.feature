Feature: filter on size

Scenario: check before filter on a size
  Given pages with all possible sizes exist
  When I am on the filter page
    And I press "Find"
  Then I should see "Drabble" within ".pages"
    And I should see "Short" within ".pages"
    And I should see "Medium" within ".pages"
    And I should see "Long" within ".pages"
    And I should see "Epic" within ".pages"
  When I press "Next"
  Then I should see "ShortBook" within ".pages"
  Then I should see "MediumBook" within ".pages"
  Then I should see "LongBook" within ".pages"
  Then I should see "EpicBook" within ".pages"

  When I am on the filter page
    And I click on "size_drabble"
    And I press "Find"
  Then I should see "Drabble" within "#position_1"
  Then I should see "DrabbleBook" within "#position_2"
    And the page should NOT contain css "#position_3"

  When I am on the filter page
    And I click on "size_short"
    And I press "Find"
  Then I should see "Short" within "#position_1"
    And I should see "ShortBook" within "#position_2"
    And the page should NOT contain css "#position_3"

  When I am on the filter page
    And I click on "size_medium"
    And I press "Find"
  Then I should see "Medium" within "#position_1"
    And I should see "MediumBook" within "#position_2"
    And the page should NOT contain css "#position_3"

  When I am on the filter page
    And I click on "size_long"
    And I press "Find"
  Then I should see "Long" within "#position_1"
    And I should see "LongBook" within "#position_2"
    And the page should NOT contain css "#position_3"

  When I am on the filter page
    And I click on "size_epic"
    And I press "Find"
  Then I should see "Epic" within "#position_1"
    And I should see "EpicBook" within "#position_2"
    And the page should NOT contain css "#position_3"

  When I am on the filter page
    And I click on "size_Longer"
    And I press "Find"
  Then I should see "Long" within "#position_1"
    And I should see "Epic" within "#position_2"
    And I should see "LongBook" within "#position_3"
    And I should see "EpicBook" within "#position_4"
    And the page should NOT contain css "#position_5"

  When I am on the filter page
    And I click on "size_Shorter"
    And I press "Find"
  Then I should see "Drabble" within "#position_1"
    And I should see "Short" within "#position_2"
    And I should see "DrabbleBook" within "#position_3"
    And I should see "ShortBook" within "#position_4"
    But the page should NOT contain css "#position_5"

  When I am on the filter page
    And I click on "sort_by_shortest"
    And I press "Find"
  Then I should see "Drabble" within "#position_1"
    And I should see "DrabbleBook" within "#position_2"
    And I should see "Short" within "#position_3"
    And I should see "ShortBook" within "#position_4"
    And I should see "MediumBook" within "#position_5"
  When I press "Next"
  Then I should see "Medium" within "#position_1"
    And I should see "LongBook" within "#position_2"
    And I should see "Long" within "#position_3"
    And I should see "EpicBook" within "#position_4"
    And I should see "Epic" within "#position_5"
  When I press "Next"
  Then I should see "No pages found" within "#flash_alert"

  When I am on the filter page
    And I click on "sort_by_longest"
    And I press "Find"
  Then I should see "Epic" within "#position_1"
    And I should see "EpicBook" within "#position_2"
    And I should see "Long" within "#position_3"
    And I should see "LongBook" within "#position_4"
    And I should see "Medium" within "#position_5"
  When I press "Next"
  Then I should see "MediumBook" within "#position_1"
    And I should see "ShortBook" within "#position_2"
    And I should see "Short" within "#position_3"
    And I should see "DrabbleBook" within "#position_4"
    And I should see "Drabble" within "#position_5"
  When I press "Next"
  Then I should see "No pages found" within "#flash_alert"

