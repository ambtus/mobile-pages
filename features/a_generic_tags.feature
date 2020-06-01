Feature: generic tag stuff

  Scenario: strip tag whitespace and sort
    Given a page exists
    When I am on the page's page
      And I edit its tags
      And I fill in "tags" with "  funny,  joy  joy,happy happy  "
      And I press "Add Generic Tags"
    Then I should see "funny, happy happy, joy joy" within ".tags"

  Scenario: no tags exist during create
    Given I am on the homepage
      And I have no pages
      And I have no tags
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select tag"
    When I fill in "tags" with "my tag"
      And I press "Add Generic Tags"
    Then I should see "my tag" within ".tags"

  Scenario: no tags selected during create
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
    Then I should NOT see "Please select tag"
      And I should see "first" within ".tags"

  Scenario: add a tag to a page when there are no tags
    Given a page exists
    When I am on the page's page
      And I edit its tags
    When I fill in "tags" with "classic, children's"
      And I press "Add Generic Tags"
    Then I should see "classic" within ".tags"
      And I should see "children's" within ".tags"
    When I am on the homepage
    Then I should be able to select "classic" from "tag"
    And I should be able to select "children's" from "tag"

  Scenario: select a tag for a page when there are tags
    Given a tag exists with name: "fantasy"
    And a page exists
    When I am on the page's page
    When I edit its tags
      And I select "fantasy" from "page_tag_ids_"
      And I press "Update Tags"
    Then I should see "fantasy" within ".tags"

  Scenario: add a tag to a page which already has tags
    Given a page exists with tags: "classic"
    When I am on the page's page
    Then I should see "classic" within ".tags"
    When I edit its tags
      And I fill in "tags" with "something, children's"
      And I press "Add Generic Tags"
    Then I should see "children's, classic, something" within ".tags"
    When I am on the homepage
    Then I should be able to select "classic" from "tag"
      And I should be able to select "something" from "tag"
      And I should be able to select "children's" from "tag"

  Scenario: new parent for an existing page should have the same tag
    Given a page exists with tags: "tag"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    Then I should see "tag" within ".tags"
    And I should see "Page 1" within ".parts"
    But I should NOT see "tag" within ".parts"

  Scenario: list the tags
    Given a tag exists with name: "fantasy"
      And a tag exists with name: "science fiction"
    When I am on the tags page
    Then I should see "fantasy"
      And I should see "science fiction"
    When I follow "fantasy"
      Then I should see "Edit tag: fantasy"

  Scenario: edit the tag name
    Given a tag exists with name: "fantasy"
    When I am on the homepage
    Then I should be able to select "fantasy" from "tag"
    When I am on the edit tag page for "fantasy"
    And I fill in "tag_name" with "Fantasy"
    And I press "Update"
    When I am on the homepage
    Then I should be able to select "Fantasy" from "tag"
    But I should NOT be able to select "fantasy" from "tag"

  Scenario: delete a tag
    Given a page exists with tags: "science fiction"
    When I am on the edit tag page for "science fiction"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no tags
    When I am on the homepage
      Then I should NOT see "science fiction"
      But I should see "Page 1"

  Scenario: merge two tags
    Given a tag exists with name: "better name"
      And a page exists with tags: "bad name"
    When I am on the edit tag page for "bad name"
      And I select "better name" from "merge"
      And I press "Merge"
    Then I should see "better name"
      And I should NOT see "bad name"
    When I am on the homepage
      Then I should see "better name" within ".tags"
      And I should NOT see "bad name" within ".tags"
    When I am on the page's page
    Then I should NOT see "bad name"
    And I should see "better name" within ".tags"
