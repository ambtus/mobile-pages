Feature: next bugs

  Scenario: after adding parent next should not show part
    Given 2 titled pages exist
    When I go to the homepage
    Then I should see "page 1" in "#position_1"
      And I should see "page 2" in "#position_2"
    When I follow "Read" in "#position_1"
      And I press "Read Later"
    Then I should see "page 2" in ".title"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" in ".title"
      When I press "Read Later"
    Then I should see "page 1" in ".title"
      When I press "Read Later"
    Then I should see "Parent" in ".title"
      When I press "Read Later"
    Then I should see "page 1" in ".title"
