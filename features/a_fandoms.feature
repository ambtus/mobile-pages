Feature: fandoms are a type of tag, and can be created and selected like tags

  Scenario: fandom tag not in tag dropdown
    Given a tag exists with name: "not fandom"
    Given a tag exists with name: "yes fandom" AND type: "Fandom"
    When I am on the homepage
    Then I should NOT be able to select "yes fandom" from "tag"
    But I should be able to select "yes fandom" from "fandom"
    And I should be able to select "not fandom" from "tag"

  Scenario: strip fandom whitespace and sort
    Given a page exists
    When I am on the page's page
      And I edit its tags
      And I fill in "tags" with "  nonfiction,  audio  book,save for   later  "
      And I press "Add Fandom Tags"
    Then I should see "audio book nonfiction save for later" within ".fandoms"

  Scenario: no tags exist during create
    Given I am on the homepage
      And I have no pages
      And I have no tags
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select fandom"
    When I fill in "tags" with "new fandom"
      And I press "Add Fandom Tags"
    Then I should see "new fandom" within ".fandoms"

  Scenario: no tags selected during create
    Given a tag exists with name: "first" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select fandom"
    When I select "first" from "page_fandom_ids_"
      And I press "Update Tags"
    Then I should see "first" within ".fandoms"

  Scenario: fandom and other tag selected during create
    Given a tag exists with name: "first"
      And a tag exists with name: "second" AND type: "Fandom"
      And I am on the homepage
      And I select "first" from "tag"
      And I select "second" from "fandom"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should NOT see "Please select fandom"
      And I should see "first" within ".tags"
      And I should see "second" within ".fandoms"

  Scenario: fandom only selected during create
    Given a tag exists with name: "nonfiction" AND type: "Fandom"
    Given a tag exists with name: "something"
      And I am on the homepage
      And I select "nonfiction" from "fandom"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should NOT see "Please select fandom"
      And I should see "nonfiction" within ".fandoms"

  Scenario: add a fandom to a page when there are no fandoms
    Given a page exists
    When I am on the page's page
      And I edit its tags
    When I fill in "tags" with "Star Wars, Harry Potter"
      And I press "Add Fandom Tags"
    Then I should see "Harry Potter Star Wars" within ".fandoms"
    When I am on the homepage
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

  Scenario: add a fandom to a page which already has fandoms
    Given I have no pages
    And a page exists with fandoms: "nonfiction"
    When I am on the page's page
    Then I should see "nonfiction" within ".fandoms"
    When I edit its tags
      And I fill in "tags" with "meta, reviews"
      And I press "Add Fandom Tags"
    Then I should see "meta nonfiction reviews" within ".fandoms"
    When I am on the homepage
    Then I should be able to select "meta" from "Fandom"

   Scenario: new parent for an existing page should have the same fandom
    Given I have no pages
    Given a page exists with fandoms: "nonfiction"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    Then I should see "nonfiction" within ".fandoms"
    And I should see "Page 1" within ".parts"
      But I should NOT see "nonfiction" within ".parts"
    When I am on the homepage
      Then I should see "New Parent" within "#position_1"
    And I should see "nonfiction" within ".tags"

 Scenario: list the fandoms
    Given a tag exists with name: "Harry Potter" AND type: "Fandom"
    When I am on the tags page
    Then I should see "Harry Potter"
    When I follow "Harry Potter"
      Then I should see "Edit tag: Harry Potter"

  Scenario: edit the fandom name
    Given I have no tags
    And a tag exists with name: "fantasy" AND type: "Fandom"
    When I am on the homepage
      And I select "fantasy" from "fandom"
    When I am on the edit tag page for "fantasy"
    And I fill in "tag_name" with "speculative fiction"
    And I press "Update"
    When I am on the homepage
      And I should be able to select "speculative fiction" from "fandom"

  Scenario: delete a fandom
    Given I have no tags
    And a page exists with fandoms: "Twilight"
    When I am on the edit tag page for "Twilight"
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no fandoms
    When I am on the homepage
      Then I should NOT see "Twilight"
      But I should see "Page 1"

  Scenario: merge two tags
    Given I have no tags
    And I have no pages
    And a tag exists with name: "better name" AND type: "Fandom"
      And a page exists with fandoms: "bad name"
    When I am on the edit tag page for "bad name"
      And I select "better name" from "merge"
      And I press "Merge"
    When I am on the page's page
    Then I should NOT see "bad name"
    And I should see "better name" within ".fandoms"

  Scenario: don’t allow merge if not the same type
    Given I have no tags
    And a tag exists with name: "not fandom"
    Given a tag exists with name: "bad name" AND type: "Fandom"
    When I am on the edit tag page for "bad name"
      Then I should NOT see "not fandom"
      And I should NOT see "Merge"

  Scenario: change fandom to trope tag
    Given I have no tags
    And I have no pages
    And a page exists with fandoms: "not a fandom"
    When I am on the page's page
      Then I should see "not a fandom" within ".fandoms"
    When I am on the edit tag page for "not a fandom"
      Then "Fandom" should be selected in "change"
    When I select "Trope" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "not a fandom" within ".tags"
      And the page should NOT have any fandom tags
      When I am on the homepage
    Then I should be able to select "not a fandom" from "tag"
    But I should NOT be able to select "not a fandom" from "fandom"

  Scenario: change trope to fandom tag
    Given I have no tags
    And I have no pages
    And a page exists with tropes: "will be fandom"
    When I am on the page's page
      Then I should see "will be fandom" within ".tags"
    When I am on the edit tag page for "will be fandom"
      Then "Trope" should be selected in "change"
      And I select "Fandom" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "will be fandom" within ".fandoms"
      When I am on the homepage
    Then I should be able to select "will be fandom" from "fandom"
    But I should NOT be able to select "will be fandom" from "tag"

  Scenario: change hidden to fandom tag
    Given I have no tags
    And I have no pages
    And a page exists with hiddens: "will be visible"
    When I am on the page's page
      Then I should see "will be visible" within ".hiddens"
    When I am on the edit tag page for "will be visible"
      Then "Hidden" should be selected in "change"
      And I select "Fandom" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "will be visible" within ".fandoms"
      And the page should NOT have any hidden tags

  Scenario: change fandom to hidden tag
    Given I have no tags
    And I have no pages
    And a page exists with fandoms: "will be hidden"
    When I am on the page's page
      Then I should see "will be hidden" within ".fandoms"
    When I am on the edit tag page for "will be hidden"
      Then "Fandom" should be selected in "change"
      And I select "Hidden" from "change"
      And I press "Change"
    When I am on the page's page
      Then I should see "will be hidden" within ".hiddens"
      And the page should NOT have any not hidden tags

  Scenario: 陈情令 | The Untamed (TV)
    Given I have no tags
    And I have no pages
      And a tag exists with name: "Untamed/MoDao ZuShi" AND type: "Fandom"
    And a page exists with ao3_fandoms: "陈情令 | The Untamed (TV)"
    When I am on the page's page
    Then I should see "Untamed/MoDao ZuShi" within ".fandoms"
    And I should NOT see "陈情令"
    And I should NOT see "TV"

  Scenario: Marvel Cinematic Universe
    Given I have no tags
    And I have no pages
      And a tag exists with name: "Avengers/Marvel" AND type: "Fandom"
    And a page exists with ao3_fandoms: "Marvel Cinematic Universe"
    When I am on the page's page
    Then I should see "Avengers/Marvel" within ".fandoms"
    And I should NOT see "Cinematic Universe"

  Scenario: 魔道祖师 - 墨香铜臭 | Módào Zǔshī - Mòxiāng Tóngxiù
    Given I have no tags
    And I have no pages
      And a tag exists with name: "Untamed/MoDao ZuShi" AND type: "Fandom"
    And a page exists with ao3_fandoms: "陈情令 | The Untamed (TV)"
    When I am on the page's page
    Then I should see "Untamed/MoDao ZuShi" within ".fandoms"
    And I should NOT see "魔道祖师"
    And I should NOT see "Mòxiāng"

  Scenario: 魔道祖师 - 墨香铜臭 | Módào Zǔshī - Mòxiāng Tóngxiù, 陈情令 | The Untamed (TV)
    Given I have no tags
    And I have no pages
      And a tag exists with name: "Untamed/MoDao ZuShi" AND type: "Fandom"
    And a page exists with ao3_fandoms: "魔道祖师 - 墨香铜臭 | Módào Zǔshī - Mòxiāng Tóngxiù, 陈情令 | The Untamed (TV)"
    When I am on the page's page
    Then I should see "Untamed/MoDao ZuShi" within ".fandoms"

  Scenario: Forgotten Realms and The Legend of Drizzt Series - R. A. Salvatore
    Given I have no tags
    And I have no pages
      And a tag exists with name: "Forgotten Realms/Drizzt" AND type: "Fandom"
    And a page exists with ao3_fandoms: "Forgotten Realms, The Legend of Drizzt Series - R. A. Salvatore"
    When I am on the page's page
    Then I should see "Forgotten Realms/Drizzt" within ".fandoms"
    And I should NOT see "Legend of Drizzt Series"

  Scenario: Spider-Man - All Media Types
     Given I have no tags
    And I have no pages
    And a page exists with ao3_fandoms: "Spider-Man - All Media Types"
    When I am on the page's page
    Then I should see "Fandom: Spider-Man"

  Scenario: Spider-Man - All Media Types
     Given I have no tags
    And I have no pages
    When a tag exists with name: "Spider-man" AND type: "Fandom"
    And a page exists with ao3_fandoms: "Spider-Man - All Media Types"
    When I am on the page's page
    Then I should see "Spider-man" within ".fandoms"

   Scenario: Deadpool (2016) and Deadpool - All Media Types
    Given I have no tags
    And I have no pages
    And a page exists with ao3_fandoms: "Deadpool (2016), Deadpool - All Media Types"
    When I am on the page's page
    Then I should see "Fandom: Deadpool" within ".notes"
    And I should NOT see "Deadpool, Deadpool"

   Scenario: Deadpool (2016) and Deadpool - All Media Types and Spider-Man - All Media Types
    Given I have no tags
    And I have no pages
    And a page exists with ao3_fandoms: "Deadpool (2016), Deadpool - All Media Types, Spider-Man - All Media Types"
    When I am on the page's page
    Then I should see "Fandoms: Deadpool, Spider-Man" within ".notes"
    And I should NOT see "Deadpool, Deadpool"

  Scenario: Real Genius (1985)
     Given I have no tags
    And I have no pages
    When a tag exists with name: "Forgotten Realms/Drizzt" AND type: "Fandom"
    And a page exists with ao3_fandoms: "Real Genius (1985)"
    When I am on the page's page
    Then I should NOT see "Forgotten Realms/Drizzt" within ".fandoms"
    But I should see "Fandom: Real Genius" within ".notes"
    And I should NOT see "1985" within ".notes"
