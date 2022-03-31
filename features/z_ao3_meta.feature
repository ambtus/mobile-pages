Feature: ao3 specific stuff

  Scenario: refetching & rebuilding meta of a top level fic
    Given I have no pages
    And I have no tags
     Given a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692"
      And I press "Store"
    Then I should see "WIP" within ".omitteds"
    And I should see "harry potter" within ".fandoms"
      And I follow "Notes"
      And I fill in "page_notes" with "changed notes"
      And I press "Update"
    Then I should see "changed notes" within ".notes"
      And I should NOT see "by Sidra" within ".notes"
    When I follow "Hogwarts"
      And I follow "Manage Parts"
      And I fill in "title" with "Hogwarts (abandoned)"
      And I press "Update"
      And I follow "Time Was, Time Is"
    Then I should see "Hogwarts (abandoned)" within "#position_2"
    When I follow "Refetch"
      And I press "Refetch Meta"
    Then I should NOT see "changed notes" within ".notes"
      But I should see "by Sidra" within ".notes"
    And I should NOT see "Hogwarts (abandoned)" within "#position_2"
      But I should see "Hogwarts" within "#position_2"
    When I follow "Notes"
      And I fill in "page_notes" with "changed notes"
       And I press "Update"
    Then I should see "changed notes" within ".notes"
    When I follow "Hogwarts"
      And I follow "Notes"
      And I fill in "page_notes" with "part notes"
       And I press "Update"
    Then I should see "part notes" within ".notes"
    When I follow "Time Was, Time Is"
      Then I should see "changed notes"
      And I should see "part notes" within "#position_2"
    When I press "Rebuild Meta"
     Then I should NOT see "changed notes"
      And I should NOT see "part notes"
      But I should see "by Sidra" within ".notes"
      And I should NOT see "part notes" within "#position_2"
      And I should see "giving up" within "#position_2"

  Scenario: adding an unread chapter to a book makes the book unread
    Given I have no pages
    And I have no tags
    And Time Was partially exists
    When I am on the homepage
      And I follow "Time Was, Time Is"
      Then I should see today within ".last_read"
      But I should NOT see "unread parts" within ".last_read"
      And I should see today within "#position_1"
    When I follow "Refetch"
      And I press "Refetch"
    Then I should see "Refetched" within "#flash_notice"
    Then I should see "1 unread part" within ".last_read"
      And I should see today within "#position_1"
      And I should see "Hogwarts (unread"
      And I should see "WIP" within ".omitteds"

   Scenario: grab a series with multiple authors
    Given I have no pages
      And a tag exists with name: "Good Omens" AND type: "Fandom"
      And an author exists with name: "entanglednow"
    When I am on the homepage
      And I fill in "page_url" with "https://archiveofourown.org/series/2647903"
      And I select "entanglednow" from "author"
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
