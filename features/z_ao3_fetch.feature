Feature: ao3 specific stuff

Scenario: grab a single
  Given "popslash" is a "Fandom"
    And "Sidra" is an "Author"
    And I am on the homepage
  When I fill in "page_url" with "http://archiveofourown.org/works/68481/"
    And I press "Store"
  Then I should NOT see "Title can't be blank"
    And I should NOT see "Select tags"
    And I should see "I Drive Myself Crazy (Single)" within ".title"
    And I should NOT see "WIP" within ".cons"
    And I should see "popslash" within ".fandoms"
    And I should see "please no crossovers" within ".notes"
    And I should NOT see "Popslash" within ".notes"
    And I should see "AJ/JC" within ".notes"
    And I should see "Make the Yuletide Gay" within ".notes"
    And I should see "Sidra" within ".authors"
    And I should NOT see "by Sidra" within ".notes"
    And my page named "I Drive Myself Crazy" should have url: "https://archiveofourown.org/works/68481"

Scenario: grab a book
  Given "harry potter" is a "Fandom"
    And I am on the create page
  When I fill in "page_url" with "https://archiveofourown.org/works/692/"
    And I select "harry potter" from "fandom"
    And I press "Store"
  Then I should see "Time Was, Time Is (Book)" within ".title"
    And I should see "WIP" within ".cons"
    And I should see "1,581 words" within ".size"
    And I should see "by Sidra" within ".notes"
    And I should see "harry potter" within ".fandoms"
    And I should see "Using time-travel" within ".notes"
    And I should see "abandoned, Mary Sue" within ".notes"
    And I should see "written for nanowrimo" within ".notes"
    And I should see "1. Where am I?" within "#position_1"
    And I should NOT see "written for nanowrimo" within "#position_1"
    And I should see "2. Hogwarts" within "#position_2"
    And I should see "giving up on nanowrimo" within "#position_2"
    And my page named "Time Was, Time Is" should have url: "https://archiveofourown.org/works/692"

 Scenario: grab a series
  Given "harry potter" is a "Fandom"
    And I am on the homepage
  When I fill in "page_url" with "http://archiveofourown.org/series/46"
    And I press "Store"
  Then I should see "Counting Drabbles (Series)" within ".title"
    And I should see "200 words" within ".size"
    And I should see "by Sidra" within ".notes"
    And I should see "harry potter" within ".fandoms"
    And I should NOT see "Harry Potter" before "Harry Potter/Unknown" within ".notes"
    And I should see "Implied snarry" within ".notes"
    And I should see "thanks to lauriegilbert!" within ".notes"
    And I should see "1. Skipping Stones" within "#position_1"
    And I should see "2. The Flower" within "#position_2"
    And my page named "Counting Drabbles" should have url: "https://archiveofourown.org/series/46"

Scenario: deliberately fetch only one chapter
  Given "harry potter" is a "Fandom"
    And I am on the create page
    And I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/803"
    And I select "harry potter" from "fandom"
  When I press "Store"
  Then I should see "Where am I? (Single)" within ".title"
    And I should NOT see "WIP" within ".cons"
    And I should NOT see "1."
    And I should see "by Sidra"
    And I should see "Using time-travel"
    And I should NOT see "Hogwarts"
    And I should NOT see "giving up on nanowrimo"
    And my page named "Where am I?" should have url: "https://archiveofourown.org/works/692/chapters/803"

Scenario: refetch Single
  Given "harry potter" is a "Fandom"
    And Where am I exists
    And I am on the page with title "Where am I?"
    And I follow "Notes"
    And I fill in "page_notes" with "changed notes"
    And I press "Update"
    And I follow "Edit Raw HTML"
    And I fill in "pasted" with "oops"
    And I press "Update Raw HTML"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Where am I?" within ".title"
    And I should NOT see "1."
    And I should see "by Sidra" within ".notes"
    And I should NOT see "changed notes" within ".notes"
    And I should NOT see "WIP" within ".cons"
    And the contents should include "Amy woke slowly"
    But the contents should NOT include "oops"

Scenario: refetching top level fic shouldn't change chapter titles if i've modified them
  Given Time Was exists
  When I am on the page with title "Hogwarts"
    And I follow "Manage Parts"
    And I fill in "title" with "Hogwarts (abandoned)"
    And I press "Update"
    And I follow "Time Was, Time Is"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Hogwarts (abandoned)" within "#position_2"

Scenario: getting book by adding parent and then refetching
  Given Where am I exists
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "add_parent" with "Parent"
    And I press "Update"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Time Was, Time Is (Book)" within ".title"
    And I should see "WIP" within ".cons"
    And I should see "Where am I?" within "#position_1"
    And I should see "Hogwarts" within "#position_2"

Scenario: fetching a series from before all the works had urls
  Given Misfits existed
  When I am on the page with title "Misfit Series"
    And I follow "Refetch"
    And I fill in "url" with "https://archiveofourown.org/series/334075"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Misfits (Series)" within ".title"
    And I should see "Three Misfits in New York" within "#position_1"
    And I should see "A Misfit Working Holiday In New York" within "#position_2"
    And I should have 7 pages

Scenario: storing a series when I already have one of its singles
  Given "harry potter" is a "Fandom"
    And Skipping Stones exists
  When I am on the homepage
    And I fill in "page_url" with "https://archiveofourown.org/series/46"
    And I press "Store"
  Then I should see "Counting Drabbles (Series)" within ".title"
    And I should see "harry potter" within ".fandoms"
    And I should see "Skipping Stones" within "#position_1"
    And I should see "by Sidra; Harry Potter/Unknown;" within "#position_1"
    And I should see "The Flower" within "#position_2"
    And I should have 3 pages

Scenario: creating a series when I already have its books
  Given Misfits existed
    And I am on the homepage
    And I follow "Misfit Series"
    And I press "Uncollect"
  When I am on the homepage
    And I fill in "page_url" with "https://archiveofourown.org/series/334075"
    And I press "Store"
  Then I should see "Page created"
    And I should see "Misfits (Series)" within ".title"
    And I should see "Other Fandom" within ".fandoms"
    And I should see "Three Misfits in New York" within "#position_1"
    And I should see "A Misfit Working Holiday In New York" within "#position_2"
    And I should have 7 pages

Scenario: refetching a one-page Single into a Book
  Given "harry potter" is a "Fandom"
    And "Sidra" is an "Author"
    And Where am I existed and was read
  When I am on the page with title "Time Was, Time Is"
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "Where am I? (Chapter)" within ".title"
    And I should NOT see "written for nanowrimo"
    But I should NOT see "Using time-travel"
    And I should see "Time Was, Time Is" within ".parent"
    And I should see "Hogwarts" within ".part"

Scenario: refetch from ao3 when it used to be somewhere else
  Given counting exists
    And I am on the page with title "Counting"
    And I follow "Refetch" within ".edits"
    And I fill in "url" with "http://archiveofourown.org/works/688"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "by Sidra"
    And I should NOT see "ambtus"
    And I should see "Skipping Stones (Single)" within ".title"
    And I should see "thanks to lauriegilbert"
    And the contents should include "Skip. Skip."

Scenario: fetch a work from a collection
  Given I am on the homepage
  When I fill in "page_url" with "https://archiveofourown.org/collections/Heliocentrism/works/21684820"
    And I press "Store"
  Then my page named "A Conversation Overheard by a Captive Faking Unconsciousness" should have url: "https://archiveofourown.org/works/21684820"
