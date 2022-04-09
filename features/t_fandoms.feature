Feature: fandoms are a type of tag, and can be created and selected like tags

Scenario: fandom tag not in tag dropdown
  Given a tag exists with name: "not fandom"
    And a tag exists with name: "yes fandom" AND type: "Fandom"
  When I am on the homepage
  Then I should NOT be able to select "yes fandom" from "tag"
    But I should be able to select "yes fandom" from "fandom"
    And I should be able to select "not fandom" from "tag"

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
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "Page created with Other Fandom"
    And I should see "Other Fandom" within ".fandoms"

Scenario: no tags selected during create
  Given a tag exists with name: "first" AND type: "Fandom"
    And I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should see "Page created with Other Fandom"
    And I should see "Other Fandom" within ".fandoms"
    And I should NOT see "first" within ".fandoms"

Scenario: fandom and other tag selected during create
  Given a tag exists with name: "first"
    And a tag exists with name: "second" AND type: "Fandom"
    And I am on the homepage
    And I select "first" from "tag"
    And I select "second" from "fandom"
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
    And I press "Store"
  Then I should NOT see "Page created with Other Fandom"
    But I should see "Page created."
    And I should see "first" within ".tags"
    And I should see "second" within ".fandoms"

Scenario: fandom only selected during create
  Given a tag exists with name: "nonfiction" AND type: "Fandom"
    And a tag exists with name: "something"
    And I am on the homepage
    And I select "nonfiction" from "fandom"
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "New Title"
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
    And I am on the homepage
  Then I should be able to select "Star Wars" from "Fandom"
    And I should be able to select "Harry Potter" from "Fandom"

Scenario: select a fandom for a page when there are fandoms
  Given a tag exists with name: "SGA" AND type: "Fandom"
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
  When I am on the homepage
  Then I should be able to select "meta" from "Fandom"
    And I should be able to select "reviews" from "Fandom"

Scenario: new parent for an existing page should have the same fandom
  Given a page exists with fandoms: "nonfiction"
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "add_parent" with "New Parent"
    And I press "Update"
    And I am on the homepage
  Then I should see "New Parent" within "#position_1"
    And I should see "nonfiction" within ".tags"

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
  Given a tag exists with name: "Harry Potter" AND type: "Fandom"
  When I am on the tags page
  Then I should see "Harry Potter"

Scenario: edit a fandoms
  Given a tag exists with name: "Harry Potter" AND type: "Fandom"
  When I am on the tags page
    And I follow "Harry Potter"
  Then I should see "Edit tag: Harry Potter"

Scenario: change the fandom name
  Given a tag exists with name: "fantasy" AND type: "Fandom"
  When I am on the edit tag page for "fantasy"
    And I fill in "tag_name" with "speculative fiction"
    And I press "Update"
    And I am on the homepage
  Then I should be able to select "speculative fiction" from "fandom"
    And I should NOT see "fantasy"

Scenario: show number of pages for fandom
  Given a page exists with fandoms: "Twilight"
  When I am on the edit tag page for "Twilight"
  Then I should see "1 page with that tag"

Scenario: deleted fandom creates Other Fandom
  Given a page exists with fandoms: "Twilight"
  When I am on the edit tag page for "Twilight"
    And I follow "Destroy"
    And I press "Yes"
    And I am on the homepage
  Then I should NOT be able to select "Twilight" from "fandom"
    But I should be able to select "Other Fandom" from "fandom"
    When I follow "Page 1"
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
  Given a tag exists with name: "better name" AND type: "Fandom"
    And a page exists with fandoms: "bad name"
  When I am on the edit tag page for "bad name"
    And I select "better name" from "merge"
    And I press "Merge"
    And I am on the page's page
  Then I should NOT see "bad name"
    And I should see "better name" within ".fandoms"

Scenario: don’t allow merge if not the same type
  Given a tag exists with name: "not fandom"
    And a tag exists with name: "bad name" AND type: "Fandom"
  When I am on the edit tag page for "bad name"
  Then I should NOT see "not fandom"
    And I should NOT see "Merge"

Scenario: change fandom to trope tag part 1
  Given a page exists with fandoms: "not a fandom"
  When I am on the page's page
  Then I should see "not a fandom" within ".fandoms"
    But I should NOT see "not a fandom" within ".tags"

Scenario: change fandom to trope tag part 2
  Given a page exists with fandoms: "not a fandom"
  When I am on the edit tag page for "not a fandom"
  Then "Fandom" should be selected in "change"

Scenario: change fandom to trope tag part 3
  Given a page exists with fandoms: "not a fandom"
  When I am on the edit tag page for "not a fandom"
    And I select "Trope" from "change"
    And I press "Change"
    And I am on the page's page
 Then I should see "not a fandom" within ".tags"

Scenario: change fandom to trope tag part 4
  Given a page exists with fandoms: "not a fandom"
  When I am on the edit tag page for "not a fandom"
    And I select "Trope" from "change"
    And I press "Change"
    And I am on the homepage
  Then I should be able to select "not a fandom" from "tag"
    But I should NOT be able to select "not a fandom" from "fandom"

Scenario: change trope to fandom tag part 1
  Given a page exists with tropes: "will be fandom"
  When I am on the page's page
  Then I should see "will be fandom" within ".tags"
    But I should NOT see "will be a fandom" within ".fandoms"

Scenario: change trope to fandom tag part 2
  Given a page exists with tropes: "will be fandom"
  When I am on the edit tag page for "will be fandom"
  Then "Trope" should be selected in "change"

Scenario: change trope to fandom tag part 3
  Given a page exists with tropes: "will be fandom"
  When I am on the edit tag page for "will be fandom"
    And I select "Fandom" from "change"
    And I press "Change"
    And I am on the page's page
  Then I should see "will be fandom" within ".fandoms"
    But I should NOT see "will be a fandom" within ".tags"

Scenario: change trope to fandom tag part 4
  Given a page exists with tropes: "will be fandom"
  When I am on the edit tag page for "will be fandom"
    And I select "Fandom" from "change"
    And I press "Change"
    And I am on the homepage
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

Scenario: 陈情令 | The Untamed (TV)
  Given a tag exists with name: "Untamed/MoDao ZuShi" AND type: "Fandom"
    And a page exists with ao3_fandoms: "陈情令 | The Untamed (TV)"
  When I am on the page's page
  Then I should see "Untamed/MoDao ZuShi" within ".fandoms"
    And I should NOT see "陈情令"
    And I should NOT see "TV"

Scenario: Marvel Cinematic Universe
  Given a tag exists with name: "Avengers/Marvel" AND type: "Fandom"
    And a page exists with ao3_fandoms: "Marvel Cinematic Universe"
  When I am on the page's page
  Then I should see "Avengers/Marvel" within ".fandoms"
    And I should NOT see "Cinematic Universe"

Scenario: 魔道祖师 - 墨香铜臭 | Módào Zǔshī - Mòxiāng Tóngxiù
  Given a tag exists with name: "Untamed/MoDao ZuShi" AND type: "Fandom"
    And a page exists with ao3_fandoms: "陈情令 | The Untamed (TV)"
  When I am on the page's page
  Then I should see "Untamed/MoDao ZuShi" within ".fandoms"
    And I should NOT see "魔道祖师"
    And I should NOT see "Mòxiāng"

Scenario: 魔道祖师 - 墨香铜臭 | Módào Zǔshī - Mòxiāng Tóngxiù, 陈情令 | The Untamed (TV)
  Given a tag exists with name: "Untamed/MoDao ZuShi" AND type: "Fandom"
    And a page exists with ao3_fandoms: "魔道祖师 - 墨香铜臭 | Módào Zǔshī - Mòxiāng Tóngxiù, 陈情令 | The Untamed (TV)"
  When I am on the page's page
  Then I should see "Untamed/MoDao ZuShi" within ".fandoms"
    And I should NOT see "Modao Zshi" within ".notes"

Scenario: Forgotten Realms and The Legend of Drizzt Series - R. A. Salvatore
  Given a tag exists with name: "Forgotten Realms/Drizzt" AND type: "Fandom"
    And a page exists with ao3_fandoms: "Forgotten Realms, The Legend of Drizzt Series - R. A. Salvatore"
  When I am on the page's page
  Then I should see "Forgotten Realms/Drizzt" within ".fandoms"
    And I should NOT see "Legend of Drizzt Series"

Scenario: Spider-Man - All Media Types part 1
  Given a page exists with ao3_fandoms: "Spider-Man - All Media Types"
  When I am on the page's page
  Then I should see "Spider-Man" within ".notes"

Scenario: Spider-Man - All Media Types part 2
  Given a tag exists with name: "Spider-man" AND type: "Fandom"
    And a page exists with ao3_fandoms: "Spider-Man - All Media Types"
  When I am on the page's page
  Then I should see "Spider-man" within ".fandoms"
    But I should NOT see "Spider-Man" within ".notes"

Scenario: Deadpool (2016) and Deadpool - All Media Types part 1
  Given a page exists with ao3_fandoms: "Deadpool (2016), Deadpool - All Media Types"
  When I am on the page's page
  Then I should see "Deadpool" within ".notes"
    But I should NOT see "Deadpool, Deadpool"

Scenario: Deadpool (2016) and Deadpool and Spider-Man
  Given a page exists with ao3_fandoms: "Deadpool (2016), Deadpool - All Media Types, Spider-Man - All Media Types"
  When I am on the page's page
  Then I should see "Deadpool, Spider-Man" within ".notes"
    But I should NOT see "Deadpool, Deadpool"

Scenario: Real Genius (1985)
  Given a tag exists with name: "Forgotten Realms/Drizzt" AND type: "Fandom"
    And a page exists with ao3_fandoms: "Real Genius (1985)"
  When I am on the page's page
  Then I should NOT see "Forgotten Realms/Drizzt" within ".fandoms"
    But I should see "Real Genius" within ".notes"
    And I should NOT see "1985" within ".notes"

Scenario: 天官赐福 - 墨香铜臭 | Tiān Guān Cì Fú - Mòxiāng Tóngxiù and 天官赐福
  Given a page exists with ao3_fandoms: "天官赐福 - 墨香铜臭 | Tiān Guān Cì Fú - Mòxiāng Tóngxiù, 天官赐福"
  When I am on the page's page
  Then I should NOT see "Tian Guan Ci Fu, ????" within ".notes"
    And I should NOT see "Tiān Guān Cì Fú" within ".notes"
    But I should see "Tian Guan Ci Fu" within ".notes"

Scenario: star wars, not star trek
  Given a tag exists with name: "Star Trek" AND type: "Fandom"
    And a tag exists with name: "Battlestar Galactica" AND type: "Fandom"
    And a tag exists with name: "Starsky & Hutch" AND type: "Fandom"
    And a tag exists with name: "Star Wars" AND type: "Fandom"
    And a page exists with ao3_fandoms: "Star Wars - All Media Types, Star Wars Prequel Trilogy"
  When I am on the page's page
  Then I should see "Star Wars" within ".fandoms"
    But I should NOT see "Star Trek"
    And I should NOT see "Battlestar"
    And I should NOT see "Starsky"

