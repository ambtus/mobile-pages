Feature: next bugs

  Scenario: after adding parent next should not show part
    Given 2 titled pages exist
    When I go to the homepage
    Then I should see "page 1 title" within "#position_1"
      And I should see "page 2 title" within "#position_2"
    When I follow "Read" within "#position_1"
      And I press "Read Later"
    Then I should see "page 2 title" within ".title"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent for page 2"
      And I press "Update"
    Then I should see "Parent for page 2" within ".title"
      When I press "Read Later"
    Then I should see "page 1 title" within ".title"
      When I press "Read Later"
    Then I should see "Parent for page 2" within ".title"
      When I press "Read Later"
    Then I should see "page 1 title" within ".title"
