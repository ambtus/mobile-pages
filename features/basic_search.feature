Feature: Basic Search
  what: find a specific document
  why: If I know what I want to read
  result: be offered the page I ask for

  Scenario Outline: Find page by title
    Given the following pages
      | title                                              | url                                   |
      | A Christmas Carol by Charles Dickens               | http://www.rawbw.com/~alice/cc.html   |
      | The Call of the Wild by Jack London                | http://www.rawbw.com/~alice/cotw.html |
      | The Mysterious Affair at Styles by Agatha Christie | http://www.rawbw.com/~alice/maas.html |
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
    Given the following page
      | title            | url                                   |
      | War              | http://www.rawbw.com/~alice/test.html   |
      And I am on the homepage
    When I fill in "search" with "War and Peace"
      And I press "Search"
    Then I should see "Not found" in "#flash_error"
