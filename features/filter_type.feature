Feature: filter by type

Scenario: default filter
  Given pages with all possible types exist
  When I am on the filter page
    And I press "Find"
  Then I should see "One-shot" within ".pages"
    And I should see "Novel" within ".pages"
    And I should see "Trilogy" within ".pages"
    And I should see "Life's Work" within ".pages"
    And the page should NOT contain css "#position_5"

Scenario: find untyped pages
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_none"
    And I press "Find"
  Then I should see "No pages found"

Scenario: find singles
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Single"
    And I press "Find"
  Then I should see "One-shot" within ".pages"
    And I should see "First of Life's Work" within ".pages"
    And the page should NOT contain css "#position_3"

Scenario: find chapters pt1
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Chapter"
    And I press "Find"
  Then I should see "Part 1 of Novel" within ".pages"
    And I should see "Part 2 of Novel" within ".pages"
    And I should see "Prologue of Alpha of Trilogy" within ".pages"
    And I should see "Epilogue of Beta of Trilogy" within ".pages"
    And I should see "Part 1 of Second of Life's Work" within ".pages"

Scenario: find chapters pt1
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Chapter"
    And I press "Find"
    And I press "Next"
    And I should see "Part 2 of Second of Life's Work" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: find books pt1
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Book"
    And I press "Find"
  Then I should see "Novel" within ".pages"
    And I should see "Alpha of Trilogy" within ".pages"
    And I should see "Beta of Trilogy" within ".pages"
    And I should see "Second of Life's Work" within ".pages"
    And I should see "Fourth of Third of Life's Work" within ".pages"

Scenario: find books pt2
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Book"
    And I press "Find"
    And I press "Next"
  Then I should see "Fifth of Third of Life's Work" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: find series
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Series"
    And I press "Find"
  Then I should see "Trilogy" within ".pages"
    And I should see "Third of Life's Work" within ".pages"
    And the page should NOT contain css "#position_3"

Scenario: find collections
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Collection"
    And I press "Find"
  Then I should see "Life's Work" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: find everything pt1
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_all"
    And I press "Find"
  Then I should see "One-shot" within ".pages"
    And I should see "Novel" within ".pages"
    And I should see "Part 1 of Novel" within ".pages"
    And I should see "Part 2 of Novel" within ".pages"
    And I should see "Trilogy" within ".pages"

Scenario: find everything pt2
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_all"
    And I press "Find"
    And I press "Next"
  Then I should see "Alpha of Trilogy" within ".pages"
    And I should see "Beta of Trilogy" within ".pages"
    And I should see "Prologue of Alpha of Trilogy" within ".pages"
    And I should see "Epilogue of Beta of Trilogy" within ".pages"
    And I should see "Life's Work" within ".pages"
