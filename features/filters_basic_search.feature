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
       And I fill in "page_title" with "The Call"
       And I press "Find"
     Then I should see "The Call of the Wild by Jack London" within ".title"
     When I am on the homepage
       And I fill in "page_title" with "Carol"
       And I press "Find"
     Then I should see "A Christmas Carol by Charles Dickens" within ".title"
     When I am on the homepage
       And I fill in "page_title" with "Styles"
       And I press "Find"
     Then I should see "The Mysterious Affair at Styles by Agatha Christie" within ".title"
     When I am on the homepage
       And I fill in "page_title" with "A Christmas Carol by Charles Dickens"
       And I press "Find"
     Then I should see "A Christmas Carol by Charles Dickens" within ".title"

  Scenario: No matching page
    Given a titled page exists
    When I am on the homepage
    Then I should see "page 1"
    And I fill in "page_title" with "10"
      And I press "Find"
    Then I should see "No pages found" within "#flash_alert"
      And I should not see "page 1"
