Feature: cons are a type of tag

Scenario: strip whitespace and sort
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "  xyz &   789,  abc/123,lmn   & 345  "
    And I press "Add Con Tags"
  Then I should see "abc/123 lmn & 345 xyz & 789" within ".cons"
    And "xyz & 789" should link to "/pages?con=xyz+%26+789"

Scenario: link to tag on show should NOT find page on index
  Given a page exists with cons: "lmn123"
    And a page exists with title: "no cons"
  When I am on the page's page
    And I follow "lmn123"
  Then I should NOT see "Page 1" within "#position_1"
    But I should see "no cons" within "#position_1"

Scenario: no tags exist during create
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
    And I edit its tags
    And I fill in "tags" with "abc123"
    And I press "Add Con Tags"
  Then I should see "abc123" within ".cons"

Scenario: no tags selected during create
  Given "abc123" is a "Con"
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
    And I edit its tags
    And I select "abc123" from "page_con_ids_"
    And I press "Update Tags"
  Then I should see "abc123" within ".cons"

Scenario: con selected during create
  Given "abc123" is a "Con"
  When I am on the homepage
    And I select "abc123" from "con"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "abc123" within ".cons"

Scenario: comma separated cons (not & or /)
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "abc & 123, xyz/987"
    And I press "Add Con Tags"
    And I am on the homepage
  Then I should be able to select "abc & 123" from "Con"
    And I should be able to select "xyz/987" from "Con"
    And I should have 2 tags

Scenario: add cons to a page which already has cons sorts alphabetically
  Given a page exists with cons: "lmn123"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "xyz123, abc123"
    And I press "Add Con Tags"
  Then I should see "abc123 lmn123 xyz123" within ".cons"

Scenario: new parent for an existing page should have the same con (not duped)
  Given a page exists with cons: "abc123"
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "add_parent" with "New Parent"
    And I press "Update"
  Then I should see "abc123" within ".cons"
    But I should NOT see "abc123" within "#position_1"

Scenario: cons are editable
  Given "abc123" is a "Con"
  When I am on the tags page
    And I follow "abc123"
  Then I should see "Edit tag: abc123"

Scenario: edit the con name
  Given "abc123" is a "Con"
  When I am on the edit tag page for "abc123"
    And I fill in "tag_name" with "xyz987"
    And I press "Update"
    And I am on the homepage
  Then I should be able to select "xyz987" from "con"
    But I should NOT be able to select "abc123" from "con"
    And I should have 1 tag

Scenario: delete a con
  Given a page exists with cons: "abc123"
  When I am on the edit tag page for "abc123"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the homepage
  Then I should NOT see "abc123"
    But I should see "Page 1"

Scenario: merge two tags
  Given "abc123" is a "Con"
    And a page exists with cons: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should see "abc123 (xyz987)" within ".cons"

Scenario: don’t allow merge if not the same type
  Given "abc123" is a "Pro"
    And "xyz987" is a "Con"
  When I am on the edit tag page for "xyz987"
  Then I should NOT see "abc123"
    And I should NOT see "Merge"

Scenario: change con to pro tag
  Given a page exists with cons: "abc123"
  When I am on the edit tag page for "abc123"
    And I select "Pro" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "abc123" within ".pros"

Scenario: change pro to con tag
  Given a page exists with pros: "abc123"
  When I am on the edit tag page for "abc123"
    And I select "Con" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "abc" within ".cons"
