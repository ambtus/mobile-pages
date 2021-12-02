Feature: ao3 specific stuff

  Scenario: refetching & rebuilding meta of a top level fic
    Given I have no pages
    And I have no tags
     Given a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692"
      And I select "harry potter" from "fandom"
      And I press "Store"
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
      And I should NOT see today within "#position_1"
    When I follow "Refetch"
      And I press "Refetch"
    Then I should see "unread parts" within ".last_read"
      And I should see today within "#position_1"
      And I should see "Hogwarts (unread"
