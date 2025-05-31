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

Scenario: make a single into a book 
  Given Where am I existed and was read
  When I am on the page's page
    And I press "Make Me a Chapter"
  Then I should have 2 pages
    And I should see "Parent: Time Was, Time Is (Book)"
    And I should see "temp (Chapter)"
    And my page named "Time Was, Time Is" should not have a parent

Scenario: adding a url after making a single into a book
  Given Where am I existed and was read
  When I am on the page's page
    And I press "Make Me a Chapter"
    And I follow "Refetch"
    And I fill in "url" with "https://archiveofourown.org/works/692/chapters/804"
    And I press "Refetch"
    And I press "Rebuild Meta"
  Then my page named "Where am I?" should have url: "https://archiveofourown.org/works/692/chapters/804"
