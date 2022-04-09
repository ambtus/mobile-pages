Feature: ratings are a type of tag

Scenario: strip whitespace and sort
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "  xyz &   789,  abc/123,lmn   & 345  "
    And I press "Add Rating Tags"
  Then I should see "abc/123 lmn & 345 xyz & 789" within ".ratings"
    And "abc/123" should link to "/pages?rating=abc%2F123"

Scenario: link to tag on show should find page on index
  Given a page exists with ratings: "lmn123"
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
    And I press "Add Rating Tags"
  Then I should see "abc123" within ".ratings"

Scenario: no tags selected during create
  Given a tag exists with name: "abc123" AND type: "Rating"
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
    And I edit its tags
    And I select "abc123" from "page_rating_ids_"
    And I press "Update Tags"
  Then I should see "abc123" within ".ratings"

Scenario: rating selected during create
  Given a tag exists with name: "abc123" AND type: "Rating"
  When I am on the homepage
    And I select "abc123" from "rating"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "abc123" within ".ratings"

Scenario: comma separated ratings (not & or /)
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "abc & 123, xyz/987"
    And I press "Add Rating Tags"
    And I am on the homepage
  Then I should be able to select "abc & 123" from "Rating"
    And I should be able to select "xyz/987" from "Rating"
    And I should have 2 tags

Scenario: add ratings to a page which already has ratings sorts alphabetically
  Given a page exists with ratings: "lmn123"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "xyz123, abc123"
    And I press "Add Rating Tags"
  Then I should see "abc123 lmn123 xyz123" within ".ratings"

Scenario: new parent for an existing page should have the same rating (not duped)
  Given a page exists with ratings: "abc123"
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "add_parent" with "New Parent"
    And I press "Update"
  Then I should see "abc123" within ".ratings"
    But I should NOT see "abc123" within "#position_1"

Scenario: ratings are editable
  Given a tag exists with name: "abc123" AND type: "Rating"
  When I am on the tags page
    And I follow "abc123"
  Then I should see "Edit tag: abc123"

Scenario: edit the rating name
  Given a tag exists with name: "abc123" AND type: "Rating"
  When I am on the edit tag page for "abc123"
    And I fill in "tag_name" with "xyz987"
    And I press "Update"
    And I am on the homepage
  Then I should be able to select "xyz987" from "rating"
    But I should NOT be able to select "abc123" from "rating"
    And I should have 1 tag

Scenario: delete a rating
  Given a page exists with ratings: "abc123"
  When I am on the edit tag page for "abc123"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the homepage
  Then I should NOT see "abc123"
    But I should see "Page 1"

Scenario: merge two tags
  Given a tag exists with name: "abc123" AND type: "Rating"
    And a page exists with ratings: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should NOT see "xyz987"
    But I should see "abc123" within ".ratings"

Scenario: don’t allow merge if not the same type
  Given a tag exists with name: "abc123"
    And a tag exists with name: "xyz987" AND type: "Rating"
  When I am on the edit tag page for "xyz987"
  Then I should NOT see "abc123"
    And I should NOT see "Merge"

Scenario: change rating to trope tag
  Given a page exists with ratings: "abc123"
  When I am on the edit tag page for "abc123"
    And I select "Trope" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "abc123" within ".tags"

Scenario: change trope to rating tag
  Given a page exists with tropes: "abc123"
  When I am on the edit tag page for "abc123"
    And I select "Rating" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "abc" within ".ratings"
