Feature: filter on tags

Scenario: find by tag
  Given the following pages
    | title                            | tropes  |
    | The Mysterious Affair at Styles  | mystery           |
    | Alice in Wonderland              | children          |
    | The Boxcar Children              | mystery, children |
  When I am on the homepage
    And I select "mystery" from "tag"
    And I press "Find"
  Then I should see "The Mysterious Affair at Styles"
    And I should see "The Boxcar Children"
    But I should NOT see "Alice in Wonderland"

Scenario: find after merging
  Given a page exists with tropes: "better name"
    And a page exists with title: "should be found" AND tropes: "bad name"
  When I am on the edit tag page for "bad name"
    And I select "better name" from "merge"
    And I press "Merge"
    And I am on the homepage
    And I select "better name" from "tag"
    And I press "Find"
  Then I should see "Page 1" within "#position_1"
    And I should see "should be found" within "#position_2"
