Feature: stuff to do with titles

  Scenario: change title
    Given a page exists with title: "Old Title", url: "http://test.sidrasue.com/test.html"
      And I am on the page's page
    When I follow "Manage Parts"
      And I fill in "title" with "New Title"
      And I press "Update"
    Then I should see "New Title" within ".title"
    When I follow "HTML"
    Then I should see "Retrieved from the web" within ".content"

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
     When I fill in "page_title" with "by"
      And I press "Find"
     Then I should see "A Christmas Carol" within ".title"
       And I should see "The Call of the Wild" within ".title"
       And I should see "The Mysterious Affair" within ".title"
      And I am on the homepage
     When I fill in "page_title" with "Chris"
      And I press "Find"
     Then I should see "A Christmas Carol" within ".title"
       And I should not see "The Call of the Wild" within ".title"
       And I should see "The Mysterious Affair" within ".title"
     When I follow "A Christmas Carol"
     Then I should see "A Christmas Carol" within ".title"

  Scenario: No matching title
    Given a titled page exists
    When I am on the homepage
    Then I should see "page 1"
    And I fill in "page_title" with "10"
      And I press "Find"
    Then I should see "No pages found" within "#flash_alert"
      And I should not see "page 1"

  Scenario: limit number of found pages
    Given 16 titled pages exist
     When I am on the homepage
     Then I should see "page 1 title"
       And I should see "page 2"
       And I should see "page 14"
       And I should see "page 15"
     But I should not see "page 16"
     When I fill in "page_title" with "page 16"
       And I press "Find"
     Then I should see "page 16"
       And I should not see "page 1 title"
       And I should not see "page 6"
       And I should not see "page 15"
     When I fill in "page_title" with "page 1"
       And I press "Find"
     Then I should see "page 1"
       And I should see "page 11"
       And I should see "page 10"
       And I should see "page 16"
     But I should not see "page 2"
       And I should not see "page 6"
       And I should not see "page 9"
     When I fill in "page_title" with "page"
       And I press "Find"
     Then I should see "page 1 title"
       And I should see "page 2 title"
       And I should see "page 9 title"
       And I should see "page 14"
       And I should see "page 15"
     But I should not see "page 16"
     When I follow "Rate" within "#position_1"
       And I press "1"
     When I am on the homepage
     Then I should see "page 16"
       And I should see "page 2"
       And I should see "page 9"
       And I should see "page 10"
     But I should not see "page 1 title"
