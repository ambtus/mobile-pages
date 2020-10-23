Feature: relationships are a type of tag, and can be created and selected like tags

  Scenario: strip relationship whitespace and sort
    Given a page exists
    When I am on the page's page
      And I edit its tags
      And I fill in "tags" with "  Stiles & the Sheriff,  Stiles/Peter,Peter  & the Sheriff  "
      And I press "Add Relationship Tags"
    Then I should see "Peter & the Sheriff Stiles & the Sheriff Stiles/Peter" within ".relationships"

  Scenario: no tags exist during create
    Given I am on the homepage
      And I have no pages
      And I have no tags
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select fandom"
    When I fill in "tags" with "Jim/Blair"
      And I press "Add Relationship Tags"
    Then I should see "Jim/Blair" within ".relationships"

  Scenario: no tags selected during create
    Given a tag exists with name: "first" AND type: "Relationship"
      And I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select fandom"
    When I select "first" from "page_relationship_ids_"
      And I press "Update Tags"
    Then I should see "first" within ".relationships"

  Scenario: relationship and fandom selected during create
    Given a tag exists with name: "first" AND type: "Fandom"
      And a tag exists with name: "second" AND type: "Relationship"
      And I am on the homepage
      And I select "first" from "fandom"
      And I select "second" from "relationship"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should NOT see "Please select fandom"
      And I should see "first" within ".fandoms"
      And I should see "second" within ".relationships"

  Scenario: relationship only selected during create
    Given a tag exists with name: "Sam & Dean" AND type: "Relationship"
      And I am on the homepage
      And I select "Sam & Dean" from "relationship"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select fandom"
    When I fill in "tags" with "something"
      And I press "Add Fandom Tags"
      Then I should see "Sam & Dean" within ".relationships"

  Scenario: add a relationship to a page when there are no relationships
    Given a page exists
    When I am on the page's page
      And I edit its tags
    When I fill in "tags" with "Severus & the Twins, Harry/Snape"
      And I press "Add Relationship Tags"
    Then I should see "Harry/Snape Severus & the Twins" within ".relationships"
    When I am on the homepage
    Then I should be able to select "Severus & the Twins" from "Relationship"
    Then I should be able to select "Harry/Snape" from "Relationship"

  Scenario: select a relationship for a page when there are relationships
    Given a tag exists with name: "John/Rodney" AND type: "Relationship"
    And a page exists
    When I am on the page's page
      And I edit its tags
      And I select "John/Rodney" from "page_relationship_ids_"
      And I press "Update Tags"
    Then I should see "John/Rodney" within ".relationships"

  Scenario: add a relationship to a page which already has relationships
    Given I have no pages
    And a page exists with relationships: "John/Rodney"
    When I am on the page's page
    Then I should see "John/Rodney" within ".relationships"
    When I edit its tags
      And I fill in "tags" with "John & Teyla, Teyla/Ronan"
      And I press "Add Relationship Tags"
    Then I should see "John & Teyla John/Rodney Teyla/Ronan" within ".relationships"
    When I am on the homepage
    Then I should be able to select "John & Teyla" from "Relationship"
      And I should be able to select "John/Rodney" from "Relationship"
      And I should be able to select "Teyla/Ronan" from "Relationship"

   Scenario: new parent for an existing page should NOT have the same relationship
    Given I have no pages
    And a page exists with relationships: "Peter/Stiles"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the page with title "New Parent"
    Then I should NOT see "Peter/Stiles" within ".relationships"
      But I should see "(Peter/Stiles)" within "#position_1"
    When I am on the homepage
      Then I should see "New Parent" within "#position_1"
    But I should NOT see "Peter/Stiles" within ".tags"

 Scenario: list the relationships
    Given a tag exists
    Given a tag exists with name: "twincest" AND type: "Relationship"
    When I am on the tags page
    Then I should see "Tag 1"
      And I should see "twincest"
    When I follow "twincest"
      Then I should see "Edit tag: twincest"

  Scenario: edit the relationship name
    Given I have no tags
    And a tag exists with name: "twincest" AND type: "Relationship"
    When I am on the homepage
      Then I should be able to select "twincest" from "relationship"
    When I am on the edit tag page for "twincest"
    And I fill in "tag_name" with "Fred/George"
    And I press "Update"
    When I am on the homepage
      And I should be able to select "Fred/George" from "relationship"
      But I should NOT be able to select "twincest" from "relationship"

  Scenario: delete a relationship
    Given a page exists with relationships: "nobody"
    When I am on the edit tag page for "nobody"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no relationships
    When I am on the homepage
      Then I should NOT see "nobody"
      But I should see "Page 1"

  Scenario: merge two tags
    Given I have no pages
    And a tag exists with name: "Fred/George" AND type: "Relationship"
      And a page exists with relationships: "twincest"
    When I am on the edit tag page for "twincest"
      And I select "Fred/George" from "merge"
      And I press "Merge"
    When I am on the page's page
    Then I should NOT see "twincest"
    And I should see "Fred/George" within ".relationships"

  Scenario: don’t allow merge if not the same type
    Given a tag exists with name: "not relationship"
    Given a tag exists with name: "twincest" AND type: "Relationship"
    When I am on the edit tag page for "twincest"
      Then I should NOT see "not relationship"
      And I should NOT see "Merge"

  Scenario: change relationship to fandom tag
    Given I have no pages
    And a page exists with relationships: "Harry Potter"
    When I am on the page's page
      Then I should see "Harry Potter" within ".relationships"
    When I am on the edit tag page for "Harry Potter"
      And I select "Fandom" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "Harry Potter" within ".fandoms"
      And the page should NOT have any relationship tags
    When I am on the homepage
      Then I should be able to select "Harry Potter" from "fandom"
      But I should NOT be able to select "Harry Potter" from "relationship"

  Scenario: change trope to relationship tag
    Given I have no pages
    And a page exists with tropes: "snarry"
    When I am on the page's page
      Then I should see "snarry" within ".tags"
    When I am on the edit tag page for "snarry"
      And I select "Relationship" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "snarry" within ".relationships"
      And the page should NOT have any not relationship tags
    When I am on the homepage
      Then I should be able to select "snarry" from "relationship"
      But I should NOT be able to select "snarry" from "tag"

