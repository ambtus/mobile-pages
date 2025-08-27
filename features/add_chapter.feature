Feature: add chapter to book

Scenario: add second ao3 chapter
  Given Time Was partially exists
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/804"
    And I press "Add Chapter"
  Then I should have 3 pages
    And I should see "Added temp to Time Was"

Scenario: paste basic html
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

Scenario: paste actual html and get ao3 meta
  Given Time Was partially exists
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/804"
    And I press "Add Chapter"
    And I enter raw html for "hogwarts"
    And I press "Update Raw HTML"
  Then I should see "Hogwarts (Chapter)"
    And I should see "187 words"
    And I should see "giving up on nanowrimo"

Scenario: make an ao3 single into a book
  Given Where am I existed and was read
  When I am on the first page's page
    And I press "Make Me a Chapter"
  Then I should have 2 pages
    And I should see "Parent: Time Was, Time Is (Book)"
    And I should see "temp (Chapter)"
    And my page named "Time Was, Time Is" should not have a parent

Scenario: adding it;s chapter url after making a single into a book
  Given Where am I existed and was read
  When I am on the first page's page
    And I press "Make Me a Chapter"
    And I follow "Refetch"
    And I fill in "url" with "https://archiveofourown.org/works/692/chapters/804"
    And I press "Refetch"
    And I press "Rebuild Meta"
  Then my page named "Where am I?" should have url: "https://archiveofourown.org/works/692/chapters/804"

Scenario: paste html and update parent (before)
  Given Time Was partially exists
  When I am on the pages page
  Then I should see "Time Was, Time Is"
    And I should see "1,394 words (1 part)"

Scenario: paste html and update parent (after)
  Given Time Was partially exists
  When I am on the mini page
    And I fill in "page_url" with "https://archiveofourown.org/works/692/chapters/804"
    And I press "Add Chapter"
    And I enter raw html for "hogwarts"
    And I press "Update Raw HTML"
    And I am on the pages page
  Then I should see "1,581 words (2 parts)"

Scenario: add second ff chapter (before)
  Given stuck exists
  Then I should have 2 pages
    And my page named "Stuck!" should have url: "https://www.fanfiction.net/s/2652996"
    And my page named "1:A Scowl Like a Thundercloud" should have url: "https://www.fanfiction.net/s/2652996/1"

Scenario: add second ff chapter
  Given stuck exists
  When I am on the mini page
    And I fill in "page_url" with "https://www.fanfiction.net/s/2652996/2/Stuck"
    And I press "Add Chapter"
  Then I should have 3 pages
    And I should see "Added temp to Stuck!"
  And my page named "temp" should have url: "https://www.fanfiction.net/s/2652996/2"

