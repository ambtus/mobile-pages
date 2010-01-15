Feature: basic title

  Scenario: change title
    Given the following page
      | title                  | url |
      | Old Title              | http://test.sidrasue.com/test.html |
      And I am on the homepage
    When I follow "Read"
      And I follow "Manage Parts"
      And I fill in "title" with "New Title"
      And I press "Update"
    Then I should see "New Title" in ".title"
    When I follow "Read"
    Then I should see "Retrieved from the web" in ".content"

