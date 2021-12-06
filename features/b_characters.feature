Feature: characters are a type of tag, and can be created and selected like tags

  Scenario: strip character whitespace and sort
    Given a page exists
    When I am on the page's page
      And I edit its tags
      And I fill in "tags" with "  Stiles & the Sheriff,  Stiles/Peter,Peter  & the Sheriff  "
      And I press "Add Character Tags"
    Then I should see "Peter & the Sheriff Stiles & the Sheriff Stiles/Peter" within ".characters"

  Scenario: no tags exist during create
    Given I am on the homepage
      And I have no pages
      And I have no tags
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select fandom"
    When I fill in "tags" with "Jim/Blair"
      And I press "Add Character Tags"
    Then I should see "Jim/Blair" within ".characters"

  Scenario: no tags selected during create
    Given a tag exists with name: "first" AND type: "Character"
      And I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select fandom"
    When I select "first" from "page_character_ids_"
      And I press "Update Tags"
    Then I should see "first" within ".characters"

  Scenario: character and fandom selected during create
    Given a tag exists with name: "first" AND type: "Fandom"
      And a tag exists with name: "second" AND type: "Character"
      And I am on the homepage
      And I select "first" from "fandom"
      And I select "second" from "character"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should NOT see "Please select fandom"
      And I should see "first" within ".fandoms"
      And I should see "second" within ".characters"

  Scenario: character only selected during create
    Given a tag exists with name: "Sam & Dean" AND type: "Character"
      And I am on the homepage
      And I select "Sam & Dean" from "character"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select fandom"
    When I fill in "tags" with "something"
      And I press "Add Fandom Tags"
      Then I should see "Sam & Dean" within ".characters"

  Scenario: add a character to a page when there are no characters
    Given a page exists
    When I am on the page's page
      And I edit its tags
    When I fill in "tags" with "Severus & the Twins, Harry/Snape"
      And I press "Add Character Tags"
    Then I should see "Harry/Snape Severus & the Twins" within ".characters"
    When I am on the homepage
    Then I should be able to select "Severus & the Twins" from "Character"
    Then I should be able to select "Harry/Snape" from "Character"

  Scenario: select a character for a page when there are characters
    Given a tag exists with name: "John/Rodney" AND type: "Character"
    And a page exists
    When I am on the page's page
      And I edit its tags
      And I select "John/Rodney" from "page_character_ids_"
      And I press "Update Tags"
    Then I should see "John/Rodney" within ".characters"

  Scenario: add a character to a page which already has characters
    Given I have no pages
    And a page exists with characters: "John/Rodney"
    When I am on the page's page
    Then I should see "John/Rodney" within ".characters"
    When I edit its tags
      And I fill in "tags" with "John & Teyla, Teyla/Ronan"
      And I press "Add Character Tags"
    Then I should see "John & Teyla John/Rodney Teyla/Ronan" within ".characters"
    When I am on the homepage
    Then I should be able to select "John & Teyla" from "Character"
      And I should be able to select "John/Rodney" from "Character"
      And I should be able to select "Teyla/Ronan" from "Character"

   Scenario: new parent for an existing page should have the same character
    Given I have no pages
    And a page exists with characters: "Peter/Stiles"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the page with title "New Parent"
    Then I should see "Peter/Stiles" within ".characters"
      And I should NOT see "Peter/Stiles" within "#position_1"
    When I am on the homepage
      Then I should see "New Parent" within "#position_1"
    And I should see "Peter/Stiles" within ".tags"

 Scenario: list the characters
    Given a tag exists
    Given a tag exists with name: "twincest" AND type: "Character"
    When I am on the tags page
    Then I should see "Tag 1"
      And I should see "twincest"
    When I follow "twincest"
      Then I should see "Edit tag: twincest"

  Scenario: edit the character name
    Given I have no tags
    And a tag exists with name: "twincest" AND type: "Character"
    When I am on the homepage
      Then I should be able to select "twincest" from "character"
    When I am on the edit tag page for "twincest"
    And I fill in "tag_name" with "Fred/George"
    And I press "Update"
    When I am on the homepage
      And I should be able to select "Fred/George" from "character"
      But I should NOT be able to select "twincest" from "character"

  Scenario: delete a character
    Given a page exists with characters: "nobody"
    When I am on the edit tag page for "nobody"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no characters
    When I am on the homepage
      Then I should NOT see "nobody"
      But I should see "Page 1"

  Scenario: merge two tags
    Given I have no pages
    And a tag exists with name: "Fred/George" AND type: "Character"
      And a page exists with characters: "twincest"
    When I am on the edit tag page for "twincest"
      And I select "Fred/George" from "merge"
      And I press "Merge"
    When I am on the page's page
    Then I should NOT see "twincest"
    And I should see "Fred/George" within ".characters"

  Scenario: don’t allow merge if not the same type
    Given a tag exists with name: "not character"
    Given a tag exists with name: "twincest" AND type: "Character"
    When I am on the edit tag page for "twincest"
      Then I should NOT see "not character"
      And I should NOT see "Merge"

  Scenario: change character to fandom tag
    Given I have no pages
    And a page exists with characters: "Harry Potter"
    When I am on the page's page
      Then I should see "Harry Potter" within ".characters"
    When I am on the edit tag page for "Harry Potter"
      And I select "Fandom" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "Harry Potter" within ".fandoms"
      And the page should NOT have any character tags
    When I am on the homepage
      Then I should be able to select "Harry Potter" from "fandom"
      But I should NOT be able to select "Harry Potter" from "character"

  Scenario: change trope to character tag
    Given I have no pages
    And a page exists with tropes: "snarry"
    When I am on the page's page
      Then I should see "snarry" within ".tags"
    When I am on the edit tag page for "snarry"
      And I select "Character" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "snarry" within ".characters"
      And the page should NOT have any not character tags
    When I am on the homepage
      Then I should be able to select "snarry" from "character"
      But I should NOT be able to select "snarry" from "tag"

