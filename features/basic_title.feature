Feature: basic title

  Scenario: change title
    Given the following page
      | title                  | url |
      | Old Title              | http://sidrasue.com/tests/test.html |
      And I am on the homepage
    When I follow "Manage Parts"
      And I fill in "url_list" with "#New Title"
      And I press "Update"
    Then I should see "New Title" in ".title"
    When I follow "Read"
#    Then I should see "retrieved from the web" in ".content"

