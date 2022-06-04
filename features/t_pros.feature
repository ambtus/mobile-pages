Feature: pros are a type of tag

Scenario: strip whitespace and sort
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "  xyz &   789,  abc/123,lmn   & 345  "
    And I press "Add Pro Tags"
  Then I should see "abc/123 lmn & 345 xyz & 789" within ".pros"
    And "abc/123" should link to "/pages?find=abc%2F123"

Scenario: link to tag on show should find page on index
  Given a page exists with pros: "lmn123"
  When I am on the page's page
    And I follow "lmn123"
  Then I should see "Page 1" within "#position_1"

Scenario: no tags exist during create
  Given I am on the mini page
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
    And I edit its tags
    And I fill in "tags" with "abc123"
    And I press "Add Pro Tags"
  Then I should see "abc123" within ".pros"

Scenario: no tags selected during create
  Given "abc123" is a "Pro"
  When I am on the mini page
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
    And I edit its tags
    And I select "abc123" from "page_pro_ids_"
    And I press "Update Tags"
  Then I should see "abc123" within ".pros"

Scenario: pro selected during create
  Given "abc123" is a "Pro"
  When I am on the create page
    And I select "abc123"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "abc123" within ".pros"

Scenario: comma separated pros (not & or /)
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "abc & 123, xyz/987"
    And I press "Add Pro Tags"
    And I am on the filter page
  Then I should be able to select "abc & 123" from "Pro"
    And I should be able to select "xyz/987" from "Pro"
    And I should have 2 tags

Scenario: add pros to a page which already has pros sorts alphabetically
  Given a page exists with pros: "lmn123"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "xyz123, abc123"
    And I press "Add Pro Tags"
  Then I should see "abc123 lmn123 xyz123" within ".pros"

Scenario: new parent for an existing page should have the same pro (not duped)
  Given a page exists with pros: "abc123"
  When I am on the page's page
    And I add a parent with title "New Parent"
  Then I should see "abc123" within ".pros"
    But I should NOT see "abc123" within "#position_1"

Scenario: pros are editable
  Given "abc123" is a "Pro"
  When I am on the tags page
    And I follow "abc123"
  Then I should see "Edit tag: abc123"

Scenario: edit the pro name
  Given "abc123" is a "Pro"
  When I am on the edit tag page for "abc123"
    And I fill in "tag_name" with "xyz987"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "xyz987" from "pro"
    But I should NOT be able to select "abc123" from "pro"
    And I should have 1 tag

Scenario: delete a pro
  Given a page exists with pros: "abc123"
  When I am on the edit tag page for "abc123"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the homepage
  Then I should NOT see "abc123"
    But I should see "Page 1"

Scenario: change pro to con tag
  Given a page exists with pros: "abc123"
  When I am on the edit tag page for "abc123"
    And I select "Con" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "abc123" within ".cons"

Scenario: change con to pro tag
  Given a page exists with cons: "abc123"
  When I am on the edit tag page for "abc123"
    And I select "Pro" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "abc" within ".pros"
