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
    Given the following pages
      | title   |
      | page 1  |
      | page 2  |
      | page 3  |
      | page 4  |
      | page 5  |
      | page 6  |
      | page 7  |
      | page 8  |
      | page 9  |
      | page 10 |
      | page 11 |
      | page 12 |
      | page 13 |
      | page 14 |
      | page 15 |
      | page 16 |
      | page 17 |
      | page 18 |
      | page 19 |
      | page 20 |
      | page 21 |
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
     
