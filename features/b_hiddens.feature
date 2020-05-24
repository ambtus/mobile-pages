Feature: hiddens are a type of tag, and can be created and selected like tags

  Scenario: strip hidden whitespace and sort
    Given a page exists
    When I am on the page's page
      And I follow "Tags"
      And I fill in "tags" with "  nonfiction,  audio  book,save for   later  "
      And I press "Add Hidden Tags"
    Then I should see "audio book, nonfiction, save for later" within ".hiddens"

  Scenario: no tags exist during create
    Given I am on the homepage
      And I have no pages
      And I have no tags
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select tag"
    When I fill in "tags" with "hide me"
      And I press "Add Hidden Tags"
    Then I should see "hide me" within ".hiddens"

  Scenario: no tags selected during create
    Given a tag exists with name: "first" AND type: "Hidden"
      And I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select tag"
    When I select "first" from "page_tag_ids_"
      And I press "Update Tags"
    Then I should see "first" within ".hiddens"

  Scenario: hidden selected during create
    Given a tag exists with name: "nonfiction" AND type: "Hidden"
    Given a tag exists with name: "something"
      And I am on the homepage
      And I select "nonfiction" from "hidden"
      And I select "something" from "tag"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should not see "Please select tag"
      And I should see "nonfiction" within ".hiddens"

  Scenario: hidden and tag selected during create
    Given a tag exists with name: "first"
      And a tag exists with name: "second" AND type: "Hidden"
      And I am on the homepage
      And I select "first" from "tag"
      And I select "second" from "hidden"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should not see "Please select tag"
      And I should see "first" within ".tags"
      And I should see "second" within ".hiddens"

  Scenario: add a hidden to a page when there are no hiddens
    Given a page exists
    When I am on the page's page
      And I follow "Tags"
    When I fill in "tags" with "nonfiction, audio book"
      And I press "Add Hidden Tags"
    Then I should see "nonfiction" within ".hiddens"
      And I should see "audio book" within ".hiddens"
    When I am on the homepage
    Then I select "nonfiction" from "Hidden"
    Then I select "audio book" from "Hidden"

  Scenario: select a hidden for a page when there are hiddens
    Given a tag exists with name: "work in progress" AND type: "Hidden"
    And a page exists
    When I am on the page's page
      And I follow "Tags"
      And I select "work in progress" from "page_tag_ids_"
      And I press "Update Tags"
    Then I should see "work in progress" within ".hiddens"

  Scenario: add a hidden to a page which already has hiddens
    Given a page exists with add_hiddens_from_string: "nonfiction"
    When I am on the page's page
    Then I should see "nonfiction" within ".hiddens"
    When I follow "Tags"
      And I fill in "tags" with "audio book, wip"
      And I press "Add Hidden Tags"
    Then I should see "audio book, nonfiction, wip" within ".hiddens"
    When I am on the homepage
    Then I select "nonfiction" from "Hidden"
      And I select "audio book" from "Hidden"
      And I select "wip" from "Hidden"

  Scenario: list the hiddens
    Given a tag exists
    Given a tag exists with name: "audio book" AND type: "Hidden"
    When I am on the tags page
    Then I should see "Tag 1"
      And I should see "audio book"
    When I follow "audio book"
      Then I should see "Edit tag: audio book"

  Scenario: edit the hidden name
    Given I have no tags
    And a tag exists with name: "fantasy" AND type: "Hidden"
    When I am on the homepage
      And I select "fantasy" from "hidden"
    When I am on the edit tag page for "fantasy"
    And I fill in "tag_name" with "speculative fiction"
    And I press "Update"
    When I am on the homepage
      And I select "speculative fiction" from "hidden"

  Scenario: delete a hidden
    Given a page exists with add_hiddens_from_string: "work in progress"
    When I am on the edit tag page for "work in progress"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no hiddens
    When I am on the homepage
      Then I should not see "work in progress"
      But I should see "Page 1"

  Scenario: don’t allow merge if not the same type
    Given a tag exists with name: "not hidden"
    Given a tag exists with name: "bad name" AND type: "Hidden"
    When I am on the edit tag page for "bad name"
      Then I should not see "not hidden"
      And I should not see "Merge"

  Scenario: merge two hiddens
    Given a tag exists with name: "not hidden"
    Given a tag exists with name: "better name" AND type: "Hidden"
      And a page exists with add_hiddens_from_string: "bad name"
    When I am on the edit tag page for "bad name"
      Then I should not see "not hidden"
      And I select "better name" from "merge"
      And I press "Merge"
    Then I should see "better name"
      And I should not see "bad name"
    When I am on the homepage
    And I select "better name" from "Hidden"
      And I press "Find"
    Then I should not see "No pages found"
      And I should see "better name" within ".tags"

  Scenario: change hidden to generic tag
    Given a tag exists
    And a tag exists with name: "hidden name" AND type: "Hidden"
    When I am on the homepage
      And I select "hidden name" from "hidden"
    When I am on the edit tag page for "hidden name"
      And I select "" from "change"
      And I press "Change"
    When I am on the homepage
      And I select "hidden name" from "tag"

  Scenario: change generic to hidden tag
    Given I have no tags
    And a tag exists with name: "to be hidden"
    When I am on the homepage
      And I select "to be hidden" from "tag"
    When I am on the edit tag page for "to be hidden"
      And I select "Hidden" from "change"
      And I press "Change"
    When I am on the homepage
      And I select "to be hidden" from "hidden"

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

  Scenario: find by tag and hidden
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


