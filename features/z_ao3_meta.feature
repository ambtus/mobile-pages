Feature: ao3 specific stuff

Scenario: refetching & rebuilding meta of a top level fic
  Given a tag exists with name: "harry potter" AND type: "Fandom"
    And I am on the homepage
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
  When I am on the homepage
    And I fill in "page_url" with "https://archiveofourown.org/series/46"
    And I press "Refetch"
  Then I should see "1 unread part" within ".last_read"
    And I should see "2. The Flower" within "#position_2"
    And I should see "200 words" within ".size"
    But I should NOT see "Harry Potter" before "Harry Potter" within ".notes"

Scenario: rebuilding a Series before storing index as raw HTML (needs to refetch index)
  Given Misfits exists
    And Misfits has a URL
  When I am on the homepage
    And I follow "Misfit Series"
    And I press "Rebuild Meta"
  Then I should see "Misfits (Series)" within ".title"
  And I should see "by Morraine" before "Teen Wolf, Captain America, Avengers, Iron Man, Thor" within ".notes"

Scenario: adding an unread chapter to a book makes the book unread
  Given Time Was partially exists
  When I am on the page with title "Time Was, Time Is"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "1 unread part" within ".last_read"
    And I should see today within "#position_1"
    And I should see "Hogwarts (unread"
    And I should see "WIP" within ".omitteds"

Scenario: grab a series with multiple authors
  Given a tag exists with name: "Good Omens" AND type: "Fandom"
    And an author exists with name: "entanglednow"
  When I am on the homepage
    And I fill in "page_url" with "https://archiveofourown.org/series/2647903"
    And I press "Store"
  Then I should see "Into The Deep Wood (Series)" within ".title"
    And I should see "et al: green_grin" within ".notes"
    And I should see "Good Omens" within ".fandoms"
    And I should see "entanglednow" within ".authors"
    And I should see "1. The Waters And The Wild " within "#position_1"
    And I should see "2. The Fruits Of The Forest" within "#position_2"
    And I should NOT see "Good Omens) Rate" within "#position_1"
    And I should NOT see "Good Omens) Rate" within "#position_2"
    And I should NOT see "entanglednow" within "#position_1"
    And I should NOT see "entanglednow" within "#position_2"
    And I should NOT see "et al: green_grin" within "#position_1"
    But I should see "et al: green_grin" within "#position_2"

Scenario: works in a series should not have duplicate tags
  Given an author exists with name: "Sidra"
    And a tag exists with name: "harry potter" AND type: "Fandom"
  When I am on the homepage
    And I fill in "page_url" with "https://archiveofourown.org/series/46"
    And I press "Store"
  Then I should see "Sidra" within ".authors"
    But I should NOT see "Sidra" within "#position_1"
    And I should NOT see "Sidra" within "#position_2"
    And I should see "harry potter" within ".fandoms"
    But I should NOT see "harry potter" within "#position_1"
    But I should NOT see "harry potter" within "#position_2"

Scenario: getting series by adding parent and then refetching should not duplicate tags
  Given a tag exists with name: "harry potter" AND type: "Fandom"
    And Skipping Stones exists
    And I am on the page's page
  When I follow "Manage Parts"
    And I fill in "add_parent" with "Parent"
    And I press "Update"
    And I follow "Refetch"
    And I fill in "url" with "https://archiveofourown.org/series/46"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Counting Drabbles (Series)" within ".title"
    And I should see "harry potter" within ".fandoms"
    And I should see "Skipping Stones" within "#position_1"
    And I should NOT see "Harry Potter" before "Harry Potter/Unknown" within "#position_1"
    And I should NOT see "harry potter" within "#position_1"
    And I should see "The Flower" within "#position_2"
    And I should NOT see "Harry Potter" before "Harry Potter/Unknown" within "#position_2"
    And I should NOT see "harry potter" within "#position_2"

