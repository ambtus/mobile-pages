Feature: Basic Search
  what: find a specific document
  why: If I know what I want to read
  result: be offered the page I ask for

  Scenario: Find page by title (first, middle, last, and whole)
    Given the following pages
      | title                                              | url                                 |
      | A Christmas Carol by Charles Dickens               | http://sidrasue.com/tests/cc.html   |
      | The Call of the Wild by Jack London                | http://sidrasue.com/tests/cotw.html |
      | The Mysterious Affair at Styles by Agatha Christie | http://sidrasue.com/tests/maas.html |
     When I am on the homepage
       And I fill in "search" with "The Call"
       And I press "Search"
     Then I should see "The Call of the Wild by Jack London" in ".title"
     When I am on the homepage
       And I fill in "search" with "Carol"
       And I press "Search"
     Then I should see "A Christmas Carol by Charles Dickens" in ".title"
     When I am on the homepage
       And I fill in "search" with "Styles"
       And I press "Search"
     Then I should see "The Mysterious Affair at Styles by Agatha Christie" in ".title"
     When I am on the homepage
       And I fill in "search" with "A Christmas Carol by Charles Dickens"
       And I press "Search"
     Then I should see "A Christmas Carol by Charles Dickens" in ".title"

  Scenario: No matching page
    Given the following page
      | title            | url                                   |
      | War              | http://sidrasue.com/tests/test.html   |
      And I am on the homepage
    When I fill in "search" with "War and Peace"
      And I press "Search"
    Then I should see "War and Peace not found" in "#flash_error"
