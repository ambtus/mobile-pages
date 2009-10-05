Feature: next bugs

  Scenario: read later after adding parent
    Given the following pages
      | title       | url                                    |
      | Single Text | http://sidrasue.com/tests/test.html    |
      | First Part  |  http://sidrasue.com/tests/parts/1.html|
      And I am on the homepage
    Then I should see "Single Text" in ".title"
     When I press "Read Later"
    Then I should see "First Part" in ".title"
    When I follow "Manage Parts"
     And I fill in "add_parent" with "New Parent"
     And I press "Update"
    Then I should see "New Parent" in ".title"
     When I press "Read Later"
    Then I should see "Single Text" in ".title"
     When I press "Read Later"
    Then I should see "New Parent" in ".title"
