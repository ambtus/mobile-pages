Feature: omitteds are a type of tag, and can be created and selected like tags

  Scenario: strip whitespace and sort
    Given a page exists
    When I am on the page's page
      And I edit its tags
      And I fill in "tags" with "  nonfiction,  audio  book,save for   later  "
      And I press "Add Omitted Tags"
    Then I should see "audio book, nonfiction, save for later" within ".omitteds"

  Scenario: no tags exist during create
    Given I am on the homepage
      And I have no pages
      And I have no tags
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Page created with Other Fandom"
    When I edit its tags
      And I fill in "tags" with "hide me"
      And I press "Add Omitted Tags"
    Then I should see "hide me" within ".omitteds"

  Scenario: no tags selected during create
    Given a tag exists with name: "first" AND type: "Omitted"
      And I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Page created with Other Fandom"
    When I edit its tags
      And I select "first" from "page_omitted_ids_"
      And I press "Update Tags"
    Then I should see "first" within ".omitteds"

  Scenario: omitted and fandom selected during create
    Given a tag exists with name: "first" AND type: "Fandom"
      And a tag exists with name: "second" AND type: "Omitted"
      And I am on the homepage
      And I select "first" from "fandom"
      And I select "second" from "omitted"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should NOT see "Please select fandom"
      And I should see "first" within ".fandoms"
      And I should see "second" within ".omitteds"

  Scenario: omitted only selected during create
    Given a tag exists with name: "nonfiction" AND type: "Omitted"
      And I am on the homepage
      And I select "nonfiction" from "omitted"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Page created with Other Fandom"
    And I should see "nonfiction" within ".omitteds"

  Scenario: add an omitted to a page when there are no omitteds
    Given a page exists
    When I am on the page's page
      And I edit its tags
    When I fill in "tags" with "nonfiction, audio book"
      And I press "Add Omitted Tags"
    Then I should see "nonfiction" within ".omitteds"
      And I should see "audio book" within ".omitteds"
    When I am on the homepage
    Then I should be able to select "nonfiction" from "Omitted"
    Then I should be able to select "audio book" from "Omitted"

  Scenario: select an omitted for a page when there are omitteds
    Given a tag exists with name: "work in progress" AND type: "Omitted"
    And a page exists
    When I am on the page's page
      And I edit its tags
      And I select "work in progress" from "page_omitted_ids_"
      And I press "Update Tags"
    Then I should see "work in progress" within ".omitteds"

  Scenario: add an omitted to a page which already has omitteds
    Given I have no pages
    And a page exists with omitteds: "nonfiction"
    When I am on the page's page
    Then I should see "nonfiction" within ".omitteds"
    When I edit its tags
      And I fill in "tags" with "audio book, wip"
      And I press "Add Omitted Tags"
    Then I should see "audio book, nonfiction, wip" within ".omitteds"
    When I am on the homepage
    Then I should be able to select "nonfiction" from "Omitted"
      And I should be able to select "audio book" from "Omitted"
      And I should be able to select "wip" from "Omitted"

   Scenario: new parent for an existing page should have the same omitted
    Given I have no pages
    And a page exists with omitteds: "nonfiction"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the page with title "New Parent"
    Then I should see "nonfiction" within ".omitteds"
      But I should NOT see "nonfiction" within "#position_1"
    When I am on the homepage
      Then I should see "New Parent" within "#position_1"
      And I should see "nonfiction" within "#position_1"


 Scenario: list the omitteds
    Given a tag exists
    Given a tag exists with name: "audio book" AND type: "Omitted"
    When I am on the tags page
    Then I should see "Tag 1"
      And I should see "audio book"
    When I follow "audio book"
      Then I should see "Edit tag: audio book"

  Scenario: edit the omitted name
    Given I have no tags
    And a tag exists with name: "fantasy" AND type: "Omitted"
    When I am on the homepage
      Then I should be able to select "fantasy" from "omitted"
    When I am on the edit tag page for "fantasy"
    And I fill in "tag_name" with "speculative fiction"
    And I press "Update"
    When I am on the homepage
      And I should be able to select "speculative fiction" from "omitted"
      But I should NOT be able to select "fantasy" from "omitted"

  Scenario: delete an omitted
    Given a page exists with omitteds: "work in progress"
    When I am on the edit tag page for "work in progress"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no omitteds
    When I am on the homepage
      Then I should NOT see "work in progress"
      But I should see "Page 1"

  Scenario: merge two tags
    Given I have no pages
    And a tag exists with name: "better name" AND type: "Omitted"
      And a page exists with omitteds: "bad name"
    When I am on the edit tag page for "bad name"
      And I select "better name" from "merge"
      And I press "Merge"
    When I am on the page's page
    Then I should NOT see "bad name"
    And I should see "better name" within ".omitteds"

  Scenario: don’t allow merge if not the same type
    Given a tag exists with name: "not omitted"
    Given a tag exists with name: "bad name" AND type: "Omitted"
    When I am on the edit tag page for "bad name"
      Then I should NOT see "not omitted"
      And I should NOT see "Merge"

  Scenario: change omitted to trope tag
    Given I have no pages
    And a page exists with omitteds: "will be visible"
    When I am on the page's page
      Then I should see "will be visible" within ".omitteds"
    When I am on the edit tag page for "will be visible"
      And I select "Trope" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "will be visible" within ".tags"
      And the page should NOT have any omitted tags
    When I am on the homepage
      Then I should be able to select "will be visible" from "tag"
      But I should NOT be able to select "will be visible" from "omitted"

  Scenario: change trope to omitted tag
    Given I have no pages
    And a page exists with tropes: "will be omitted"
    When I am on the page's page
      Then I should see "will be omitted" within ".tags"
    When I am on the edit tag page for "will be omitted"
      And I select "Omitted" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "will be omitted" within ".omitteds"
      And the page should NOT have any not omitted tags
    When I am on the homepage
      Then I should be able to select "will be omitted" from "omitted"
      But I should NOT be able to select "will be omitted" from "tag"

