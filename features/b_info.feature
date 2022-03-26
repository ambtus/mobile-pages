Feature: infos are a type of tag

  Scenario: strip info whitespace and sort
    Given a page exists
    When I am on the page's page
      And I edit its tags
      And I fill in "tags" with "  bowlderize,  add   formatting,send  feedback  "
      And I press "Add Info Tags"
    Then I should see "add formatting, bowlderize, send feedback" within ".info"

  Scenario: no tags exist during create
    Given I am on the homepage
      And I have no pages
      And I have no tags
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Page created with Other Fandom"
    When I edit its tags
      And I fill in "tags" with "fix me"
      And I press "Add Info Tags"
    Then I should see "fix me" within ".info"

  Scenario: no tags selected during create
    Given a tag exists with name: "first" AND type: "Info"
      And I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Page created with Other Fandom"
    When I edit its tags
      And I select "first" from "page_info_ids_"
      And I press "Update Tags"
    Then I should see "first" within ".info"

  Scenario: info and fandom selected during create
    Given a tag exists with name: "first" AND type: "Fandom"
      And a tag exists with name: "second" AND type: "Info"
      And I am on the homepage
      And I select "first" from "fandom"
      And I select "second" from "info"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Page created."
      And I should see "first" within ".fandoms"
      And I should see "second" within ".info"

  Scenario: info only selected during create
    Given a tag exists with name: "bowlderize" AND type: "Info"
      And I am on the homepage
      And I select "bowlderize" from "info"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Page created with Other Fandom"
      And I should see "bowlderize" within ".info"

  Scenario: add a info to a page when there are no infos
    Given a page exists
    When I am on the page's page
      And I edit its tags
    When I fill in "tags" with "bowlderize, add formatting"
      And I press "Add Info Tags"
    Then I should see "bowlderize" within ".info"
      And I should see "add formatting" within ".info"
    When I am on the homepage
    Then I should be able to select "bowlderize" from "Info"
    Then I should be able to select "add formatting" from "Info"

  Scenario: select a info for a page when there are infos
    Given a tag exists with name: "split" AND type: "Info"
    And a page exists
    When I am on the page's page
      And I edit its tags
      And I select "split" from "page_info_ids_"
      And I press "Update Tags"
    Then I should see "split" within ".info"

  Scenario: add a info to a page which already has infos
    Given I have no pages
    And a page exists with infos: "bowlderize"
    When I am on the page's page
    Then I should see "bowlderize" within ".info"
    When I edit its tags
      And I fill in "tags" with "add formatting, downloaded"
      And I press "Add Info Tags"
    Then I should see "add formatting, bowlderize, downloaded" within ".info"
    When I am on the homepage
    Then I should be able to select "bowlderize" from "Info"
      And I should be able to select "add formatting" from "Info"
      And I should be able to select "downloaded" from "Info"

   Scenario: new parent for an existing page should have the same info
    Given I have no pages
    And a page exists with infos: "bowlderize"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the page with title "New Parent"
    Then I should see "bowlderize" within ".info"
      But I should NOT see "bowlderize" within "#position_1"
    When I am on the homepage
      Then I should see "New Parent" within "#position_1"
      And I should see "bowlderize" within ".tags"

 Scenario: list the infos
    Given a tag exists
    Given a tag exists with name: "add formatting" AND type: "Info"
    When I am on the tags page
    Then I should see "Tag 1"
      And I should see "add formatting"
    When I follow "add formatting"
      Then I should see "Edit tag: add formatting"

  Scenario: edit the info name
    Given I have no tags
    And a tag exists with name: "read_now" AND type: "Info"
    When I am on the homepage
      Then I should be able to select "read_now" from "info"
    When I am on the edit tag page for "read_now"
    And I fill in "tag_name" with "read now"
    And I press "Update"
    When I am on the homepage
      And I should be able to select "read now" from "info"
      But I should NOT be able to select "read_now" from "info"

  Scenario: delete an info
    Given a page exists with infos: "split"
    When I am on the edit tag page for "split"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no infos
    When I am on the homepage
      Then I should NOT see "split"
      But I should see "Page 1"

  Scenario: merge two tags
    Given I have no pages
    And a tag exists with name: "better name" AND type: "Info"
      And a page exists with infos: "bad name"
    When I am on the edit tag page for "bad name"
      And I select "better name" from "merge"
      And I press "Merge"
    When I am on the page's page
    Then I should NOT see "bad name"
    And I should see "better name" within ".info"

  Scenario: don’t allow merge if not the same type
    Given a tag exists with name: "not info"
    Given a tag exists with name: "bad name" AND type: "Info"
    When I am on the edit tag page for "bad name"
      Then I should NOT see "not info"
      And I should NOT see "Merge"

  Scenario: change info to trope tag
    Given I have no pages
    And a page exists with infos: "will be visible"
    When I am on the page's page
      Then I should see "will be visible" within ".info"
    When I am on the edit tag page for "will be visible"
      And I select "Trope" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "will be visible" within ".tags"
      And the page should NOT have any info tags
    When I am on the homepage
      Then I should be able to select "will be visible" from "tag"
      But I should NOT be able to select "will be visible" from "info"

  Scenario: change trope to info tag
    Given I have no pages
    And a page exists with tropes: "will be info"
    When I am on the page's page
      Then I should see "will be info" within ".tags"
    When I am on the edit tag page for "will be info"
      And I select "Info" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "will be info" within ".info"
      And the page should NOT have any not info tags
    When I am on the homepage
      Then I should be able to select "will be info" from "info"
      But I should NOT be able to select "will be info" from "tag"

