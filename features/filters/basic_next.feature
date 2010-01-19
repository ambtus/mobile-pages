Feature: basic next
  what: be presented with the next page for suggested reading
  why: If I just want to read something
  result: read them in order of creation, but after downloaded should be first

  Scenario: Read pages in order
    Given the following pages
      | title                           | 
      | A Christmas Carol               | 
      | The Call of the Wild            | 
      | The Mysterious Affair at Styles | 
     When I am on the homepage
       Then I should see "A Christmas Carol" in ".title"
     When I press "Read Later"
       Then I should see "The Call of the Wild" in ".title"
     When I press "Read Later"
       Then I should see "The Mysterious Affair at Styles" in ".title"
     When I press "Read Later"
       Then I should see "A Christmas Carol" in ".title"
     When I fill in "search" with "Call of"
       And I press "Search"
       And I should see "The Call of the Wild" in ".title"
       And I follow "Download" in ".title"
     When I am on the homepage
       Then I should see "The Call of the Wild" in ".title"
     When I fill in "search" with "Christmas"
       And I press "Search"
       And I should see "Christmas Carol" in ".title"
       And I follow "Download" in ".title"
       And I am on the homepage
     Then I should see "A Christmas Carol" in ".title"
