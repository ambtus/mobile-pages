Feature: pages with omitted tags are filtered in by default.
         During search, anything with a omitted is found
         unless it is chosen from omitteds, in which case it is NOT found

Scenario: shown by default
  Given a page exists with omitteds: "sad"
  When I am on the homepage
  Then I should NOT see "No pages found"
    And I should see "Page 1"
    And I should see "sad" within "#position_1"

Scenario: omitted when selected
  Given a page exists with omitteds: "very sad" AND title: "Page 1"
    And a page exists with omitteds: "slightly sad" AND title: "Page 2"
  When I am on the homepage
    And I select "very sad" from "Omitted"
    And I press "Find"
  Then I should NOT see "Page 1"
    But I should see "Page 2" within "#position_1"

Scenario: change omitted to trope tag (index)
  Given a page exists with omitteds: "sad"
  When I am on the edit tag page for "sad"
    And I select "Trope" from "change"
    And I press "Change"
    And I am on the homepage
    And I select "sad" from "tag"
    And I press "Find"
  Then I should NOT see "No pages found"
    And I should see "Page 1"

Scenario: change omitted to trope tag (index)
  Given a page exists with omitteds: "sad"
  When I am on the edit tag page for "sad"
    And I select "Trope" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "sad" within ".tags"

Scenario: change trope to omitted tag (page)
  Given a page exists with tropes: "sad"
  When I am on the edit tag page for "sad"
    And I select "Omitted" from "change"
    And I press "Change"
    And I am on the page's page
    Then I should see "sad" within ".omitteds"

Scenario: change trope to omitted tag (index)
  Given a page exists with tropes: "sad"
  When I am on the edit tag page for "sad"
    And I select "Omitted" from "change"
    And I press "Change"
    And I am on the homepage
    And I select "sad" from "omitted"
    And I press "Find"
  Then I should see "No pages found"
    And I should NOT see "Page 1"
