Feature: ff.net meta

Scenario: fanfiction older format
  Given stuck exists
  When I am on the page's page
  Then I should see "Stuck!" within ".title"
    And I should see "by kolyaaa" within ".notes"
    And I should see "Stargate" within ".notes"
    And I should see "A very annoying regular character is turned into a kid" within ".notes"
    And I should see "A Scowl Like a Thundercloud" within "#position_1"
    But I should NOT see "Stargate" within "#position_1"
    And I should NOT see "A very annoying regular character" within "#position_1"
    And I should NOT see "kolyaaa" within "#position_1"

Scenario: newer format
  Given ibiki exists
  When I am on the page's page
  Then I should see "Ibiki's Apprentice" within ".title"
    And I should see "by May Wren" within ".notes"
    And I should see "Naruto" within ".notes"
    And I should see "teachers thought they were getting one over on the Hokage" within ".notes"

Scenario: fanfiction Single meta
  Given skipping exists
  When I am on the page's page
  Then I should see "Skipping Stones (Single)" within ".title"
    But I should NOT see "1. " within ".title"
    And I should see "by ambtus" within ".notes"
    And I should see "Harry Potter" within ".notes"
    And I should see "2 connected drabbles" within ".notes"

Scenario: fanfiction Book meta
  Given counting exists
  When I am on the page's page
  Then I should see "Counting (Book)" within ".title"
    And I should see "by ambtus" within ".notes"
    And I should see "Harry Potter" within ".notes"
    And I should see "2 connected drabbles" within ".notes"
    And I should see "Skipping Stones (unread, 100 words)" within "#position_1"
    And I should see "The Flower (unread, 100 words)" within "#position_2"
    But I should NOT see "ambtus" within ".parts"
    And I should NOT see "Harry Potter" within ".parts"
    And I should NOT see "2 connected drabbles" within ".parts"

Scenario: check before adding a parent
  Given He Could Be A Zombie exists
  When I am on the page's page
  Then I should see "He Could Be A Zombie (Single)" within ".title"
    And I should see "by Sarah1281" within ".notes"
    And I should see "Naruto" within ".notes"
    And I should see "After receiving a time travel jutsu" within ".notes"

Scenario: fanfiction book from adding a parent
  Given He Could Be A Zombie exists
    And I am on the page's page
  When I add a parent with title "good cause"
  Then I should see "It's For a Good Cause, I Swear!" within ".title"
    And I should see "by Sarah1281" within ".notes"
    And I should see "Naruto" within ".notes"
    And I should see "After receiving a time travel jutsu" within ".notes"
    And I should see "He Could Be A Zombie" within "#position_1"
    But I should NOT see "Sarah1281" within "#position_1"
    And I should NOT see "Naruto" within "#position_1"
    And I should NOT see "After receiving a time travel jutsu" within "#position_1"

Scenario: don't rename chapters that i've named or delete notes that i've added
  Given Child of Four exists
  When I am on the page's page
  Then I should see "Child of Four (Book)" within ".title"
    And I should see "by sarini" within ".notes"
    And I should see "Harry Potter" within ".notes"
    And I should see "The difference one spell can make" within ".notes"
    And I should see "Introduction" within "#position_1"
    And I should see "This story takes place in an Alternate Universe" within "#position_1"
    And I should see "First Year" within "#position_3"
