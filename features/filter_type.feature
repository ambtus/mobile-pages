Feature: filter by type

Scenario: check before filter (default)
  Given pages with all possible types exist
  When I am on the homepage
  Then I should see "One-shot" within "#position_1"
    And I should see "Novel" within "#position_2"
    And I should see "Trilogy" within "#position_3"
    And I should see "Life's Work" within "#position_4"
    And the page should NOT contain css "#position_5"

Scenario: find untyped pages
  Given pages with all possible types exist
  When I am on the filter page
    And I choose "type_none"
    And I press "Find"
  Then I should see "No pages found"

Scenario: find singles
  Given pages with all possible types exist
  When I am on the filter page
    And I choose "type_Single"
    And I press "Find"
  Then I should see "One-shot" within "#position_1"
    And I should see "First of Life's Work" within "#position_2"
    And the page should NOT contain css "#position_3"

Scenario: find chapters
  Given pages with all possible types exist
  When I am on the filter page
    And I choose "type_Chapter"
    And I press "Find"
  Then I should see "Part 1 of Novel" within "#position_1"
    And I should see "Part 2 of Novel" within "#position_2"
    And I should see "Prologue of Alpha of Trilogy" within "#position_3"
    And I should see "Epilogue of Beta of Trilogy" within "#position_4"
    And I should see "Part 1 of Second of Life's Work" within "#position_5"
    And I should see "Part 2 of Second of Life's Work" within "#position_6"
    And the page should NOT contain css "#position_7"

Scenario: find books
  Given pages with all possible types exist
  When I am on the filter page
    And I choose "type_Book"
    And I press "Find"
  Then I should see "Novel" within "#position_1"
    And I should see "Alpha of Trilogy" within "#position_2"
    And I should see "Beta of Trilogy" within "#position_3"
    And I should see "Second of Life's Work" within "#position_4"
    And I should see "Fourth of Third of Life's Work" within "#position_5"
    And I should see "Fifth of Third of Life's Work" within "#position_6"
    And the page should NOT contain css "#position_7"

Scenario: find series
  Given pages with all possible types exist
  When I am on the filter page
    And I choose "type_Series"
    And I press "Find"
  Then I should see "Trilogy" within "#position_1"
    And I should see "Third of Life's Work" within "#position_2"
    And the page should NOT contain css "#position_3"

Scenario: find collections
  Given pages with all possible types exist
  When I am on the filter page
    And I choose "type_Collection"
    And I press "Find"
  Then I should see "Life's Work" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: find everything
  Given pages with all possible types exist
  When I am on the filter page
    And I choose "type_all"
    And I press "Find"
  Then I should see "One-shot" within "#position_1"
    And I should see "Novel" within "#position_2"
    And I should see "Part 1 of Novel" within "#position_3"
    And I should see "Part 2 of Novel" within "#position_4"
    And I should see "Trilogy" within "#position_5"
    And I should see "Alpha of Trilogy" within "#position_6"
    And I should see "Beta of Trilogy" within "#position_7"
    And I should see "Prologue of Alpha of Trilogy" within "#position_8"
    And I should see "Epilogue of Beta of Trilogy" within "#position_9"
    And I should see "Life's Work" within "#position_10"
