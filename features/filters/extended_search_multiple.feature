Feature: Multiple Search
  what: search returns more than one page
  why: there are two pages with the title substring
  result: get a list of titles to select from

  Scenario: Find pages by title
    Given the following pages
      | title                                              | 
      | A Christmas Carol by Charles Dickens               |
      | The Call of the Wild by Jack London                |
      | The Mysterious Affair at Styles by Agatha Christie |
      And I am on the homepage
     When I fill in "page_title" with "by"
      And I press "Find"
     Then I should see "A Christmas Carol" in ".title"
       And I should see "The Call of the Wild" in ".title"
       And I should see "The Mysterious Affair" in ".title"
      And I am on the homepage
     When I fill in "page_title" with "Chris"
      And I press "Find"
     Then I should see "A Christmas Carol" in ".title"
       And I should not see "The Call of the Wild" in ".title"
       And I should see "The Mysterious Affair" in ".title"
     When I follow "Read"
     Then I should see "A Christmas Carol" in ".title"

  Scenario: Find pages by notes
    Given the following pages
      | title                           | notes                       | 
      | A Christmas Carol               | by Charles Dickens, classic | 
      | The Call of the Wild            | by Jack London, classic     | 
      | The Mysterious Affair at Styles | by Agatha Christie, mystery | 
      And I am on the homepage
     When I fill in "page_notes" with "by"
      And I press "Find"
     Then I should see "A Christmas Carol" in ".title"
       And I should see "The Call of the Wild" in ".title"
       And I should see "The Mysterious Affair" in ".title"
     When I am on the homepage
      And I fill in "page_notes" with "classic"
      And I press "Find"
     Then I should see "A Christmas Carol" in ".title"
       And I should see "The Call of the Wild" in ".title"
       And I should not see "The Mysterious Affair" in ".title"
     When I am on the homepage
      And I fill in "page_notes" with "mystery"
      And I press "Find"
     Then I should not see "A Christmas Carol" in ".title"
       And I should not see "The Call of the Wild" in ".title"
       And I should see "The Mysterious Affair" in ".title"

  Scenario: limit number of found pages
    Given 11 titled pages exist
     When I am on the homepage
     And I fill in "page_title" with "page "
       And I press "Find"
     Then I should see "page 1"
       And I should see "page 2"
       And I should see "page 9"
       And I should see "page 10"
     But I should not see "page 11"
     When I am on the homepage
     And I fill in "page_title" with "page 11"
       And I press "Find"
     Then I should see "page 11"
       And I should not see "page 2"
       And I should not see "page 9"
       And I should not see "page 10"
