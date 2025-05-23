Feature: fandoms are a type of tag; at least one fandom must exist per taggable page

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
    And "lmn & 345" should link to "/pages?find=lmn+%26+345"

Scenario: no tags exist during create
  Given I am on the mini page
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should have 0 pages with and 1 without fandoms

Scenario: no tags selected during create
  Given "first" is a "Fandom"
    And I am on the mini page
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should have 0 pages with and 1 without fandoms
    And I should NOT see "first" within ".fandoms"

Scenario: fandom and author tag selected during create
  Given "first" is a "Author"
    And "second" is a "Fandom"
    And I am on the create page
    And I select "first"
    And I select "second"
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should see "Page created."
    And I should have 1 page with and 0 without fandoms
    And I should have 1 page with and 0 without authors
    And I should see "first" within ".authors"
    And I should see "second" within ".fandoms"

Scenario: fandom only selected during create
  Given "nonfiction" is a "Fandom"
    And "something" is a "Pro"
    And I am on the create page
    And I select "nonfiction"
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should have 1 pages with and 0 without fandoms
    And I should have 0 pages with and 1 without authors
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
    And I add a parent with title "New Parent"
    And I am on the page with title "New Parent"
  Then I should see "nonfiction" within ".fandoms"

Scenario: list the fandoms
  Given "Harry Potter" is a "Fandom"
  When I am on the fandoms page
  Then I should see "Harry Potter"

Scenario: edit a fandoms
  Given "Harry Potter" is a "Fandom"
  When I am on the fandoms page
    And I follow "edit Harry Potter"
  Then I should see "Edit tag: Harry Potter"

Scenario: change the fandom name and change base_name
  Given a page exists with fandoms: "fantasy" AND infos: "historical"
    And the tag "historical" is destroyed without caching
  When I am on the edit tag page for "fantasy"
    And I fill in "tag_name" with "speculative fiction"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "speculative fiction" from "fandom"
    And I should NOT see "fantasy"
    And the tag_cache should include "speculative fiction"
    And the tag_cache should NOT include "fantasy"
    And the tag_cache should NOT include "historical"

Scenario: change the fandom name and do not change base_name should not call update_tag_cache
  Given a page exists with fandoms: "fantasy" AND infos: "historical"
    And the tag "historical" is destroyed without caching
  When I am on the edit tag page for "fantasy"
    And I fill in "tag_name" with "fantasy (some other things)"
    And I press "Update"
    And I am on the filter page
  Then I should be able to select "fantasy" from "fandom"
    And I should NOT see "some other things"
    And the tag_cache should include "fantasy"
    But the tag_cache should NOT include "some"
    And the tag_cache should include "historical"

Scenario: show number of pages for fandom
  Given a page exists with fandoms: "Twilight"
  When I am on the edit tag page for "Twilight"
  Then I should see "1 page with that tag"
    And I should have 1 page with and 0 without fandoms

Scenario: deleted fandom removes filter and adds boolean
  Given a page exists with fandoms: "Twilight"
  When I am on the edit tag page for "Twilight"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the filter page
  Then I should NOT be able to select "Twilight" from "fandom"
    And I should have 0 page with and 1 without fandoms

Scenario: deleted fandom moves fandom to notes on page
  Given a page exists with fandoms: "Twilight"
  When I am on the edit tag page for "Twilight"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the page's page
  Then I should see "Twilight" within ".notes"

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
  When I am on the filter page
    And I click on "show_hiddens_none"
    And I press "Find"
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
    And I am on the filter page
    And I click on "show_hiddens_none"
    And I press "Find"
  Then I should have 1 page
    But I should see "No pages found"

