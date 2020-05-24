@wip
Feature: pages with hidden tags are filtered out by default. During search, anything with a hidden is not found unless it is chosen from hiddens.

  Scenario: hidden by default
    Given the following pages
      | title                            | add_hiddens_from_string  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
    Then I should see "No pages found"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "The Boxcar Children"
      And I should not see "Alice in Wonderland"

  Scenario: hidden by default with tags
    Given the following pages
      | title                            | add_tags_from_string  | add_hiddens_from_string |
      | The Mysterious Affair at Styles  | mystery                 | hide |
      | Alice in Wonderland              | children                | hide, go away |
      | The Boxcar Children              | mystery, children       | |
    When I am on the homepage
    Then I should not see "No pages found"
      And I should see "The Boxcar Children"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "Alice in Wonderland"

  Scenario: include hiddens
    Given the following pages
      | title                            | add_hiddens_from_string  |
      | Alice in Wonderland              | children          |
    When I am on the homepage
      Then I should not see "Alice in Wonderland"
    When I select "any" from "Hidden"
      And I press "Find"
    Then I should see "Alice in Wonderland"

  Scenario: move to tag
    Given I have no hiddens
    And a tag exists with name: "hidden name" AND type: "Hidden"
      And a page exists with add_hiddens_from_string: "hidden name"
    When I am on the homepage
    Then I should see "No pages found"
    When I am on the edit tag page for "hidden name"
      And I press "Move to Tag"
    When I am on the homepage
    Then I should not see "No pages found"
      And I should have no hiddens
      And I select "hidden name" from "tag"
      And I press "Find"
    Then I should not see "No pages found"

  Scenario: new parent for an existing page should have the same hidden
    Given I'm not so sure about this
    Given a page exists with add_hiddens_from_string: "nonfiction"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the page's page
      And I follow "New Parent"
    Then I should see "nonfiction" within ".hiddens"

