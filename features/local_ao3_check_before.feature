Feature: checks before z_ao3 scenarios that can use local files

Scenario: check before refetching a one-page Single into a Book
  Given "harry potter" is a "Fandom"
    And "Sidra" is an "Author"
    And Where am I existed and was read
  When I am on the page with title "Time Was, Time Is"
  Then I should see "Time Was, Time Is (Single)" within ".title"
    And I should see "5" within ".stars"
    And I should see "WIP" within ".size"
    And I should see "harry potter" within ".fandoms"
    And I should see "Sidra" within ".authors"
    And I should see "Using time-travel"
    And I should see "written for nanowrimo"
    And I should NOT see "unread"
    And last read should be today

Scenario: check before refetching a one-page Single into a Book
  Given "harry potter" is a "Fandom"
    And "Sidra" is an "Author"
    And Where am I existed and was read
  When I am on the page with title "Time Was, Time Is"
    And I follow "Refetch"
  Then the "url" field should contain "https://archiveofourown.org/works/692"

Scenario: check before refetching a read Series should show it as unread
  Given Counting Drabbles partially exists
  When I am on the page with title "Counting Drabbles"
  Then I should see "100 words" within ".size"
    And I should NOT see "by Sidra" within ".notes"
    And I should NOT see "Harry Potter" within ".notes"
    And I should see "Implied snarry" within ".notes"
    And I should see "thanks to lauriegilbert!" within ".notes"
    And I should see "1. Skipping Stones" within "#position_1"
    And I should see "by Sidra; Harry Potter; Harry Potter/Unknown;" within "#position_1"
    And I should NOT see "The Flower"

Scenario: check before refetch Single (verify that updates changed notes and html)
  Given "harry potter" is a "Fandom"
    And Where am I exists
  When I am on the page with title "Where am I?"
    And I change its raw html to "oops"
    And I follow "Notes"
    And I fill in "page_notes" with "changed notes"
    And I press "Update"
    And I read it online
  Then I should see "oops"
    And I should NOT see "Amy woke slowly"
    And I should see "changed notes"
    And I should NOT see "Sidra"

Scenario: check before refetch Single (verify url to be refetched)
  Given Where am I exists
    And I am on the page with title "Where am I?"
  When I follow "Refetch"
  Then the "url" field should contain "https://archiveofourown.org/works/692/chapters/803"

Scenario: check before getting book by adding parent and then refetching
  Given Where am I exists
  When I am on the homepage
    And I follow "Where am I"
  Then I should see "Where am I? (Single)" within ".title"
    And I should NOT see "WIP" within ".size"

Scenario: 2nd check before getting book by adding parent and then refetching
  Given Where am I exists
  When I am on the homepage
    And I follow "Where am I"
    And I add a parent with title "Parent"
    And I follow "Refetch"
  Then I should see "archiveofourown.org/works/692/chapters/803" within "#url_list"
    And the "url" field should contain "https://archiveofourown.org/works/692"

Scenario: check before fetching a series from before series had urls
  Given Misfits existed
  When I am on the page with title "Misfit Series"
    And I follow "Refetch"
  Then I should see "##Three Misfits in New York" within "#url_list"
    And I should see "##A Misfit Working Holiday In New York" within "#url_list"
    And the "url" field should contain "https://archiveofourown.org/works/4945936"

Scenario: check before creating a series when I already have its books
  Given Misfits existed
  When I am on the homepage
    And I follow "Misfit Series"
    And I press "Uncollect"
    And I am on the homepage
  Then I should have 6 pages
    And I should see "Three Misfits in New York" within "#position_1"
    And I should see "A Misfit Working Holiday In New York" within "#position_2"
    And the page should NOT contain css "#position_3"

Scenario: check before adding an unread chapter to a book
  Given Time Was partially exists
  When I am on the homepage
    And I follow "Time Was, Time Is"
  Then I should see today within ".last_read"
    But I should NOT see "unread parts" within ".last_read"
    And I should see today within "#position_1"
    And I should see "by Sidra" within ".notes"
    And I should NOT see "Sidra" within "#position_1"
    And I should have 0 pages with and 2 without fandoms
    And I should have 0 pages with and 2 without authors

Scenario: check before getting book by adding parent and then refetching
  Given Where am I exists
  When I am on the page's page
    And I add a parent with title "Parent"
    And I follow "Refetch"
  Then the "url" field should contain "https://archiveofourown.org/works/692"
    And the "url_list" field should contain "https://archiveofourown.org/works/692/chapters/803##Where am I?"

Scenario: check before rebuild meta on deleted series
  Given Iterum Rex exists
  When I am on the page with title "Iterum Rex"
  Then I should see "Iterum Rex" within ".title"
    And I should NOT see "by TardisIsTheOnlyWayToTravel" within ".notes"
    And I should NOT see "Harry Potter, Arthurian Mythology & Related Fandoms" within ".notes"
    But I should see "Brave New World" within "#position_1"
    And I should see "by TardisIsTheOnlyWayToTravel" within "#position_1"
    And I should see "Harry Potter, Arthurian Mythology & Related Fandoms" within "#position_1"
    And I should see "Draco Malfoy, reluctant Death Eater" within "#position_1"

Scenario: check before chapter numbering bug
  Given that was partially exists
  When I am on the page's page
  Then I should see "Chapter 1" within "#position_1"
    But I should NOT see "1. Chapter 1"
    And the part titles should be stored as "Chapter 1"

 Scenario: local series (duplicated in z_ao3_fetch)
  Given "Harry Potter" is a "Fandom"
    And "Sidra" is an "Author"
    And Counting Drabbles exists
  When I am on the page's page
  Then I should see "Counting Drabbles (Series)" within ".title"
    And I should see "200 words" within ".size"
    And I should see "Implied snarry" within ".notes"
    And I should see "thanks to lauriegilbert!" within ".notes"
    And I should see "Harry Potter" within ".fandoms"
    And I should see "Sidra" within ".authors"
    And I should see "1. Skipping Stones" within "#position_1"
    And I should see "2. The Flower [sequel to Skipping Stones]" within "#position_2"
    And the show tags for "Counting Drabbles" should include fandom and author
    And I should see "Harry Potter/Unknown; Drabble; thanks to lauriegilbert for" within "#position_1"
    And I should see "Harry Potter/Unknown; Drabble; Thank you lauriegilbert for" within "#position_2"
    And my page named "Counting Drabbles" should have url: "https://archiveofourown.org/series/46"
    And my page named "Skipping Stones" should have url: "https://archiveofourown.org/works/688"
    And my page named "The Flower [sequel to Skipping Stones]" should have url: "https://archiveofourown.org/works/689"
    And the tags for "Skipping Stones" should include fandom and author
    And the tags for "The Flower [sequel to Skipping Stones]" should include fandom and author
    But the tags for "Counting Drabbles" should NOT include fandom and author

