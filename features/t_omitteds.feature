Feature: omitteds are a type of tag

Scenario: strip whitespace and sort
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "  xyz &   789,  abc/123,lmn   & 345  "
    And I press "Add Omitted Tags"
  Then I should see "abc/123 lmn & 345 xyz & 789" within ".omitteds"
    And "xyz & 789" should link to "/pages?omitted=xyz+%26+789"

Scenario: link to tag on show should NOT find page on index
  Given a page exists with omitteds: "lmn123"
    And a page exists with title: "no omitteds"
  When I am on the page's page
    And I follow "lmn123"
  Then I should NOT see "Page 1" within "#position_1"
    But I should see "no omitteds" within "#position_1"

Scenario: no tags exist during create
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
    And I edit its tags
    And I fill in "tags" with "abc123"
    And I press "Add Omitted Tags"
  Then I should see "abc123" within ".omitteds"

Scenario: no tags selected during create
  Given a tag exists with name: "abc123" AND type: "Omitted"
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
    And I edit its tags
    And I select "abc123" from "page_omitted_ids_"
    And I press "Update Tags"
  Then I should see "abc123" within ".omitteds"

Scenario: omitted selected during create
  Given a tag exists with name: "abc123" AND type: "Omitted"
  When I am on the homepage
    And I select "abc123" from "omitted"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "abc123" within ".omitteds"

Scenario: comma separated omitteds (not & or /)
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "abc & 123, xyz/987"
    And I press "Add Omitted Tags"
    And I am on the homepage
  Then I should be able to select "abc & 123" from "Omitted"
    And I should be able to select "xyz/987" from "Omitted"
    And I should have 2 tags

Scenario: add omitteds to a page which already has omitteds sorts alphabetically
  Given a page exists with omitteds: "lmn123"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "xyz123, abc123"
    And I press "Add Omitted Tags"
  Then I should see "abc123 lmn123 xyz123" within ".omitteds"

Scenario: new parent for an existing page should have the same omitted (not duped)
  Given a page exists with omitteds: "abc123"
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "add_parent" with "New Parent"
    And I press "Update"
  Then I should see "abc123" within ".omitteds"
    But I should NOT see "abc123" within "#position_1"

Scenario: omitteds are editable
  Given a tag exists with name: "abc123" AND type: "Omitted"
  When I am on the tags page
    And I follow "abc123"
  Then I should see "Edit tag: abc123"

Scenario: edit the omitted name
  Given a tag exists with name: "abc123" AND type: "Omitted"
  When I am on the edit tag page for "abc123"
    And I fill in "tag_name" with "xyz987"
    And I press "Update"
    And I am on the homepage
  Then I should be able to select "xyz987" from "omitted"
    But I should NOT be able to select "abc123" from "omitted"
    And I should have 1 tag

Scenario: delete a omitted
  Given a page exists with omitteds: "abc123"
  When I am on the edit tag page for "abc123"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the homepage
  Then I should NOT see "abc123"
    But I should see "Page 1"
    And I should have no omitteds

Scenario: merge two tags
  Given a tag exists with name: "abc123" AND type: "Omitted"
    And a page exists with omitteds: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should NOT see "xyz987"
    But I should see "abc123" within ".omitteds"

Scenario: don’t allow merge if not the same type
  Given a tag exists with name: "abc123"
    And a tag exists with name: "xyz987" AND type: "Omitted"
  When I am on the edit tag page for "xyz987"
  Then I should NOT see "abc123"
    And I should NOT see "Merge"

Scenario: change omitted to trope tag
  Given a page exists with omitteds: "abc123"
  When I am on the edit tag page for "abc123"
    And I select "Trope" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "abc123" within ".tags"
    And I should have no omitteds

Scenario: change trope to omitted tag
  Given a page exists with tropes: "abc123"
  When I am on the edit tag page for "abc123"
    And I select "Omitted" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "abc" within ".omitteds"
