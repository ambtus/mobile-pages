Feature: ao3 specific stuff

  Scenario: grab single page
    Given a tag exists with name: "popslash"
      And an author exists with name: "Sidra"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/68481"
      And I select "popslash" from "tag"
      And I press "Store"
    Then I should NOT see "Title can't be blank"
      And I should see "I Drive Myself Crazy" within ".title"
      And I should see "please no crossovers" within ".notes"
      And I should NOT see "Popslash" within ".notes"
      And I should see "AJ/JC" within ".notes"
      And I should see "Make the Yuletide Gay" within ".notes"
      And I should see "Sidra" within ".authors"
      And I should NOT see "by Sidra" within ".notes"

  Scenario: grab chaptered page
    Given a tag exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692"
      And I select "harry potter" from "tag"
      And I press "Store"
    Then I should see "Time Was, Time Is"
      And I should see "by Sidra" within ".notes"
      And I should see "Using time-travel" within ".notes"
      And I should see "abandoned, Mary Sue" within ".notes"
      And I should see "Where am I?"
      And I should see "written for nanowrimo" within "#position_1"
      And I should see "giving up on nanowrimo" within "#position_2"
      And I should see "1. Where am I?" within "#position_1"
      And I should see "2. Hogwarts" within "#position_2"
    When I follow "Hogwarts"
      Then I should NOT see "by Sidra" within ".notes"
      And I should NOT see "Using time-travel" within ".notes"
      And I should NOT see "abandoned" within ".notes"
   But the part titles should be stored as "Where am I? & Hogwarts"

  Scenario: ao3 with and without chapter titles
    Given I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/310586"
      And I press "Store"
    When I am on the page with title "Open the Door"
     And I view the content
    Then I should see "Chapter 1"
      And I should see "2. Ours"
      But I should NOT see "1. Chapter 1"
   But the part titles should be stored as "Chapter 1 & Ours"

  Scenario: refetch from ao3 when it used to be somewhere else
    Given a page exists with title: "Counting" AND url: "https://www.fanfiction.net/s/5853866/1/Counting"
      And I am on the page with title "Counting"
      # Then I should see "ambtus" # TODO after add grabbing author from fanfiction
      And I should NOT see "lauriegilbert"
      When I view the content
      Then I should see "Skip."
    When I am on the page with title "Counting"
      And I follow "Refetch" within ".edits"
    When I fill in "url" with "http://archiveofourown.org/works/688"
      And I press "Refetch"
    Then I should see "by Sidra"
      And I should NOT see "ambtus"
      And I should see "Skipping Stones"
      And I should see "thanks to lauriegilbert"
      When I view the content
      Then I should see "Skip."

  Scenario: deliberately fetch only one chapter
    Given a tag exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "tag"
      And I press "Store"
    Then I should see "Where am I?" within ".title"
      And I should NOT see "1."
      And I should see "by Sidra"
      And I should see "Using time-travel"
      And I should NOT see "Hogwarts"
      And I should NOT see "giving up on nanowrimo"

  Scenario: refetch one chapter from ao3
    Given a tag exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "tag"
      And I press "Store"
      And I follow "Notes"
      And I fill in "page_notes" with "changed notes"
      And I press "Update"
    Then I should see "changed notes" within ".notes"
      And I should NOT see "by Sidra" within ".notes"
    And I follow "Edit Scrubbed HTML"
      And I fill in "pasted" with "oops"
      And I press "Edit HTML"
      And I view the content
    Then I should see "oops"
      And I should NOT see "Amy woke slowly"
    When I am on the page with title "Where am I?"
      And I follow "Refetch"
      Then the "url" field should contain "http://archiveofourown.org/works/692/chapters/803"
    When I press "Refetch"
      Then I should see "Where am I?" within ".title"
      And I should NOT see "1."
      And I should see "by Sidra" within ".notes"
      And I should NOT see "changed notes" within ".notes"
      When I view the content
      Then I should NOT see "oops"
      And I should see "Amy woke slowly"

  Scenario: fetch more chapters from ao3
    Given a tag exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "tag"
      And I press "Store"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
     And I follow "Refetch" within ".edits"
    Then the "url" field should contain "http://archiveofourown.org/works/692"
    When I press "Refetch"
    Then I should see "Time Was, Time Is" within ".title"
      And I should see "Using time-travel"
      And I should see "Where am I?" within "#position_1"
      And I should NOT see "1. Were am I?" within "#position_1"
      And I should see "2. Hogwarts" within "#position_2"
    When I follow "Refetch"
      And I press "Refetch Meta"
      Then I should see "1. Where am I?" within "#position_1"

  Scenario: refetching top level fic shouldn't change chapter titles if i've modified them
     Given a tag exists with name: "harry potter"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/692"
      And I select "harry potter" from "tag"
      And I press "Store"
      And I follow "Hogwarts"
    When I follow "Manage Parts"
      And I fill in "title" with "Hogwarts (abandoned)"
      And I press "Update"
      And I follow "Time Was, Time Is"
    Then I should see "Hogwarts (abandoned)" within "#position_2"
    When I follow "Refetch"
      And I press "Refetch"
    Then I should see "Hogwarts (abandoned)" within "#position_2"

  Scenario: finding page stored with https
    Given a page exists with url: "https://archiveofourown.org/works/68481"
    When I am on the homepage
      And I fill in "page_url" with "http://archiveofourown.org/works/68481"
      And I press "Find"
    Then I should see "I Drive Myself Crazy" within "#position_1"

  Scenario: finding page stored with http
    Given a page exists with url: "http://archiveofourown.org/works/68481"
    When I am on the homepage
      And I fill in "page_url" with "https://archiveofourown.org/works/68481"
      And I press "Find"
    Then I should see "I Drive Myself Crazy" within "#position_1"

