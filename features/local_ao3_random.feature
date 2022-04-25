Feature: ao3 testing that can use local files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: ao3 with and without chapter titles
  Given Open the Door exists
  When I am on the page with title "Open the Door"
  Then I should see "Chapter 1" within "#position_1"
    And I should see "2. Ours" within "#position_2"
    But I should NOT see "1. Chapter 1"
    And the part titles should be stored as "Chapter 1 & Ours"

Scenario: deliberately fetch chapter 1 shows summary and notes
  Given Where am I exists
  When I am on the homepage
    And I follow "Where am I"
  Then I should see "Where am I? (Single)" within ".title"
    And I should see "Using time-travel"
    And I should see "written for"

Scenario: multiple fandoms and author on a Single
  Given Alan Rickman exists
  When I am on the page's page
  Then I should see "Other Fandom" within ".fandoms"
    And I should see "Harry Potter, Die Hard, Robin Hood" within ".notes"
    And I should see "by manicmea" within ".notes"
    But I should NOT see "Rowling" within ".notes"
    And I should NOT see "Movies" within ".notes"
    And I should NOT see "Prince" within ".notes"
    And I should NOT see "1991" within ".notes"

Scenario: meta on second chapter of book
  Given "harry potter" is a "Fandom"
    And Time Was exists
  When I am on the page with title "Hogwarts"
    Then I should see "Hogwarts (Chapter)" within ".title"
    Then I should NOT see "by Sidra" within ".notes"
    And I should NOT see "Using time-travel" within ".notes"
    And I should NOT see "abandoned" within ".notes"
    But the part titles should be stored as "Where am I? & Hogwarts"

Scenario: meta on first book of series
  Given "harry potter" is a "Fandom"
    And Counting Drabbles exists
  When I am on the page with title "Skipping Stones"
    Then I should see "Parent: Counting Drabbles (Series)"
    And I should see "Next: The Flower [sequel to Skipping Stones] (Single)"
    And I should see "Skipping Stones (Single)" within ".title"
    And I should NOT see "WIP" within ".cons"

Scenario: one chapter from ao3 is a Single
  Given Where am I exists
  When I am on the page with title "Where am I?"
  Then I should see "Where am I? (Single)" within ".title"

Scenario: do not duplicate fandom and author in notes of works in series
  Given Counting Drabbles exists
  When I am on the page's page
  Then I should see "by Sidra" before "Harry Potter" within ".notes"
    And I should see "Skipping Stones" within "#position_1"
    And I should see "The Flower [sequel to Skipping Stones]" within "#position_2"
    But I should NOT see "by Sidra" within "#position_1"
    And I should NOT see "Harry Potter; Harry Potter" within "#position_1"
    And I should NOT see "by" within "#position_1"

Scenario: do NOT overwrite raw html if Single has been deleted
  Given The Right Path exists
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "error retrieving content" within "#flash_alert"
    And the contents should include "Ben Solo is ten years old"

Scenario: do NOT overwrite raw html if Book has been deleted
  Given Brave New World exists
  When I am on the page with title "Brave New World"
     And I follow "Refetch"
     And I press "Refetch"
  Then I should see "error retrieving content" within "#flash_alert"
    And the contents should include "With two sets of eyes on him now, Draco gulped"

Scenario: do NOT overwrite raw html if chapter of Book has been deleted
  Given Brave New World exists
  When I am on the page with title "Chapter 2"
     And I follow "Refetch"
     And I press "Refetch"
  Then I should see "error retrieving content" within "#flash_alert"
    And the contents should include "With two sets of eyes on him now, Draco gulped"

Scenario: do NOT overwrite raw html if book of series has been deleted
  Given Iterum Rex exists
  When I am on the page with title "Brave New World"
     And I follow "Refetch"
     And I press "Refetch"
  Then I should see "error retrieving content" within "#flash_alert"
    And the contents should include "With two sets of eyes on him now, Draco gulped"

Scenario: do NOT rebuild meta if series has been deleted before raw html exists
  Given Iterum Rex exists
  When I am on the page with title "Iterum Rex"
    And I press "Rebuild Meta"
  Then I should see "error retrieving content" within "#flash_alert"
    And the notes should be empty

Scenario: do NOT overwrite meta if Single has been deleted
  Given The Right Path exists
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch Meta"
  Then I should see "error retrieving content" within "#flash_alert"
    And the notes should include "Star Wars"

Scenario: do NOT overwrite meta if Book has been deleted
  Given Brave New World exists
  When I am on the page with title "Brave New World"
     And I follow "Refetch"
     And I press "Refetch Meta"
  Then I should see "error retrieving content" within "#flash_alert"
    And the notes should include "Harry Potter"
