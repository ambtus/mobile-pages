Feature: Basic Search
  what: find a specific document
  why: If I know what I want to read
  result: be offered the page I ask for

  Scenario Outline: Find page by title
    Given I have no pages
      And the following pages
      | title                                              | url                                   |
      | A Christmas Carol by Charles Dickens               | http://sidrasue.com/tests/cc.html   |
      | The Call of the Wild by Jack London                | http://sidrasue.com/tests/cotw.html |
      | The Mysterious Affair at Styles by Agatha Christie | http://sidrasue.com/tests/maas.html |
      And I am on the homepage
     When I fill in "search" with "<search>"
      And I press "Search"
     Then I should see "<title>" in ".title"
      And I should see "<content>" in ".content"

    Examples:
      | search                               | title                            | content                                    |
      | A Christmas Carol by Charles Dickens | A Christmas Carol                | Marley was dead: to begin with.            |
      | The Call                             | The Call of the Wild             | Buck did not read the newspapers           |
      | Styles                               | The Mysterious Affair at Styles  | The intense interest aroused in the public |

  Scenario: No matching page
    Given I have no pages
      And the following page
      | title            | url                                   |
      | War              | http://sidrasue.com/tests/test.html   |
      And I am on the homepage
    When I fill in "search" with "War and Peace"
      And I press "Search"
    Then I should see "War and Peace not found" in "#flash_error"
