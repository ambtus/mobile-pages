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
     Then I should see "A Christmas Carol" in ".title"

  Scenario: Find pages by notes
    Given the following pages
      | title                           | notes                       | 
      | A Christmas Carol               | by Charles Dickens, classic | 
      | The Call of the Wild            | by Jack London, classic     | 
      | The Mysterious Affair at Styles | by Agatha Christie, mystery | 
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

  Scenario: limit number of found pages
    Given 21 titled pages exist
     When I am on the homepage
     And I fill in "search" with "page "
       And I press "Search"
     Then I should see "page 1"
       And I should see "page 20"
     But I should not see "page 21"
     When I am on the homepage
     And I fill in "search" with "page 21"
       And I press "Search"
     Then I should see "page 21"
