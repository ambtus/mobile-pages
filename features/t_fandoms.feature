Feature: fandoms are a type of tag, and can be created and selected like tags

Scenario: fandom tag not in other tag dropdown
  Given "not fandom" is a "Pro"
    And "yes fandom" is a "Fandom"
  When I am on the filter page
  Then I should NOT be able to select "yes fandom" from "tag"
    But I should be able to select "yes fandom" from "fandom"
    And I should be able to select "not fandom" from "pro"

Scenario: link to tag on show should find page on index
  Given a page exists with fandoms: "lmn123"
  When I am on the page's page
    And I follow "lmn123"
  Then I should see "Page 1" within "#position_1"

Scenario: strip fandom whitespace and sort
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "  xyz &   789,  abc/123,lmn   & 345  "
    And I press "Add Fandom Tags"
  Then I should see "abc/123 lmn & 345 xyz & 789" within ".fandoms"
    And "lmn & 345" should link to "/pages?fandom=lmn+%26+345"

Scenario: no tags exist during create
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should see "Page created with Other Fandom"
    And I should see "Other Fandom" within ".fandoms"

Scenario: no tags selected during create
  Given "first" is a "Fandom"
    And I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should see "Page created with Other Fandom"
    And I should see "Other Fandom" within ".fandoms"
    And I should NOT see "first" within ".fandoms"

Scenario: fandom and other tag selected during create
  Given "first" is a "Pro"
    And "second" is a "Fandom"
    And I am on the create page
    And I select "first" from "pro"
    And I select "second" from "fandom"
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should NOT see "Page created with Other Fandom"
    But I should see "Page created."
    And I should see "first" within ".pros"
    And I should see "second" within ".fandoms"

Scenario: fandom only selected during create
  Given "nonfiction" is a "Fandom"
    And "something" is a "Pro"
    And I am on the create page
    And I select "nonfiction" from "fandom"
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should NOT see "Page created with Other Fandom"
    But I should see "Page created."
    And I should see "nonfiction" within ".fandoms"

Scenario: add a fandom to a page when there are no fandoms
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "Star Wars, Harry Potter"
    And I press "Add Fandom Tags"
  Then I should see "Harry Potter Star Wars" within ".fandoms"

Scenario: add a fandom to a page makes the fandom selectable
  Given a page exists
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "Star Wars, Harry Potter"
    And I press "Add Fandom Tags"
    And I am on the filter page
  Then I should be able to select "Star Wars" from "Fandom"
    And I should be able to select "Harry Potter" from "Fandom"

Scenario: select a fandom for a page when there are fandoms
  Given "SGA" is a "Fandom"
    And a page exists
  When I am on the page's page
    And I edit its tags
    And I select "SGA" from "page_fandom_ids_"
    And I press "Update Tags"
  Then I should see "SGA" within ".fandoms"

Scenario: page which already has fandoms should display them
  Given a page exists with fandoms: "nonfiction"
  When I am on the page's page
  Then I should see "nonfiction" within ".fandoms"

Scenario: add another fandom to a page
  Given a page exists with fandoms: "nonfiction"
  When I am on the page's page
    And I edit its tags
    And I fill in "tags" with "meta, reviews"
    And I press "Add Fandom Tags"
  Then I should see "meta nonfiction reviews" within ".fandoms"

Scenario: add another fandom to a page makes the fandom selectable
  Given a page exists with fandoms: "nonfiction"
    And I am on the page's page
    And I edit its tags
    And I fill in "tags" with "meta, reviews"
    And I press "Add Fandom Tags"
  When I am on the filter page
  Then I should be able to select "meta" from "Fandom"
    And I should be able to select "reviews" from "Fandom"

Scenario: new parent for an existing page should have the same fandom
  Given a page exists with fandoms: "nonfiction"
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "add_parent" with "New Parent"
    And I press "Update"
    And I am on the page with title "New Parent"
  Then I should see "nonfiction" within ".fandoms"

 Scenario: new parent for an existing page should move the fandom
  Given a page exists with fandoms: "nonfiction"
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "add_parent" with "New Parent"
    And I press "Update"
  Then I should see "nonfiction" within ".fandoms"
    And I should see "Page 1" within ".parts"
    But I should NOT see "nonfiction" within ".parts"

Scenario: list the fandoms
  Given "Harry Potter" is a "Fandom"
  When I am on the tags page
  Then I should see "Harry Potter"

Scenario: edit a fandoms
  Given "Harry Potter" is a "Fandom"
  When I am on the tags page
    And I follow "Harry Potter"
  Then I should see "Edit tag: Harry Potter"

Scenario: change the fandom name
  Given "fantasy" is a "Fandom"
  When I am on the edit tag page for "fantasy"
    And I fill in "tag_name" with "speculative fiction"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "speculative fiction" from "fandom"
    And I should NOT see "fantasy"

Scenario: show number of pages for fandom
  Given a page exists with fandoms: "Twilight"
  When I am on the edit tag page for "Twilight"
  Then I should see "1 page with that tag"

Scenario: deleted fandom creates Other Fandom (filter)
  Given a page exists with fandoms: "Twilight"
  When I am on the edit tag page for "Twilight"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the filter page
  Then I should NOT be able to select "Twilight" from "fandom"
    But I should be able to select "Other Fandom" from "fandom"

Scenario: deleted fandom creates Other Fandom (index)
  Given a page exists with fandoms: "Twilight"
  When I am on the edit tag page for "Twilight"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the homepage
    And I follow "Page 1"
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Twilight" within ".notes"

Scenario: deleted fandom puts moves fandom to other fandom on page
  Given a page exists with fandoms: "Twilight"
  When I am on the edit tag page for "Twilight"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the page's page
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Twilight" within ".notes"

Scenario: merge two tags
  Given "abc123" is a "Fandom"
    And a page exists with fandoms: "xyz987"
  When I am on the edit tag page for "xyz987"
    And I select "abc123" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should see "abc123 (xyz987)" within ".fandoms"

Scenario: don’t allow merge if not the same type
  Given "not fandom" is a "Pro"
    And "bad name" is a "Fandom"
  When I am on the edit tag page for "bad name"
  Then I should NOT see "not fandom"
    And I should NOT see "Merge"

Scenario: change fandom to pro tag part 1
  Given a page exists with fandoms: "not a fandom"
  When I am on the page's page
  Then I should see "not a fandom" within ".fandoms"
    But I should NOT see "not a fandom" within ".pros"

Scenario: change fandom to pro tag part 2
  Given a page exists with fandoms: "not a fandom"
  When I am on the edit tag page for "not a fandom"
  Then "Fandom" should be selected in "change"

Scenario: change fandom to pro tag part 3
  Given a page exists with fandoms: "not a fandom"
  When I am on the edit tag page for "not a fandom"
    And I select "Pro" from "change"
    And I press "Change"
    And I am on the page's page
 Then I should see "not a fandom" within ".pros"

Scenario: change fandom to pro tag part 4
  Given a page exists with fandoms: "not a fandom"
  When I am on the edit tag page for "not a fandom"
    And I select "Pro" from "change"
    And I press "Change"
    And I am on the filter page
  Then I should be able to select "not a fandom" from "pro"
    But I should NOT be able to select "not a fandom" from "fandom"

Scenario: change pro to fandom tag part 1
  Given a page exists with pros: "will be fandom"
  When I am on the page's page
  Then I should see "will be fandom" within ".pros"
    But I should NOT see "will be a fandom" within ".fandoms"

Scenario: change pro to fandom tag part 2
  Given a page exists with pros: "will be fandom"
  When I am on the edit tag page for "will be fandom"
  Then "Pro" should be selected in "change"

Scenario: change pro to fandom tag part 3
  Given a page exists with pros: "will be fandom"
  When I am on the edit tag page for "will be fandom"
    And I select "Fandom" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "will be fandom" within ".fandoms"
    But I should NOT see "will be a fandom" within ".pros"

Scenario: change pro to fandom tag part 4
  Given a page exists with pros: "will be fandom"
  When I am on the edit tag page for "will be fandom"
    And I select "Fandom" from "change"
    And I press "Change"
    And I am on the filter page
  Then I should be able to select "will be fandom" from "fandom"
    But I should NOT be able to select "will be fandom" from "tag"

Scenario: change hidden to fandom tag part 1
  Given a page exists with hiddens: "will be visible"
  When I am on the homepage
  Then I should have 1 page
    But I should see "No pages found"

Scenario: change hidden to fandom tag part 2
  Given a page exists with hiddens: "will be visible"
  When I am on the page's page
  Then I should see "will be visible" within ".hiddens"
    But I should NOT see "will be visible" within ".fandoms"

Scenario: change hidden to fandom tag part 3
  Given a page exists with hiddens: "will be visible"
  When I am on the edit tag page for "will be visible"
  Then "Hidden" should be selected in "change"

Scenario: change hidden to fandom tag part 4
  Given a page exists with hiddens: "will be visible"
  When I am on the edit tag page for "will be visible"
    And I select "Fandom" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "will be visible" within ".fandoms"

Scenario: change hidden to fandom tag part 5
  Given a page exists with hiddens: "will be visible"
  When I am on the edit tag page for "will be visible"
    And I select "Fandom" from "change"
    And I press "Change"
    And I am on the homepage
  Then I should NOT see "No pages found"
    And I should see "will be visible" within "#position_1"

Scenario: change fandom to hidden tag part 1
  Given a page exists with fandoms: "will be hidden"
  When I am on the page's page
  Then I should see "will be hidden" within ".fandoms"

Scenario: change fandom to hidden tag part 2
  Given a page exists with fandoms: "will be hidden"
  When I am on the edit tag page for "will be hidden"
  Then "Fandom" should be selected in "change"

Scenario: change fandom to hidden tag part 3
  Given a page exists with fandoms: "will be hidden"
  When I am on the edit tag page for "will be hidden"
    And I select "Hidden" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "will be hidden" within ".hiddens"
    But I should NOT see "will be hidden" within ".fandoms"

Scenario: change fandom to hidden tag part 4
  Given a page exists with fandoms: "will be hidden"
  When I am on the edit tag page for "will be hidden"
    And I select "Hidden" from "change"
    And I press "Change"
    And I am on the homepage
  Then I should have 1 page
    But I should see "No pages found"

