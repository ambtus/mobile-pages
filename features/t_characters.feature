Feature: characters are a type of tag

Scenario: strip whitespace and sort
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "  xyz &   789,  abc/123,lmn   & 345  "
    And I press "Add Character Tags"
  Then I should see "abc/123 lmn & 345 xyz & 789" within ".characters"
    And "abc/123" should link to "/pages?character=abc%2F123"

Scenario: link to tag on show should find page on index
  Given a page exists with characters: "lmn123"
  When I am on the page's page
    And I follow "lmn123"
  Then I should see "Page 1" within "#position_1"

Scenario: no tags exist during create
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
    And I edit its tags
    And I fill in "tags" with "abc123"
    And I press "Add Character Tags"
  Then I should see "abc123" within ".characters"

Scenario: no tags selected during create
  Given a tag exists with name: "abc123" AND type: "Character"
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
    And I edit its tags
    And I select "abc123" from "page_character_ids_"
    And I press "Update Tags"
  Then I should see "abc123" within ".characters"

Scenario: character selected during create
  Given a tag exists with name: "abc123" AND type: "Character"
  When I am on the homepage
    And I select "abc123" from "character"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "abc123" within ".characters"

Scenario: comma separated characters (not & or /)
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "Sam & Dean, Harry/Snape"
    And I press "Add Character Tags"
    And I am on the homepage
  Then I should be able to select "Sam & Dean" from "Character"
    And I should be able to select "Harry/Snape" from "Character"

Scenario: add characters to a page which already has characters sorts alphabetically
  Given a page exists with characters: "lmn123"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "xyz123, abc123"
    And I press "Add Character Tags"
  Then I should see "abc123 lmn123 xyz123" within ".characters"

 Scenario: new parent for an existing page should have the same character (no dupes)
  Given a page exists with characters: "abc123"
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "add_parent" with "New Parent"
    And I press "Update"
  When I am on the page with title "New Parent"
  Then I should see "abc123" within ".characters"
    And I should NOT see "abc123" within "#position_1"

Scenario: character tags are editable
  Given a tag exists with name: "abc123" AND type: "Character"
  When I am on the tags page
    And I follow "abc123"
    Then I should see "Edit tag: abc123"

Scenario: edit the character name
  Given a tag exists with name: "abc123" AND type: "Character"
  When I am on the edit tag page for "abc123"
    And I fill in "tag_name" with "xyz987"
    And I press "Update"
    And I am on the homepage
  Then I should be able to select "xyz987" from "character"
    But I should NOT be able to select "abc123" from "character"
    And I should have 1 tag

Scenario: delete a character tag
  Given a page exists with characters: "nobody"
  When I am on the edit tag page for "nobody"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the page's page
  Then I should NOT see "nobody"
    And I should have no characters

Scenario: merge two tags
  Given a tag exists with name: "abc123" AND type: "Character"
    And a page exists with characters: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should NOT see "xyz987"
    And I should see "abc123" within ".characters"

Scenario: don’t allow merge if not the same type
  Given a tag exists with name: "abc123"
    And a page exists with characters: "xyz987"
  When I am on the edit tag page for "xyz987"
    Then I should NOT see "abc123"
    And I should NOT see "Merge"

Scenario: change character to fandom
  Given a page exists with characters: "Harry Potter"
  When I am on the edit tag page for "Harry Potter"
    And I select "Fandom" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "Harry Potter" within ".fandoms"
    And I should have no characters

Scenario: change fandom to character
  Given a page exists with fandoms: "Harry Potter"
  When I am on the edit tag page for "Harry Potter"
    And I select "Character" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "Harry Potter" within ".characters"

 Scenario: allow character and fandom tags to have the same name
  Given a page exists with fandoms: "Harry Potter" AND characters: "Harry Potter"
  When I am on the page's page
  Then I should see "Harry Potter" within ".fandoms"
    And I should see "Harry Potter" within ".characters"
    And I should have 2 tags
