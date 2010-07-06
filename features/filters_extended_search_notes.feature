Feature: extended search on notes

  Scenario: Find page by notes 
    Given the following pages
      | title                           | notes             |
      | A Christmas Carol               | mystery ghosts    |
      | Murder on the Orient Express    | poirot mystery    |
      | The Mysterious Affair at Styles | poirot            |
    When I am on the homepage
      And I fill in "page_notes" with "mystery"
      And I press "Find"
    Then I should see "A Christmas Carol" within "#position_1"
      And I should see "Murder on the Orient Express"
      And I should not see "The Mysterious Affair at Styles"
    When I am on the homepage
      And I fill in "page_notes" with "ghosts"
      And I press "Find"
    Then I should see "A Christmas Carol" within ".title"
      And I should not see "Murder on the Orient Express"
      And I should not see "The Mysterious Affair at Styles"
    When I am on the homepage
      And I fill in "page_notes" with "poirot"
      And I press "Find"
    Then I should not see "A Christmas Carol" within ".title"
      And I should see "Murder on the Orient Express"
      And I should see "The Mysterious Affair at Styles"
    When I am on the homepage
      And I follow "A Christmas Carol"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Christmas stuff"
      And I press "Update"
    When I am on the homepage
      And I fill in "page_notes" with "ghosts"
      And I press "Find"
    Then I should see "A Christmas Carol" within ".title"
