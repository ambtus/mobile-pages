Feature: infos are a type of tag

Scenario: strip whitespace and sort
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "  xyz &   789,  abc/123,lmn   & 345  "
    And I press "Add Info Tags"
  Then I should see "abc/123 lmn & 345 xyz & 789" within ".infos"
    And "abc/123" should link to "/pages?info=abc%2F123"

Scenario: link to tag on show should find page on index
  Given a page exists with infos: "lmn123"
  When I am on the page's page
    And I follow "lmn123"
  Then I should see "Page 1" within "#position_1"

Scenario: no tags exist during create
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
    And I edit its tags
    And I fill in "tags" with "abc123"
    And I press "Add Info Tags"
  Then I should see "abc123" within ".infos"

Scenario: no tags selected during create
  Given "abc123" is an "Info"
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
    And I edit its tags
    And I select "abc123" from "page_info_ids_"
    And I press "Update Tags"
  Then I should see "abc123" within ".infos"

Scenario: info selected during create
  Given "abc123" is an "Info"
  When I am on the create page
    And I select "abc123" from "info"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "abc123" within ".infos"

Scenario: comma separated infos (not & or /)
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "Sam & Dean, Harry/Snape"
    And I press "Add Info Tags"
    And I am on the filter page
  Then I should be able to select "Sam & Dean" from "Info"
    And I should be able to select "Harry/Snape" from "Info"

Scenario: add infos to a page which already has infos sorts alphabetically
  Given a page exists with infos: "lmn123"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "xyz123, abc123"
    And I press "Add Info Tags"
  Then I should see "abc123 lmn123 xyz123" within ".infos"

 Scenario: new parent for an existing page should have the same info (no dupes)
  Given a page exists with infos: "abc123"
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "add_parent" with "New Parent"
    And I press "Update"
  When I am on the page with title "New Parent"
  Then I should see "abc123" within ".infos"
    And I should NOT see "abc123" within "#position_1"

Scenario: info tags are editable
  Given "abc123" is an "Info"
  When I am on the tags page
    And I follow "abc123"
    Then I should see "Edit tag: abc123"

Scenario: edit the info name
  Given "abc123" is an "Info"
  When I am on the edit tag page for "abc123"
    And I fill in "tag_name" with "xyz987"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "xyz987" from "info"
    But I should NOT be able to select "abc123" from "info"
    And I should have 1 tag

Scenario: delete a info tag
  Given a page exists with infos: "nobody"
  When I am on the edit tag page for "nobody"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the page's page
  Then I should NOT see "nobody"

Scenario: merge two tags
  Given "abc123" is an "Info"
    And a page exists with infos: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should see "abc123 (xyz987)" within ".infos"

Scenario: don’t allow merge if not the same type
  Given "abc123" is a "Pro"
    And a page exists with infos: "xyz987"
  When I am on the edit tag page for "xyz987"
    Then I should NOT see "abc123"
    And I should NOT see "Merge"

Scenario: change info to fandom
  Given a page exists with infos: "Harry Potter"
  When I am on the edit tag page for "Harry Potter"
    And I select "Fandom" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "Harry Potter" within ".fandoms"

Scenario: change fandom to info
  Given a page exists with fandoms: "Harry Potter"
  When I am on the edit tag page for "Harry Potter"
    And I select "Info" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "Harry Potter" within ".infos"

 Scenario: allow info and fandom tags to have the same name
  Given a page exists with fandoms: "Harry Potter" AND infos: "Harry Potter"
  When I am on the page's page
  Then I should see "Harry Potter" within ".fandoms"
    And I should see "Harry Potter" within ".infos"
    And I should have 2 tags
