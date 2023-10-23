Feature: allow find any

Scenario: shown by default
  Given a page exists with pros: "good"
  When I am on the homepage
  Then I should NOT see "No pages found"
    And I should see "Page 1"
    And I should see "good" within "#position_1"

Scenario: filtered in when selected
  Given a page exists with pros: "very good" AND title: "Page 1"
    And a page exists with pros: "slightly good" AND title: "Page 2"
  When I am on the filter page
    And I select "very good" from "Pro"
    And I press "Find"
  Then I should NOT see "Page 2"
    But I should see "Page 1" within "#position_1"

Scenario: filtered in when filtering in all
  Given a page exists with pros: "very good" AND title: "Page 1"
    And a page exists with pros: "slightly good" AND title: "Page 2"
  When I am on the filter page
    And I check "show_all"
    And I press "Find"
  Then I should see "Page 1"
    And I should see "Page 2"

Scenario: filter in with AKA
  Given the following pages
    | title                            | pros |
    | The Mysterious Affair at Styles  | agatha christie   |
    | Grimm's Fairy Tales              | grimm             |
    | Alice's Adventures In Wonderland | lewis carroll (charles dodgson) |
    | Through the Looking Glass        | lewis carroll |
  When I am on the filter page
    And I select "lewis carroll" from "Pro"
    And I press "Find"
  Then I should see "Alice's Adventures In Wonderland"
    And I should see "Through the Looking Glass"
    But I should NOT see "The Mysterious Affair at Styles"
    And I should NOT see "Grimm's Fairy Tales"

Scenario: new parent for an existing page should be proed (not duped)
  Given a page exists with pros: "abc123"
  When I am on the page's page
    And I add a parent with title "New Parent"
  Then I should see "abc123" within ".pros"
    But I should NOT see "abc123" within "#position_1"
    And "New Parent" should be proed
    But the page should NOT be proed

Scenario: any pros
  Given pages with all combinations of pros and cons exist
  When I am on the filter page
    And I check "show_all"
    And I press "Find"
  Then I should see "page5"
    And I should see "page4i"
    And I should see "page4l"
    And I should see "page3h"
    And I should see "page3l"
    But I should NOT see "page3d"
    And I should NOT see "page2"
    And I should NOT see "page1"

Scenario: pro selected during create is filterable
  Given "abc123" is a "Pro"
    And a page exists with title: "Page 3"
  When I am on the create page
    And I select "abc123"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
    And I am on the filter page
    And I check "show_all"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "abc123"
    But I should NOT see "Page 3"
