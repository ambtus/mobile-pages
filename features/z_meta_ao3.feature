Feature: ao3 meta stuff

Scenario: refetching & rebuilding meta of a top level fic
  Given "harry potter" is a "Fandom"
    And I am on the mini page
  When I fill in "page_url" with "http://archiveofourown.org/works/692"
    And I press "Store"
    And I follow "Notes"
    And I fill in "page_notes" with "changed book notes"
    And I press "Update"
    And I follow "Hogwarts"
    And I follow "Notes"
    And I fill in "page_notes" with "changed part notes"
    And I press "Update"
    And I follow "Time Was, Time Is"
    And I press "Rebuild Meta"
  Then I should NOT see "changed book notes"
    And I should NOT see "changed part notes"
    But I should see "by Sidra" within ".notes"
    And I should see "giving up" within "#position_2"

Scenario: refetching a read Series should show it as unread
  Given Counting Drabbles partially exists
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/series/46"
    And I press "Refetch"
  Then I should see "1 unread part" within ".last_read"
    And I should see "2. The Flower" within "#position_2"
    And I should see "200 words" within ".size"
    But I should NOT see "Harry Potter" before "Harry Potter" within ".notes"

Scenario: adding an unread chapter to a book
  Given Time Was partially exists
  When I am on the page with title "Time Was, Time Is"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "WIP" within ".cons"
    And I should see "1 unread part" within ".last_read"
    And I should see today within "#position_1"
    And I should see "Hogwarts" within "#position_2"
    And I should see "unread" within "#position_2"
    But I should NOT see "Other Fandom" within "#position_2"

Scenario: grab a series with multiple authors
  Given "Good Omens" is a "Fandom"
    And "entanglednow" is an "Author"
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/series/2647903"
    And I press "Store"
  Then I should see "Into The Deep Wood (Series)" within ".title"
    And I should see "Good Omens" within ".fandoms"
    And I should see "entanglednow" within ".authors"
    But I should NOT see "green_grin" within ".authors"
    And I should see "1. The Waters And The Wild" within "#position_1"
    And I should see "2. The Fruits Of The Forest" within "#position_2"
    And I should see "Good Omens" within "#position_1 .fandoms"
    And I should see "Good Omens" within "#position_2 .fandoms"
    And I should see "entanglednow" within "#position_1"
    And I should see "entanglednow" within "#position_2"
    And I should NOT see "green_grin" within "#position_1"
    But I should see "green_grin" within "#position_2"

Scenario: adding a work to a series with a fandom should not get Other Fandom
  Given "harry potter" is a "Fandom"
    And Counting Drabbles partially exists
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/series/46"
    And I press "Refetch"
  Then I should NOT see "Other Fandom"

Scenario: time travel Book
  Given I am on the mini page
  When I fill in "page_url" with "https://archiveofourown.org/works/8339320"
    And I press "Store"
  Then I should see "Time Travel" within ".pros"

Scenario: time travel Series
  Given I am on the mini page
  When I fill in "page_url" with "https://archiveofourown.org/series/1664173"
    And I press "Store"
  Then I should see "Time Travel" within ".pros"

Scenario: chapter numbering bug
  Given that was partially exists
    And I am on the page's page
  When I follow "Refetch"
    And I press "Refetch"
  Then I should see "Chapter 2" within "#position_2"
    But I should NOT see "2. Chapter 2"
    And the part titles should be stored as "Chapter 1 & Chapter 2"

Scenario: single chapter 1 made into book retains title bug
  Given that was single exists
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "that was a spring of storms (Book)" within ".title"
    And I should see "Chapter 2" within "#position_2"
    And I should see "Chapter 1" within "#position_1"
