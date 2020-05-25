Feature: filter on titles

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
     Then I should see "A Christmas Carol" within "#position_1"
       And I should see "The Call of the Wild" within "#position_2"
       And I should see "The Mysterious Affair" within "#position_3"
      And I am on the homepage
     When I fill in "page_title" with "Chris"
      And I press "Find"
     Then I should see "A Christmas Carol" within "#position_1"
       And I should not see "The Call of the Wild"
       And I should see "The Mysterious Affair" within "#position_2"
     When I follow "A Christmas Carol"
     Then I should see "A Christmas Carol" within ".title"

  Scenario: No matching title
    Given a page exists
    When I am on the homepage
    Then I should see "Page 1"
    And I fill in "page_title" with "Pages"
      And I press "Find"
    Then I should see "No pages found" within "#flash_alert"
      And I should not see "Page 1"

  Scenario: limit number of found pages
    Given 16 pages exist
     When I am on the homepage
     Then I should see "Page 1"
       And I should see "Page 2"
       And I should see "Page 14"
       And I should see "Page 15"
     But I should not see "Page 16"
     When I fill in "page_title" with "Page 16"
       And I press "Find"
     Then I should see "Page 16" within "#position_1"
       And I should not see "Page 2"
     When I fill in "page_title" with "Page 1"
       And I press "Find"
     Then I should see "Page 1"
       And I should see "Page 11"
       And I should see "Page 10"
       And I should see "Page 16"
     But I should not see "Page 2"
       And I should not see "Page 6"
       And I should not see "Page 9"
     When I fill in "page_title" with "page"
       And I press "Find"
     Then I should see "Page 1"
       And I should see "Page 2"
       And I should see "Page 9"
       And I should see "Page 14"
       And I should see "Page 15"
     But I should not see "Page 16"
     When I follow "Rate" within "#position_2"
      And I choose "very interesting"
      And I choose "very sweet"
     And I press "Rate"
     When I am on the homepage
     Then I should see "Page 16"
     But I should not see "Page 2"
