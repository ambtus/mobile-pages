Feature: next bugs

  Scenario: after adding parent next should not show part
    Given 2 titled pages exist
    When I go to the homepage
    Then I should see "1" in ".title"
      When I press "Read Later"
    Then I should see "2" in ".title"
    When I follow "Read"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" in ".title"
      When I press "Read Later"
    Then I should see "1" in ".title"
      When I press "Read Later"
    Then I should see "Parent" in ".title"
      When I press "Read Later"
    Then I should see "1" in ".title"
