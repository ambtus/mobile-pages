Feature: hiddens are a type of tag, and can be created and selected like tags

  Scenario: strip hidden whitespace and sort
    Given a page exists
    When I am on the page's page
      And I edit its tags
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

  Scenario: hidden only selected during create
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

  Scenario: add a hidden to a page when there are no hiddens
    Given a page exists
    When I am on the page's page
      And I edit its tags
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
      And I edit its tags
      And I select "work in progress" from "page_tag_ids_"
      And I press "Update Tags"
    Then I should see "work in progress" within ".hiddens"

  Scenario: add a hidden to a page which already has hiddens
    Given a page exists with hiddens: "nonfiction"
    When I am on the page's page
    Then I should see "nonfiction" within ".hiddens"
    When I edit its tags
      And I fill in "tags" with "audio book, wip"
      And I press "Add Hidden Tags"
    Then I should see "audio book, nonfiction, wip" within ".hiddens"
    When I am on the homepage
    Then I select "nonfiction" from "Hidden"
      And I select "audio book" from "Hidden"
      And I select "wip" from "Hidden"

   Scenario: new parent for an existing page should NOT have the same hidden
    Given a page exists with hiddens: "nonfiction"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the page with title "New Parent"
    Then I should not see "nonfiction" within ".hiddens"
      But I should see "(nonfiction)" within "#position_1"
    When I am on the homepage
      Then I should see "New Parent" within "#position_1"
    But I should not see "nonfiction" within ".tags"

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
    Given a page exists with hiddens: "work in progress"
    When I am on the edit tag page for "work in progress"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no hiddens
    When I am on the homepage
      Then I should not see "work in progress"
      But I should see "Page 1"

  Scenario: merge two tags
    Given a tag exists with name: "better name" AND type: "Hidden"
      And a page exists with hiddens: "bad name"
    When I am on the edit tag page for "bad name"
      And I select "better name" from "merge"
      And I press "Merge"
    When I am on the page's page
    Then I should not see "bad name"
    And I should see "better name" within ".hiddens"

  Scenario: don’t allow merge if not the same type
    Given a tag exists with name: "not hidden"
    Given a tag exists with name: "bad name" AND type: "Hidden"
    When I am on the edit tag page for "bad name"
      Then I should not see "not hidden"
      And I should not see "Merge"

  Scenario: change hidden to generic tag
    Given a page exists with hiddens: "will be visible"
    When I am on the page's page
      Then I should see "will be visible" within ".hiddens"
    When I am on the edit tag page for "will be visible"
      And I select "" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "will be visible" within ".tags"
      And the page should not have any hidden tags

  Scenario: change generic to hidden tag
    Given a page exists with tags: "will be hidden"
    When I am on the page's page
      Then I should see "will be hidden" within ".tags"
    When I am on the edit tag page for "will be hidden"
      And I select "Hidden" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "will be hidden" within ".hiddens"
      And the page should not have any not hidden tags

