Feature: collections are a type of tag

Scenario: strip whitespace and sort
  Given a page exists
  When I am on the first page's page
    And I edit its tags
    And I fill in "tags" with "  xyz &   789,  abc/123,lmn   & 345  "
    And I press "Add Collection Tags"
  Then I should see "abc/123 lmn & 345 xyz & 789" within ".collections"
    And "abc/123" should link to "/pages?find=abc%2F123"

Scenario: link to tag on show should find page on index
  Given a page exists with collections: "lmn123"
  When I am on the first page's page
    And I follow "lmn123"
  Then I should see "Page 1" within "#position_1"

Scenario: no tags exist during create
  Given I am on the mini page
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I store the page
    And I edit its tags
    And I fill in "tags" with "abc123"
    And I press "Add Collection Tags"
  Then I should see "abc123" within ".collections"

Scenario: no tags selected during create
  Given "abc123" is a "Collection"
  When I am on the mini page
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I store the page
    And I edit its tags
    And I select "abc123" from "page_collection_ids_"
    And I press "Update Tags"
  Then I should see "abc123" within ".collections"

Scenario: collection selected during create
  Given "abc123" is a "Collection"
  When I am on the create single page
    And I select "abc123"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I store the page
  Then I should see "abc123" within ".collections"

Scenario: comma separated collections (not & or /)
  Given a page exists
  When I am on the first page's page
    And I edit its tags
    And I fill in "tags" with "Sam & Dean, Harry/Snape"
    And I press "Add Collection Tags"
    And I am on the filter page
  Then I should be able to select "Sam & Dean" from "Collection"
    And I should be able to select "Harry/Snape" from "Collection"

Scenario: add collections to a page which already has collections sorts alphabetically
  Given a page exists with collections: "lmn123"
  When I am on the first page's page
    And I edit its tags
    And I fill in "tags" with "xyz123, abc123"
    And I press "Add Collection Tags"
  Then I should see "abc123 lmn123 xyz123" within ".collections"

Scenario: collection tags are editable
  Given "abc123" is a "Collection"
  When I am on the tags page
    And I follow "1 Collection"
    Then I should see "edit abc123"

Scenario: edit the collection name
  Given "abc123" is a "Collection"
  When I am on the edit tag page for "abc123"
    And I fill in "tag_name" with "xyz987"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "xyz987" from "collection"
    But I should NOT be able to select "abc123" from "collection"
    And I should have 1 tag

Scenario: delete a collection tag
  Given a page exists with collections: "nobody"
  When I am on the edit tag page for "nobody"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the first page's page
  Then I should NOT see "nobody"

Scenario: change collection to fandom
  Given a page exists with collections: "Harry Potter"
  When I am on the edit tag page for "Harry Potter"
    And I select "Fandom" from "change"
    And I press "Change"
    And I am on the first page's page
  Then I should see "Harry Potter" within ".fandoms"

Scenario: change fandom to collection
  Given a page exists with fandoms: "Harry Potter"
  When I am on the edit tag page for "Harry Potter"
    And I select "Collection" from "change"
    And I press "Change"
    And I am on the first page's page
  Then I should see "Harry Potter" within ".collections"

 Scenario: do not allow collection and fandom tags to have the same base name
  Given a page exists with fandoms: "Harry Potter"
  When I am on the first page's page
    And I edit its tags
    And I fill in "tags" with "harry potter"
    And I press "Add Collection Tags"
  Then I should see "duplicate short name"
    And I should have 1 tag

 Scenario: allow collection and fandom tags to have similar names
  Given a page exists with fandoms: "Harry Potter"
  When I am on the first page's page
    And I edit its tags
    And I fill in "tags" with "Harry"
    And I press "Add Collection Tags"
  Then I should see "Harry" within ".collections"
    And I should have 2 tags

 Scenario: allow collection and fandom tags to have similar names
  Given a page exists with fandoms: "Harry (Potter)"
  When I am on the first page's page
    And I edit its tags
    And I fill in "tags" with "Harry Potter"
    And I press "Add Collection Tags"
  Then I should see "Harry Potter" within ".collections"
    And I should have 2 tags
