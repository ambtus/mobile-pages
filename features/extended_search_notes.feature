Feature: extended search on notes

  Scenario: Find page by notes only after title fails
    Given the following pages
      | title                                              | url                                 | notes                   |
      | A Christmas Carol by Charles Dickens               | http://test.sidrasue.com/cc.html   | ghosts (not mysterious) |
      | The Call of the Wild by Jack London                | http://test.sidrasue.com/cotw.html | dogs (no christmas)     |
      | The Mysterious Affair at Styles by Agatha Christie | http://test.sidrasue.com/maas.html | poirot (wild!)          |
    When I am on the homepage
      And I fill in "search" with "christmas"
      And I press "Search"
    Then I should see "A Christmas Carol" in ".title"
    When I am on the homepage
      And I fill in "search" with "wild"
      And I press "Search"
    Then I should see "The Call of the Wild" in ".title"
    When I am on the homepage
      And I fill in "search" with "mysterious"
      And I press "Search"
    Then I should see "The Mysterious Affair at Styles" in ".title"
    When I am on the homepage
      And I fill in "search" with "ghosts"
      And I press "Search"
    Then I should see "A Christmas Carol" in ".title"
    When I am on the homepage
      And I fill in "search" with "dogs"
      And I press "Search"
    Then I should see "The Call of the Wild" in ".title"
    When I am on the homepage
      And I fill in "search" with "poirot"
      And I press "Search"
    Then I should see "The Mysterious Affair at Styles" in ".title"
