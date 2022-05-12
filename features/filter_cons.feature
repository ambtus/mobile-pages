Feature: pages with con tags are filtered in by default.
         During search, anything with a con is found
         unless it is chosen from cons, in which case it is NOT found

Scenario: shown by default
  Given a page exists with cons: "sad"
  When I am on the homepage
  Then I should NOT see "No pages found"
    And I should see "Page 1"
    And I should see "sad" within "#position_1"

Scenario: filtered out when selected
  Given a page exists with cons: "very sad" AND title: "Page 1"
    And a page exists with cons: "slightly sad" AND title: "Page 2"
  When I am on the filter page
    And I select "very sad" from "Con"
    And I press "Find"
  Then I should NOT see "Page 1"
    But I should see "Page 2" within "#position_1"
    And "hide_all_cons_No" should be checked

Scenario: filtered out when filtering out all
  Given a page exists with cons: "very sad" AND title: "Page 1"
    And a page exists with cons: "slightly sad" AND title: "Page 2"
  When I am on the filter page
    And I choose "hide_all_cons_Yes"
    And I press "Find"
  Then I should see "No pages found"
    And "hide_all_cons_Yes" should be checked

Scenario: change con to pro tag (index)
  Given a page exists with cons: "sad"
  When I am on the edit tag page for "sad"
    And I select "Pro" from "change"
    And I press "Change"
    And I am on the filter page
    And I select "sad" from "pro"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "Page 1"

Scenario: change con to pro tag (index)
  Given a page exists with cons: "sad"
  When I am on the edit tag page for "sad"
    And I select "Pro" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "sad" within ".pros"

Scenario: change pro to con tag (page)
  Given a page exists with pros: "sad"
  When I am on the edit tag page for "sad"
    And I select "Con" from "change"
    And I press "Change"
    And I am on the page's page
    Then I should see "sad" within ".cons"

Scenario: change pro to con tag (index)
  Given a page exists with pros: "sad"
  When I am on the edit tag page for "sad"
    And I select "Con" from "change"
    And I press "Change"
    And I am on the filter page
    And I select "sad" from "con"
    And I press "Find"
  Then I should see "No pages found"
    And I should NOT see "Page 1"

Scenario: filter out with AKA
  Given the following pages
    | title                            | cons |
    | The Mysterious Affair at Styles  | agatha christie   |
    | Grimm's Fairy Tales              | grimm             |
    | Alice's Adventures In Wonderland | lewis carroll (charles dodgson) |
    | Through the Looking Glass        | lewis carroll |
  When I am on the filter page
    And I select "lewis carroll" from "Con"
    And I press "Find"
  Then I should NOT see "Alice's Adventures In Wonderland"
    And I should NOT see "Through the Looking Glass"
    But I should see "The Mysterious Affair at Styles"
    And I should see "Grimm's Fairy Tales"

Scenario: new parent for an existing page should be conned (not duped, so i'm not)
  Given a page exists with cons: "abc123"
  When I am on the page's page
    And I add a parent with title "New Parent"
  Then I should see "abc123" within ".cons"
    But I should NOT see "abc123" within "#position_1"
    And "New Parent" should be conned
    But the page should NOT be conned

Scenario: no cons
  Given pages with all combinations of pros and cons exist
  When I am on the filter page
    And I choose "hide_all_cons_Yes"
    And I press "Find"
  Then I should see "page3"
    And I should see "page4"
    And I should see "page5"
    But I should NOT see "page1"
    And I should NOT see "page2"
    And I should NOT see "page3h"
    And the page should NOT contain css "#position_5"
    But I should have 9 pages
