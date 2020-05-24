Feature: generic tag stuff

  Scenario: strip tag whitespace amd sort
    Given a page exists
    When I am on the page's page
      And I follow "Tags"
      And I fill in "tags" with "  funny,  joy  joy,happy happy  "
      And I press "Add Tags"
    Then I should see "funny, happy happy, joy joy" within ".tags"

  Scenario: no tags
    Given I am on the homepage
      And I have no pages
      And I have no tags
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select tag"
    When I fill in "tags" with "my tag"
      And I press "Add Tags"
    Then I should see "my tag" within ".tags"

  Scenario: no tag selected
    Given a tag exists with name: "first"
      And I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select tag"
    When I select "first" from "page_tag_ids_"
      And I press "Update Tags"
    Then I should see "first" within ".tags"

  Scenario: tag selected during create
    Given a tag exists with name: "first"
      And I am on the homepage
      And I select "first" from "tag"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should not see "Please select tag"
      And I should see "first" within ".tags"

  Scenario: add a tag to a page when there are no tags
    Given a page exists
    When I am on the page's page
      And I follow "Tags"
    When I fill in "tags" with "classic, children's"
      And I press "Add Tags"
    Then I should see "classic" within ".tags"
      And I should see "children's" within ".tags"
    When I am on the homepage
    Then I select "classic" from "tag"
    Then I select "children's" from "tag"

  Scenario: select a tag for a page when there are tags
    Given a tag exists with name: "fantasy"
    And a page exists
    When I am on the page's page
    When I follow "Tags"
      And I select "fantasy" from "page_tag_ids_"
      And I press "Update Tags"
    Then I should see "fantasy" within ".tags"

  Scenario: add a tag to a page which has tags
    Given a page exists with add_tags_from_string: "classic"
    When I am on the page's page
    Then I should see "classic" within ".tags"
    When I follow "Tags"
      And I fill in "tags" with "something, children's"
      And I press "Add Tags"
    Then I should see "children's, classic, something" within ".tags"
    When I am on the homepage
    Then I select "classic" from "tag"
      And I select "something" from "tag"
      And I select "children's" from "tag"

  Scenario: new parent for an existing page should have the same tag
    Given a page exists with add_tags_from_string: "tag"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" within ".title"
    And I should see "tag" within ".tags"

  Scenario: list the tags
    Given a tag exists with name: "fantasy"
      And a tag exists with name: "science fiction"
    When I am on the tags page
    Then I should see "fantasy"
      And I should see "science fiction"
    When I follow "edit fantasy"
      Then I should see "Edit tag: fantasy"

  Scenario: edit the tag name
    Given a tag exists with name: "fantasy"
    When I am on the homepage
      And I select "fantasy" from "tag"
    When I am on the edit tag page for "fantasy"
    And I fill in "tag_name" with "Fantasy"
    And I press "Update"
    When I am on the homepage
      And I select "Fantasy" from "tag"

  Scenario: delete a tag
    Given a tag exists with name: "science fiction"
      And a page exists with add_tags_from_string: "science fiction"
    When I am on the edit tag page for "science fiction"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no tags
    When I am on the homepage
      Then I should not see "science fiction"

  Scenario: merge two tags
    Given a tag exists with name: "better name"
      And a page exists with add_tags_from_string: "bad name"
    When I am on the edit tag page for "bad name"
      And I select "better name" from "merge"
      And I press "Merge"
    Then I should see "better name"
      And I should not see "bad name"
    When I am on the homepage
      Then I should see "better name" within ".tags"
      And I should not see "bad name" within ".tags"
    When I select "better name" from "tag"
      And I press "Find"
    Then I should not see "No pages found"

  Scenario: find by tag
    Given the following pages
      | title                            | add_tags_from_string  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
      And I select "mystery" from "tag"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles"
      And I should see "The Boxcar Children"
      But I should not see "Alice in Wonderland"

