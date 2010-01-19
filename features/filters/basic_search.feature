Feature: Basic Search
  what: find a specific document
  why: If I know what I want to read
  result: be offered the page I ask for

  Scenario: Find page by title (first, middle, last, and whole)
    Given the following pages
      | title                                              | 
      | A Christmas Carol by Charles Dickens               |
      | The Call of the Wild by Jack London                |
      | The Mysterious Affair at Styles by Agatha Christie |
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
    Given a titled page exists
    When I am on the homepage
    And I fill in "search" with "10"
      And I press "Search"
    Then I should see "10 not found" in "#flash_error"

  Scenario: No search criteria
    Given a titled page exists
    When I am on the homepage
      And I fill in "search" with ""
      And I press "Search"
    Then I should see "Please enter search criteria" in "#flash_error"
