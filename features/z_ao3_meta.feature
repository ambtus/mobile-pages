Feature: ao3 specific stuff

  Scenario: refetching meta of a top level fic
     Given a tag exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692"
      And I select "harry potter" from "tag"
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

  Scenario: rebuild meta
    Given a tag exists with name: "popslash"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/68481"
      And I select "popslash" from "tag"
      And I press "Store"
    Then I should see "please no crossovers" within ".notes"
      And I should see "AJ/JC" within ".notes"
      And I should see "Make the Yuletide Gay" within ".notes"
      And I should see "Sidra" within ".notes"
      And I follow "Notes"
      And I fill in "page_notes" with "testing notes"
      And I press "Update"
    Then I should see "testing notes" within ".notes"
      And I should NOT see "please no crossovers" within ".notes"
      And I should NOT see "AJ/JC" within ".notes"
      And I should NOT see "Make the Yuletide Gay" within ".notes"
    Given an author exists with name: "Sidra"
      And I press "Rebuild Meta"
    Then I should see "Sidra" within ".authors"
      And I should NOT see "by Sidra" within ".notes"
    Then I should see "please no crossovers" within ".notes"
      And I should see "AJ/JC" within ".notes"
      And I should see "Make the Yuletide Gay" within ".notes"

  Scenario: ensure rebuild meta isn’t refetching
    Given a tag exists with name: "popslash"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/68481"
      And I select "popslash" from "tag"
      And I press "Store"
    Then I should see "please no crossovers" within ".notes"
      And I should see "AJ/JC" within ".notes"
    When I follow "Notes"
      And I fill in "page_notes" with "testing notes"
      And I press "Update"
    Then I should see "testing notes" within ".notes"
      And I should NOT see "AJ/JC" within ".notes"
    When I follow "Edit Raw HTML"
     And I fill in "pasted" with ""
     And I press "Update Raw HTML"
    When I press "Rebuild Meta"
    Then I should NOT see "AJ/JC" within ".notes"
      And I should NOT see "testing notes" within ".notes"

  Scenario: formatting notes
  Given a page exists with url: "https://archiveofourown.org/works/23477578"
  When I am on the homepage
  Then I should NOT see "theirsThe"
  But I should see "He is theirs The clones have nothing"

  Scenario: quotes in notes download bug
    Given a page exists with url: "http://archiveofourown.org/works/22989676/chapters/54962869"
    When I am on the homepage
    And I follow "ePub"
    Then the download epub file should exist
