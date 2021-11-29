Feature: pages with omitted tags are filtered in by default. During search, anything with a omitted is found unless it is chosen from omitteds, in which case it is NOT found

  Scenario: shown by default
    Given I have no pages
    And a page exists with omitteds: "sad"
    When I am on the homepage
    Then I should NOT see "No pages found"
      And I should see "Page 1"
      And I should see "sad" within ".tags"
    When I am on the page's page
      Then I should see "sad" within ".omitteds"

  Scenario: omitted when selected
    Given I have no pages
    And a page exists with omitteds: "sad"
    And a page exists with title: "not sad"
    When I am on the homepage
      Then I should see "Page 1"
    When I select "sad" from "Omitted"
      And I press "Find"
    Then I should NOT see "Page 1"
    But I should see "not sad" within "#position_1"

   Scenario: filter by rating and omitted
    Given I have no pages
    And pages with ratings and omitteds exist
    When I am on the homepage
      And I select "interesting" from "rating"
      And I select "hateful" from "omitted"
      And I press "Find"
    Then I should NOT see "page3"
    And I should NOT see "page2"
    And I should NOT see "page1"
      But I should see "page5"
      And I should see "page4i"
      But I should NOT see "page4l"
    When I am on the homepage
      And I select "loving" from "rating"
      And I select "boring" from "omitted"
      And I press "Find"
    Then I should NOT see "page3"
     And I should NOT see "page2"
     And I should NOT see "page1"
      But I should see "page5"
      And I should see "page4l"
      But I should NOT see "page4i"

  Scenario: find by trope and omitted
    Given the following pages
      | title                            | tropes    | omitteds |
      | The Mysterious Affair at Styles  | mystery |          |
      | Alice in Wonderland              |         | children |
      | The Boxcar Children              | mystery | children |
    When I am on the homepage
      And I select "mystery" from "tag"
      And I select "children" from "omitted"
      And I press "Find"
    Then I should NOT see "The Boxcar Children"
      And I should NOT see "Alice in Wonderland"
      But I should see "The Mysterious Affair at Styles"

  Scenario: change omitted to trope tag
    Given I have no pages
    And I have no tags
    And a page exists with omitteds: "sad"
    When I am on the homepage
    Then I should be able to select "sad" from "omitted"
    When I am on the page's page
      Then I should see "sad" within ".omitteds"
    When I am on the edit tag page for "sad"
      And I select "Trope" from "change"
      And I press "Change"
    When I am on the homepage
    Then I should be able to select "sad" from "tag"
    And I should NOT be able to select "sad" from "omitted"
    When I am on the page's page
      Then I should see "sad" within ".tags"

  Scenario: change trope to omitted tag
    Given I have no pages
    And I have no tags
    And a page exists with tropes: "sad"
    When I am on the homepage
      Then I should NOT see "No pages found"
      And I should see "Page 1"
    And I should be able to select "sad" from "tag"
    When I am on the edit tag page for "sad"
      And I select "Omitted" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "sad" within ".omitteds"
    When I am on the homepage
      And I select "sad" from "omitted"
      And I press "Find"
    Then I should see "No pages found"
      And I should NOT see "Page 1"


