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
       Then I should see "A Christmas Carol" within "#position_1"
     When I follow "Read" within "#position_1"
       And I press "Read Later"
       Then I should see "The Call of the Wild" within ".title"
     When I press "Read Later"
       Then I should see "The Mysterious Affair at Styles" within ".title"
     When I press "Read Later"
       Then I should see "A Christmas Carol" within ".title"
     When I am on the homepage
       Then I should see "The Call of the Wild" within "#position_2"
     When I follow "Text" within "#position_2"
     When I am on the homepage
     Then I should see "The Call of the Wild" within "#position_1"
       And I should see "The Mysterious Affair at Styles" within "#position_3"
       And I follow "Text" within "#position_3"
     When I am on the homepage
       Then I should see "The Mysterious Affair at Styles" within "#position_1"
