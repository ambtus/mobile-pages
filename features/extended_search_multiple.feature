Feature: Multiple Search
  what: search returns more than one page
  why: there are two pages with the title substring
  result: get a list of titles to select from

  Scenario: Find pages by title
    Given the following pages
      | title                                              | url                                   |
      | A Christmas Carol by Charles Dickens               | http://sidrasue.com/tests/cc.html   |
      | The Call of the Wild by Jack London                | http://sidrasue.com/tests/cotw.html |
      | The Mysterious Affair at Styles by Agatha Christie | http://sidrasue.com/tests/maas.html |
      And I am on the homepage
     When I fill in "search" with "by"
      And I press "Search"
     Then I should see "A Christmas Carol" in ".title"
       And I should see "The Call of the Wild" in ".title"
       And I should see "The Mysterious Affair" in ".title"
      And I am on the homepage
     When I fill in "search" with "Chris"
      And I press "Search"
     Then I should see "A Christmas Carol" in ".title"
       And I should not see "The Call of the Wild" in ".title"
       And I should see "The Mysterious Affair" in ".title"
     When I follow "Read"
     Then I should see "Marley was dead: to begin with."

  Scenario: Find pages by notes
    Given the following pages
      | title                           | notes                       | url                                   |
      | A Christmas Carol               | by Charles Dickens, classic | http://sidrasue.com/tests/cc.html   |
      | The Call of the Wild            | by Jack London, classic     | http://sidrasue.com/tests/cotw.html |
      | The Mysterious Affair at Styles | by Agatha Christie, mystery | http://sidrasue.com/tests/maas.html |
      And I am on the homepage
     When I fill in "search" with "by"
      And I press "Search"
     Then I should see "A Christmas Carol" in ".title"
       And I should see "The Call of the Wild" in ".title"
       And I should see "The Mysterious Affair" in ".title"
      And I am on the homepage
     When I fill in "search" with "Chris"
      And I press "Search"
     Then I should see "A Christmas Carol" in ".title"
       And I should not see "The Call of the Wild" in ".title"
       And I should not see "The Mysterious Affair" in ".title"
     When I am on the homepage
      And I fill in "search" with "classic"
      And I press "Search"
     Then I should see "A Christmas Carol" in ".title"
       And I should see "The Call of the Wild" in ".title"
       And I should not see "The Mysterious Affair" in ".title"

  Scenario: limit number of found pages
    Given I have no pages
      And the following pages
      | title   | read_after |
      | page 1  | 2009-01-01 |
      | page 2  | 2009-01-02 |
      | page 3  | 2009-01-03 |
      | page 4  | 2009-01-04 |
      | page 5  | 2009-01-05 |
      | page 6  | 2009-01-06 |
      | page 7  | 2009-01-07 |
      | page 8  | 2009-01-08 |
      | page 9  | 2009-01-09 |
      | page 10 | 2009-01-10 |
      | page 11 | 2009-01-11 |
      | page 12 | 2009-01-12 |
      | page 13 | 2009-01-13 |
      | page 14 | 2009-01-14 |
      | page 15 | 2009-01-15 |
      | page 16 | 2009-01-16 |
      | page 17 | 2009-01-17 |
      | page 18 | 2009-01-18 |
      | page 19 | 2009-01-19 |
      | page 20 | 2009-01-20 |
      | page 21 | 2009-01-21 |
     When I am on the homepage
     And I fill in "search" with "page"
       And I press "Search"
     Then I should see "page 1"
       And I should see "page 2"
       And I should see "page 19"
       And I should see "page 20"
     But I should not see "page 21"
     Then I follow "Rate"
     When I am on the homepage
     And I fill in "search" with "page 21"
       And I press "Search"
     Then I should see "page 21"
     Then I follow "Rate"
     
