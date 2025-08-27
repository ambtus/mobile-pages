Feature: ff.net meta

Scenario: fanfiction Share button gets cleaned
  Given skipping exists
  Then the contents should include "Skip. Skip."
    But the contents should NOT include "Share"

Scenario: fanfiction underline spans don't get cleaned
  Given He Could Be A Zombie exists
  Then the contents should NOT include "But I so I ,"
    But the contents should include "But I wasn't so I didn't,"

Scenario: fanfiction older format
  Given stuck exists
  When I am on the first page's page
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
  When I am on the first page's page
  Then I should see "Ibiki's Apprentice" within ".title"
    And I should see "by May Wren" within ".notes"
    And I should see "Naruto" within ".notes"
    And I should see "teachers thought they were getting one over on the Hokage" within ".notes"

Scenario: unavoidable fanfiction first chapter doesn't get chapter_as_single
  Given skipping exists
  When I am on the first page's page
  Then I should see "Counting (Single)" within ".title"
    And I should see "by ambtus" within ".notes"
    And I should see "Harry Potter" within ".notes"
    And I should see "2 connected drabbles" within ".notes"

Scenario: fanfiction chapter as Single behavior
  Given the flower exists
  When I am on the first page's page
  Then I should see "The Flower (Single)" within ".title"
    And I should see "by ambtus" within ".notes"
    And I should see "Harry Potter" within ".notes"
    But I should NOT see "2 connected drabbles" within ".notes"

Scenario: fanfiction Chapter of Book meta
  Given counting exists
  When I am on the first page's page
    And I follow "Skipping Stones"
  Then I should see "Skipping Stones (Chapter)" within ".title"
    And I should NOT see "1. " within ".title"
    And I should NOT see "by ambtus" within ".notes"
    And I should NOT see "Harry Potter" within ".notes"
    And I should NOT see "2 connected drabbles" within ".notes"

Scenario: fanfiction Book meta
  Given counting exists
  When I am on the first page's page
  Then I should see "Counting (Book)" within ".title"
    And I should see "200 words (2 parts)" within ".size"
    And I should see "unread" within ".last_read"
    And I should see "by ambtus" within ".notes"
    And I should see "Harry Potter" within ".notes"
    And I should see "2 connected drabbles" within ".notes"
    And I should see "Skipping Stones" within "#position_1"
    And I should see "unread" within "#position_1"
    And I should see "100 words" within "#position_1"
    And I should see "The Flower" within "#position_2"
    And I should see "unread" within "#position_2"
    And I should see "100 words" within "#position_2"

Scenario: fanfiction match authors
  Given "Sidra (ambtus)" is an "Author"
    And counting exists
  When I am on the first page's page
  Then I should see "Sidra" within ".authors"
    And I should NOT see "ambtus"

Scenario: check before adding a parent
  Given He Could Be A Zombie exists
  When I am on the first page's page
  Then I should see "He Could Be A Zombie (Single)" within ".title"
    And I should see "by Sarah1281" within ".notes"
    And I should see "Naruto" within ".notes"
    But I should NOT see "After receiving a time travel jutsu" within ".notes"

Scenario: fanfiction single to chapter by adding a parent
  Given He Could Be A Zombie exists
    And I am on the first page's page
  When I add a parent with title "good cause"
    And I follow "He Could Be A Zombie" within "#position_1"
  Then I should see "He Could Be A Zombie (Chapter)" within ".title"

Scenario: fanfiction book from adding a parent
  Given He Could Be A Zombie exists
    And I am on the first page's page
  When I add a parent with title "good cause"
  Then I should see "It's For a Good Cause, I Swear! (Book)" within ".title"
    And I should see "by Sarah1281" within ".notes"
    And I should see "Naruto" within ".notes"
    And I should see "After receiving a time travel jutsu" within ".notes"
    And I should see "He Could Be A Zombie" within "#position_1"
    But I should NOT see "Sarah1281" within "#position_1"
    And I should NOT see "Naruto" within "#position_1"
    And I should NOT see "After receiving a time travel jutsu" within "#position_1"

Scenario: don't rename chapters that i've named or delete notes that i've added
  Given Child of Four exists
  When I am on the first page's page
  Then I should see "Child of Four (Book)" within ".title"
    And I should see "by sarini" within ".notes"
    And I should see "Harry Potter" within ".notes"
    And I should see "The difference one spell can make" within ".notes"
    And I should see "Introduction" within "#position_1"
    And I should see "This story takes place in an Alternate Universe" within "#position_1"
    And I should see "First Year" within "#position_3"

Scenario: rebuild meta after updating raw html
  Given I am on the mini page
    And I fill in "page_url" with "https://www.fanfiction.net/s/5853866/2/Counting"
    And I press "Store"
  When I edit the raw html with "counting2"
  Then I should see "The Flower" within ".title"
    And I should see "100 words"
    And I should see "by ambtus" within ".notes"
    And I should see "Harry Potter" within ".notes"
    But I should NOT see "2 connected drabbles" within ".notes"
    And the contents should include "It is said this purple flower"
