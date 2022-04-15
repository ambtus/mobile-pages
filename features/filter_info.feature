Feature: filter on info tags

Scenario: find by info tag
  Given the following pages
    | title                            | infos             |
    | The Mysterious Affair at Styles  | mystery           |
    | Alice in Wonderland              | children          |
    | The Boxcar Children              | mystery, children |
  When I am on the filter page
    And I select "mystery" from "info"
    And I press "Find"
  Then I should see "The Mysterious Affair at Styles"
    And I should see "The Boxcar Children"
    But I should NOT see "Alice in Wonderland"

Scenario: find after merging
  Given a page exists with title: "Page 1" AND infos: "abc123"
    And a page exists with title: "Page 2" AND infos: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the filter page
    And I select "abc123" from "info"
    And I press "Find"
  Then I should see "Page 1"
    And I should see "Page 2"

