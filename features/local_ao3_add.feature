Feature: add chapter to ao3 book

Scenario: add second chapter
  Given Time Was partially exists
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/804"
    And I press "Add Chapter"
  Then I should have 3 pages
    And I should see "Added temp to Time Was"

Scenario: paste html
  Given Time Was partially exists
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/804"
    And I press "Add Chapter"
    And I fill in "pasted" with "<p>pasted content</p>"
    And I press "Update Raw HTML"
  Then I should see "Parent: Time Was, Time Is (Book)"
    And I should see "Previous: Where am I? (Chapter)"
    And I should see "Chapter 2 (Chapter)"
    And I should see "2 words"

Scenario: paste actual html and get meta
  Given Time Was partially exists
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/804"
    And I press "Add Chapter"
    And I enter raw html for "hogwarts"
    And I press "Update Raw HTML"
  Then I should see "Hogwarts (Chapter)"
    And I should see "187 words"
    And I should see "giving up on nanowrimo"
