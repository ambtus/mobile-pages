Feature: hiddens are a type of tag

Scenario: strip whitespace and sort
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "  xyz &   789,  abc/123,lmn   & 345  "
    And I press "Add Hidden Tags"
  Then I should see "abc/123 lmn & 345 xyz & 789" within ".hiddens"
    And "xyz & 789" should link to "/pages?find=xyz+%26+789"
    And the page should be hidden

Scenario: link to tag on show should find page on index
  Given a page exists with hiddens: "lmn123"
  When I am on the page's page
    And I follow "lmn123"
  Then I should see "Page 1" within "#position_1"
    And the page should be hidden

Scenario: no tags exist during create
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
    And I edit its tags
    And I fill in "tags" with "abc123"
    And I press "Add Hidden Tags"
  Then I should see "abc123" within ".hiddens"
    And the page should be hidden

Scenario: no tags selected during create
  Given "abc123" is a "Hidden"
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
    And I edit its tags
    And I select "abc123" from "page_hidden_ids_"
    And I press "Update Tags"
  Then I should see "abc123" within ".hiddens"
    And the page should be hidden

Scenario: hidden selected during create
  Given "abc123" is a "Hidden"
  When I am on the create page
    And I select "abc123" from "hidden"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "abc123" within ".hiddens"
    And the page should be hidden

Scenario: comma separated hiddens (not & or /)
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "abc & 123, xyz/987"
    And I press "Add Hidden Tags"
    And I am on the filter page
  Then I should be able to select "abc & 123" from "Hidden"
    And I should be able to select "xyz/987" from "Hidden"
    And I should have 2 tags
    And the page should be hidden

Scenario: add hiddens to a page which already has hiddens sorts alphabetically
  Given a page exists with hiddens: "lmn123"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "xyz123, abc123"
    And I press "Add Hidden Tags"
  Then I should see "abc123 lmn123 xyz123" within ".hiddens"
    And the page should be hidden

Scenario: new parent for an existing page should be hidden (not duped, so i'm not)
  Given a page exists with hiddens: "abc123"
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "add_parent" with "New Parent"
    And I press "Update"
  Then I should see "abc123" within ".hiddens"
    But I should NOT see "abc123" within "#position_1"
    And "New Parent" should be hidden
    But the page should NOT be hidden

Scenario: hiddens are editable
  Given "abc123" is a "Hidden"
  When I am on the tags page
    And I follow "abc123"
  Then I should see "Edit tag: abc123"

Scenario: edit the hidden name
  Given "abc123" is a "Hidden"
  When I am on the edit tag page for "abc123"
    And I fill in "tag_name" with "xyz987"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "xyz987" from "hidden"
    But I should NOT be able to select "abc123" from "hidden"
    And I should have 1 tag

Scenario: delete a hidden
  Given a page exists with hiddens: "abc123"
  When I am on the edit tag page for "abc123"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the homepage
  Then I should NOT see "abc123"
    But I should see "Page 1"
    And the page should NOT be hidden

Scenario: merge two tags
  Given "abc123" is a "Hidden"
    And a page exists with hiddens: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should see "abc123 (xyz987)" within ".hiddens"
    And the page should be hidden

Scenario: don’t allow merge if not the same type
  Given "abc123" is a "Pro"
    And "xyz987" is a "Hidden"
  When I am on the edit tag page for "xyz987"
  Then I should NOT see "abc123"
    And I should NOT see "Merge"

Scenario: change hidden to con tag
  Given a page exists with hiddens: "abc123"
  When I am on the edit tag page for "abc123"
    And I select "Con" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "abc123" within ".cons"
    And the page should NOT be hidden

Scenario: change con to hidden tag
  Given a page exists with cons: "abc123"
  When I am on the edit tag page for "abc123"
    And I select "Hidden" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "abc" within ".hiddens"
    And the page should be hidden
