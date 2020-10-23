Feature: pages with hidden tags are filtered out by default. During search, anything with a hidden is not found unless it is chosen from hiddens.

  Scenario: hidden by default
    Given the following pages
      | title                            | hiddens  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
    Then I should see "No pages found"
      And I should NOT see "The Mysterious Affair at Styles"
      And I should NOT see "The Boxcar Children"
      And I should NOT see "Alice in Wonderland"

  Scenario: hidden by default with tags
    Given the following pages
      | title                            | tropes  | hiddens |
      | The Mysterious Affair at Styles  | mystery                 | hide |
      | Alice in Wonderland              | children                | hide, go away |
      | The Boxcar Children              | mystery, children       | |
    When I am on the homepage
    Then I should NOT see "No pages found"
      And I should see "The Boxcar Children"
      And I should NOT see "The Mysterious Affair at Styles"
      And I should NOT see "Alice in Wonderland"

  Scenario: find by hidden
    Given the following pages
      | title                            | hiddens  |
      | Alice in Wonderland              | children          |
    When I am on the homepage
      Then I should NOT see "Alice in Wonderland"
    When I select "children" from "Hidden"
      And I press "Find"
    Then I should see "Alice in Wonderland"

  Scenario: find by tag and hidden
    Given the following pages
      | title                            | tropes  | hiddens |
      | The Mysterious Affair at Styles  | mystery | |
      | Alice in Wonderland              |         | children |
      | The Boxcar Children              | mystery | children |
    When I am on the homepage
      And I select "mystery" from "tag"
      And I select "children" from "hidden"
      And I press "Find"
    Then I should see "The Boxcar Children"
      But I should NOT see "The Mysterious Affair at Styles"
      And I should NOT see "Alice in Wonderland"

  Scenario: change hidden to trope tag
    Given I have no pages
    And I have no tags
    And a page exists with hiddens: "will be visible"
    When I am on the homepage
      Then I should see "No pages found"
      And I select "will be visible" from "hidden"
    When I am on the page's page
      Then I should see "will be visible" within ".hiddens"
    When I am on the edit tag page for "will be visible"
      And I select "Trope" from "change"
      And I press "Change"
    When I am on the homepage
      Then I should NOT see "No pages found"
      And I should see "Page 1"
      And I select "will be visible" from "tag"
    When I am on the page's page
      Then I should see "will be visible" within ".tags"

  Scenario: change trope to hidden tag
    Given I have no pages
    And I have no tags
    And a page exists with tropes: "to be hidden"
    When I am on the homepage
      Then I should NOT see "No pages found"
      And I should see "Page 1"
      And I select "to be hidden" from "tag"
    When I am on the page's page
      Then I should see "to be hidden" within ".tags"
    When I am on the edit tag page for "to be hidden"
      And I select "Hidden" from "change"
      And I press "Change"
    When I am on the homepage
      Then I should see "No pages found"
      And I select "to be hidden" from "hidden"
    When I am on the page's page
      Then I should see "to be hidden" within ".hiddens"

