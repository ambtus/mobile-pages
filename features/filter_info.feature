Feature: filter on info tags

  Scenario: find by tag
    Given the following pages
      | title                            | infos  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
      And I select "mystery" from "info"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles"
      And I should see "The Boxcar Children"
      But I should NOT see "Alice in Wonderland"

  Scenario: find after merging
    Given a page exists with infos: "better name"
      And a page exists with title: "should be found" AND infos: "bad name"
    When I am on the edit tag page for "bad name"
      And I select "better name" from "merge"
      And I press "Merge"
    When I am on the homepage
      Then I should see "better name" within ".tags"
      And I should NOT see "bad name" within ".tags"
    When I select "better name" from "info"
      And I press "Find"
    Then I should see "Page 1"
      And I should see "should be found"

