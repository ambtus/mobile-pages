Feature: filter by type

Scenario: default filter
  Given pages with all possible types exist
  When I am on the filter page
    And I press "Find"
  Then I should see "One-shot" within ".pages"
    And I should see "Novel" within ".pages"
    And I should see "Trilogy" within ".pages"
    And I should see "Untyped" within ".pages"
    And the page should NOT contain css "#position_5"
    But I should have 10 pages

Scenario: find untyped pages
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_none"
    And I press "Find"
  Then I should see "Untyped" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: find singles
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Single"
    And I press "Find"
  Then I should see "One-shot" within ".pages"
    And the page should NOT contain css "#position_2"

Scenario: find chapters
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Chapter"
    And I press "Find"
  Then I should see "Part 1 of Novel" within ".pages"
    And I should see "Part 2 of Novel" within ".pages"
    And I should see "Prologue of Alpha of Trilogy" within ".pages"
    And I should see "Epilogue of Beta of Trilogy" within ".pages"
    And the page should NOT contain css "#position_5"

Scenario: find books
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Book"
    And I press "Find"
  Then I should see "Novel" within ".pages"
    And I should see "Alpha of Trilogy" within ".pages"
    And I should see "Beta of Trilogy" within ".pages"
    And the page should NOT contain css "#position_4"

Scenario: find series
  Given pages with all possible types exist
  When I am on the filter page
    And I click on "type_Series"
    And I press "Find"
  Then I should see "Trilogy" within ".pages"
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
  When I press "Next"
  Then I should see "Alpha of Trilogy" within ".pages"
    And I should see "Beta of Trilogy" within ".pages"
    And I should see "Prologue of Alpha of Trilogy" within ".pages"
    And I should see "Epilogue of Beta of Trilogy" within ".pages"
    And I should see "Untyped" within ".pages"
