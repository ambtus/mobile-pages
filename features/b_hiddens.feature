@wip
Feature: hiddens are tags which are hidden by default. During search, anything with a hidden is not found unless it is chosen from hiddens. TODO: an ebook with a hidden tag is also hidden from marvin - its author and tag strings are empty and put into the comment string.

  Scenario: hidden selected during create
    Given a hidden exists with name: "nonfiction"
    Given a tag exists with name: "something"
      And I am on the homepage
      And I select "nonfiction" from "Hidden"
      And I select "something" from "tag"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should not see "Please select tag"
      And I should see "nonfiction" within ".hiddens"

  Scenario: two tags selected during create
    Given a tag exists with name: "first"
      And a hidden exists with name: "second"
      And I am on the homepage
      And I select "first" from "tag"
      And I select "second" from "hidden"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should not see "Please select tag"
      And I should see "first" within ".tags"
      And I should see "second" within ".hiddens"

  Scenario: find by two tags
    Given the following pages
      | title                            | add_tags_from_string  | add_hiddens_from_string |
      | The Mysterious Affair at Styles  | mystery | |
      | Alice in Wonderland              |         | children |
      | The Boxcar Children              | mystery | children |
    When I am on the homepage
      And I select "mystery" from "tag"
      And I select "children" from "hidden"
      And I press "Find"
    Then I should see "The Boxcar Children"
      But I should not see "The Mysterious Affair at Styles"
      And I should not see "Alice in Wonderland"

  Scenario: strip hidden whitespace
    Given a page exists
    When I am on the page's page
      And I follow "Hiddens"
      And I follow "Add Hidden Tags"
      And I fill in "hiddens" with "  nonfiction,  audio  book,save for   later  "
      And I press "Add Hidden Tags"
    Then I should see "audio book, nonfiction, save for later" within ".hiddens"

  Scenario: add a hidden to a page when there are no hiddens
    Given a page exists
    When I am on the page's page
      And I follow "Hiddens"
      And I follow "Add Hidden Tags"
    When I fill in "hiddens" with "nonfiction, audio book"
      And I press "Add Hidden Tags"
    Then I should see "nonfiction" within ".hiddens"
      And I should see "audio book" within ".hiddens"
    When I am on the homepage
    Then I select "nonfiction" from "Hidden"
    Then I select "audio book" from "Hidden"

  Scenario: select a hidden for a page when there are hiddens
    Given a hidden exists with name: "work in progress"
    And a page exists
    When I am on the page's page
      And I follow "Hiddens"
      And I select "work in progress" from "page_hidden_ids_"
      And I press "Update Hidden Tags"
    Then I should see "work in progress" within ".hiddens"

  Scenario: add a hidden to a page which has hiddens
    Given a page exists with add_hiddens_from_string: "nonfiction"
    When I am on the page's page
    Then I should see "nonfiction" within ".hiddens"
    When I follow "Hiddens"
      And I follow "Add Hidden Tags"
      And I fill in "hiddens" with "audio book, wip"
      And I press "Add Hidden Tags"
    Then I should see "audio book, nonfiction, wip" within ".hiddens"
    When I am on the homepage
    Then I select "nonfiction" from "Hidden"
      And I select "audio book" from "Hidden"
      And I select "wip" from "Hidden"

  Scenario: new parent for an existing page should have the same hidden
    Given a page exists with add_hiddens_from_string: "nonfiction"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the page's page
      And I follow "New Parent"
    Then I should see "nonfiction" within ".hiddens"

  Scenario: list the hiddens
    Given a hidden exists with name: "audio book"
    When I am on the hidden's edit page
    And I fill in "hidden_name" with "audiobooked"
    And I press "Update"
    When I am on the homepage
      And I select "audiobooked" from "Hidden"

  Scenario: delete a hidden
    Given I have no hiddens
    And a hidden exists with name: "work in progress"
      And a page exists with add_hiddens_from_string: "work in progress"
    When I am on the hidden's edit page
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no hiddens
    When I am on the homepage
      Then I should not see "work in progress"

  Scenario: merge two hiddens
    Given a hidden exists with name: "better name"
      And a page exists with add_hiddens_from_string: "bad name"
    When I am on the edit hidden page for "bad name"
      And I select "better name" from "merge"
      And I press "Merge"
    Then I should see "better name"
      And I should not see "bad name"
    When I am on the homepage
    And I select "better name" from "Hidden"
      And I press "Find"
    Then I should not see "No pages found"
      And I should see "better name" within ".hiddens"

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

  Scenario: find hidden
    Given the following pages
      | title                            | add_hiddens_from_string  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
      And I select "children" from "Hidden"
      And I press "Find"
    Then I should see "Alice in Wonderland"
      And I should see "The Boxcar Children"
      But I should not see "The Mysterious Affair at Styles"

  Scenario: move to tag
    Given I have no hiddens
    And a hidden exists with name: "hidden name"
      And a page exists with add_hiddens_from_string: "hidden name"
    When I am on the homepage
    Then I should see "No pages found"
    When I am on the edit hidden page for "hidden name"
      And I press "Move to Tag"
    When I am on the homepage
    Then I should not see "No pages found"
      And I should have no hiddens
      And I select "hidden name" from "tag"
      And I press "Find"
    Then I should not see "No pages found"


  Scenario: include hiddens
    Given the following pages
      | title                            | add_hiddens_from_string  |
      | Alice in Wonderland              | children          |
    When I am on the homepage
      Then I should not see "Alice in Wonderland"
    When I select "any" from "Hidden"
      And I press "Find"
    Then I should see "Alice in Wonderland"
