Feature: ao3 specific stuff

  Scenario: grab single page
    Given I have no pages
    And a tag exists with name: "popslash" AND type: "Fandom"
      And an author exists with name: "Sidra"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/68481"
      And I select "popslash" from "fandom"
      And I press "Store"
    Then I should NOT see "Title can't be blank"
      And I should see "I Drive Myself Crazy (Single)" within ".title"
      And I should see "please no crossovers" within ".notes"
      And I should NOT see "Popslash" within ".notes"
      And I should see "AJ/JC" within ".notes"
      And I should see "Make the Yuletide Gay" within ".notes"
      And I should see "Sidra" within ".authors"
      And I should NOT see "by Sidra" within ".notes"

  Scenario: grab chaptered page
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692"
      And I select "harry potter" from "fandom"
      And I press "Store"
    Then I should see "Time Was, Time Is (Book)" within ".title"
      And I should see "1,581 words" within ".size"
      And I should see "by Sidra" within ".notes"
      And I should see "Using time-travel" within ".notes"
      And I should see "abandoned, Mary Sue" within ".notes"
      And I should see "Where am I?"
      And I should see "written for nanowrimo" within "#position_1"
      And I should see "giving up on nanowrimo" within "#position_2"
      And I should see "1. Where am I?" within "#position_1"
      And I should see "2. Hogwarts" within "#position_2"
    When I follow "Hogwarts"
      Then I should see "Hogwarts (Chapter)" within ".title"
      Then I should NOT see "by Sidra" within ".notes"
      And I should NOT see "Using time-travel" within ".notes"
      And I should NOT see "abandoned" within ".notes"
   But the part titles should be stored as "Where am I? & Hogwarts"

   Scenario: grab a series
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/series/46"
      And I select "harry potter" from "fandom"
      And I press "Store"
    Then I should see "Counting Drabbles (Series)" within ".title"
      And I should see "200 words" within ".size"
      And I should see "by Sidra" within ".notes"
      And I should see "Implied snarry" within ".notes"
      And I should see "thanks to lauriegilbert!" within ".notes"
      And I should see "Skipping Stones" within "#position_1"
      And I should see "The Flower" within "#position_2"
    When I follow "Skipping Stones"
      Then I should see "Parent: Counting Drabbles (Series)"
      And I should see "Next: The Flower [sequel to Skipping Stones] (Single)"
      And I should see "Skipping Stones (Single)" within ".title"
      And I should NOT see "by Sidra" within ".notes"
    When I press "Rebuild Meta"
      Then I should see "Skipping Stones (Single)"
      And I should NOT see "by Sidra" within ".notes"
    When I follow "Counting Drabbles"
      And I press "Rebuild Meta"
      Then I should see "Counting Drabbles (Series)"
    When I follow "The Flower"
      Then I should see "The Flower [sequel to Skipping Stones] (Single)"

  Scenario: ao3 with and without chapter titles
    Given I have no pages
    And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/310586"
      And I press "Store"
    When I am on the page with title "Open the Door"
     And I view the content
    Then I should see "Chapter 1"
      And I should see "2. Ours"
      But I should NOT see "1. Chapter 1"
   But the part titles should be stored as "Chapter 1 & Ours"

  Scenario: deliberately fetch only one chapter
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "fandom"
      And I press "Store"
    Then I should see "Where am I? (Single)" within ".title"
      And I should NOT see "1."
      And I should see "by Sidra"
      And I should see "Using time-travel"
      And I should NOT see "Hogwarts"
      And I should NOT see "giving up on nanowrimo"

  Scenario: refetch one chapter from ao3
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "fandom"
      And I press "Store"
      Then I should see "Where am I? (Single)" within ".title"
    When I follow "Notes"
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
      Then the "url" field should contain "https://archiveofourown.org/works/692/chapters/803"
    When I press "Refetch"
      Then I should see "Where am I?" within ".title"
      And I should NOT see "1."
      And I should see "by Sidra" within ".notes"
      And I should NOT see "changed notes" within ".notes"
      When I view the content
      Then I should NOT see "oops"
      And I should see "Amy woke slowly"

  Scenario: creates a Book of Chapters, but doesn’t assume it’s an ao3 Work
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "fandom"
      And I press "Store"
      Then I should see "Where am I? (Single)" within ".title"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
    Then I should see "Parent (Book)" within ".title"
    And I follow "Where am I?"
      Then I should see "Where am I? (Chapter)" within ".title"
    When I follow "Parent"
      And I follow "Refetch"
    Then I should see "archiveofourown.org/works/692/chapters/803" within "#url_list"
    When I am on the homepage
      And I fill in "page_url" with "https://archiveofourown.org/works/692"
      And I press "Find"
    Then I should see "Where am I? of Parent"
      When I select "harry potter" from "fandom"
      And I press "Store"
    Then I should NOT see "Url has already been taken"
      And I should see "Time Was, Time Is (Book)" within ".title"
      And I should see "Where am I?" within "#position_1"
      And I should see "Hogwarts" within "#position_2"
    When I am on the homepage
      And I fill in "page_url" with "https://archiveofourown.org/works/692"
      And I press "Find"
    Then I should see "Where am I? of Time Was, Time Is"
    And I should NOT see "Where am I? of Parent"
    And my page named "Parent" should have 0 parts


  Scenario: refetching top level fic shouldn't change chapter titles if i've modified them
    Given I have no pages
     And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692"
      And I select "harry potter" from "fandom"
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
    Given I have no pages
    And a page exists with url: "https://archiveofourown.org/works/68481"
    When I am on the homepage
      And I fill in "page_url" with "https://archiveofourown.org/works/68481"
      And I press "Find"
    Then I should see "I Drive Myself Crazy" within "#position_1"

  Scenario: finding page stored with http
    Given I have no pages
    And a page exists with url: "https://archiveofourown.org/works/68481"
    When I am on the homepage
      And I fill in "page_url" with "https://archiveofourown.org/works/68481"
      And I press "Find"
    Then I should see "I Drive Myself Crazy" within "#position_1"


  Scenario: adding a url to a Work
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "fandom"
      And I press "Store"
      Then I should see "Where am I? (Single)" within ".title"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
      And I follow "Refetch"
    Then I should see "archiveofourown.org/works/692/chapters/803" within "#url_list"
    And the "url" field should contain "https://archiveofourown.org/works/692"
    When I press "Refetch"
    Then I should see "Time Was, Time Is (Book)" within ".title"
    When I follow "Where am I?"
      Then I should see "Where am I? (Chapter)" within ".title"

  Scenario: not creating an ao3 work from a set of Singles
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "fandom"
      And I press "Store"
      Then I should see "Where am I? (Single)" within ".title"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
    Then I should see "Parent (Book)" within ".title"
    And I should see "Where am I?" within "#position_1"
    When I follow "Refetch"
    Then I should see "archiveofourown.org/works/692/chapters/803" within "#url_list"
    When I fill in "url" with ""
      And I fill in "url_list" with
        """
        https://archiveofourown.org/works/692/chapters/803
        https://archiveofourown.org/works/692/chapters/804
        """
    And I press "Refetch"
    Then I should see "Parent (Book)" within ".title"
    When I follow "Where am I?"
      Then I should see "Where am I? (Chapter)" within ".title"
      And I should see "Next: Hogwarts (Chapter)"

  Scenario: adding a url to a Series
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/688"
      And I select "harry potter" from "fandom"
      And I press "Store"
      Then I should see "Skipping Stones (Single)" within ".title"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
    Then I should see "Parent (Book)" within ".title"
    When I follow "Refetch"
    And I fill in "url" with "https://archiveofourown.org/series/46"
    And I press "Refetch"
    Then I should see "Counting Drabbles (Series)" within ".title"
    When I follow "The Flower"
      Then I should see "The Flower [sequel to Skipping Stones] (Single)" within ".title"
