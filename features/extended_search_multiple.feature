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
    Given I have no pages
      And the following pages
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
