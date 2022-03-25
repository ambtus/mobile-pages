Feature: ao3 specific stuff

  Scenario: grab a single
    Given I have no pages
    And a tag exists with name: "popslash" AND type: "Fandom"
      And an author exists with name: "Sidra"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/works/68481/"
      And I press "Store"
    Then I should NOT see "Title can't be blank"
    And I should NOT see "Select tags"
      And I should see "I Drive Myself Crazy (Single)" within ".title"
      And I should NOT see "WIP" within ".omitteds"
      And I should see "popslash" within ".fandoms"
      And I should see "please no crossovers" within ".notes"
      And I should NOT see "Popslash" within ".notes"
      And I should see "AJ/JC" within ".notes"
      And I should see "Make the Yuletide Gay" within ".notes"
      And I should see "Sidra" within ".authors"
      And I should NOT see "by Sidra" within ".notes"
    And my page named "I Drive Myself Crazy" should have url: "https://archiveofourown.org/works/68481"

  Scenario: grab a book
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692/"
      And I select "harry potter" from "fandom"
      And I press "Store"
    Then I should see "Time Was, Time Is (Book)" within ".title"
      And I should see "WIP" within ".omitteds"
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
    And my page named "Time Was, Time Is" should have url: "https://archiveofourown.org/works/692"

   Scenario: grab a series
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "http://archiveofourown.org/series/46"
      And I select "harry potter" from "fandom"
      And I press "Store"
    Then I should see "Counting Drabbles (Series)" within ".title"
      And I should see "200 words" within ".size"
      And I should see "by Sidra" within ".notes"
      And I should see "harry potter" within ".fandoms"
      And I should NOT see "Fandom: Harry Potter" within ".notes"
      And I should see "Implied snarry" within ".notes"
      And I should see "thanks to lauriegilbert!" within ".notes"
      And I should see "1. Skipping Stones" within "#position_1"
      And I should see "2. The Flower" within "#position_2"
    When I follow "Skipping Stones"
      Then I should see "Parent: Counting Drabbles (Series)"
      And I should see "Next: The Flower [sequel to Skipping Stones] (Single)"
      And I should see "Skipping Stones (Single)" within ".title"
      And I should NOT see "WIP" within ".omitteds"
    And my page named "Counting Drabbles" should have url: "https://archiveofourown.org/series/46"

  Scenario: deliberately fetch only one chapter
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "fandom"
      And I press "Store"
    Then I should see "Where am I? (Single)" within ".title"
      And I should NOT see "WIP" within ".omitteds"
      And I should NOT see "1."
      And I should see "by Sidra"
      And I should see "Using time-travel"
      And I should NOT see "Hogwarts"
      And I should NOT see "giving up on nanowrimo"
    And my page named "Where am I?" should have url: "https://archiveofourown.org/works/692/chapters/803"

  Scenario: refetch one chapter from ao3
    Given I have no pages
    And a tag exists with name: "harry potter" AND type: "Fandom"
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/803"
      And I select "harry potter" from "fandom"
      And I press "Store"
      Then I should see "Where am I? (Single)" within ".title"
      And I should NOT see "WIP" within ".omitteds"
    When I follow "Notes"
      And I fill in "page_notes" with "changed notes"
      And I press "Update"
    Then I should see "changed notes" within ".notes"
      And I should NOT see "by Sidra" within ".notes"
    And I follow "Edit Raw HTML"
      And I fill in "pasted" with "oops"
      And I press "Update Raw HTML"
      And I view the content
    Then I should see "oops"
      And I should NOT see "Amy woke slowly"
    When I am on the page with title "Where am I?"
      And I follow "Refetch"
      Then the "url" field should contain "https://archiveofourown.org/works/692/chapters/803"
    When I press "Refetch"
    Then I should see "Refetched" within "#flash_notice"
      Then I should see "Where am I?" within ".title"
      And I should NOT see "1."
      And I should see "by Sidra" within ".notes"
      And I should NOT see "changed notes" within ".notes"
      And I should NOT see "WIP" within ".omitteds"
      When I view the content
      Then I should NOT see "oops"
      And I should see "Amy woke slowly"

  Scenario: refetching top level fic shouldn't change chapter titles if i've modified them
    Given I have no pages
     And Time Was exists
    When I am on the page with title "Hogwarts"
      And I follow "Manage Parts"
      And I fill in "title" with "Hogwarts (abandoned)"
      And I press "Update"
      And I follow "Time Was, Time Is"
    Then I should see "Hogwarts (abandoned)" within "#position_2"
    When I follow "Refetch"
      And I press "Refetch"
    Then I should see "Refetched" within "#flash_notice"
    Then I should see "Hogwarts (abandoned)" within "#position_2"

  Scenario: adding a url to a Work
    Given I have no pages
      And Where am I exists
    When I am on the homepage
      And I follow "Where am I"
      Then I should see "Where am I? (Single)" within ".title"
      And I should NOT see "WIP" within ".omitteds"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
      And I follow "Refetch"
    Then I should see "archiveofourown.org/works/692/chapters/803" within "#url_list"
      And the "url" field should contain "https://archiveofourown.org/works/692"
    When I press "Refetch"
    Then I should see "Refetched" within "#flash_notice"
    Then I should see "Time Was, Time Is (Book)" within ".title"
    And I should see "WIP" within ".omitteds"
    When I follow "Where am I?"
      Then I should see "Where am I? (Chapter)" within ".title"
      And I should NOT see "WIP" within ".omitteds"
    When I follow "Time Was, Time Is"
      And I follow "Refetch"
      Then the "url" field should contain "https://archiveofourown.org/works/692"
      But the page should NOT contain css "#url_list"

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
    Then I should see "Refetched" within "#flash_notice"
    Then I should see "Counting Drabbles (Series)" within ".title"
    When I follow "The Flower"
      Then I should see "The Flower [sequel to Skipping Stones] (Single)" within ".title"

  Scenario: fetching a series from before all the works had urls
    Given I have no pages
      And Misfits exists
    When I am on the homepage
      And I follow "Misfit Series"
    Then I should see "Misfit Series (Series)" within ".title"
    When I follow "Refetch"
      Then I should see "A Misfit Working Holiday In New York" within "#url_list"
    When I fill in "url" with "https://archiveofourown.org/series/334075"
    And I press "Refetch"
    Then I should see "Refetched" within "#flash_notice"
    Then I should see "Misfits (Series)" within ".title"
      Then I should see "Three Misfits in New York" within "#position_1"
      And I should see "A Misfit Working Holiday In New York" within "#position_2"
    And I should have 3 pages

  Scenario: creating a series when I already have one of its singles
    Given I have no pages
      And a tag exists with name: "harry potter" AND type: "Fandom"
      And Skipping Stones exists
    When I am on the homepage
      And I fill in "page_url" with "https://archiveofourown.org/series/46"
      And I select "harry potter" from "fandom"
      And I press "Store"
    Then I should see "Counting Drabbles (Series)" within ".title"
      And I should see "Skipping Stones" within "#position_1"
      And I should see "The Flower" within "#position_2"
    And I should have 3 pages

  Scenario: creating a series when I already have one of its books
    Given I have no pages
      And Misfits exists
    When I am on the homepage
      And I follow "Misfit Series"
      And I press "Uncollect"
    Then I should have 4 pages
    When I am on the homepage
      And I fill in "page_url" with "https://archiveofourown.org/series/334075"
      And I press "Store"
      And I follow "Misfit"
    Then I should see "Three Misfits in New York" within "#position_1"
      And I should see "A Misfit Working Holiday In New York" within "#position_2"
    And I should have 5 pages

  Scenario: refetching a one-page Single into a Book
    Given I have no pages
      And a tag exists with name: "harry potter" AND type: "Fandom"
      And an author exists with name: "Sidra"
      And Where am I existed and was read
    When I am on the homepage
      And I follow "Where am I"
      Then I should see "Where am I? (Single)" within ".title"
      And I should see "5" within ".stars"
      And I should see "WIP" within ".omitteds"
      And I should see "harry potter" within ".fandoms"
      And I should see "Sidra" within ".authors"
      And I should NOT see "unread"
      And last read should be today
    When I follow "Refetch"
      Then the "url" field should contain "https://archiveofourown.org/works/692"
    When I press "Refetch"
    Then I should see "Refetched" within "#flash_notice"
    And I follow "Time Was, Time Is" within ".parent"
    Then I should see "parts unread"
    And I should see "harry potter" within ".fandoms"
    And I should see "Sidra" within ".authors"
    And I should see "Where am I?" within "#position_1"
    And I should see "5" within "#position_1"
    But I should NOT see "harry potter" within "#position_1"
    But I should NOT see "Sidra" within "#position_1"
    And I should see "Hogwarts" within "#position_2"
    And I should see "unread" within "#position_2"
