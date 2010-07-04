Feature: basic title

  Scenario: change title
    Given a page exists with title: "Old Title", url: "http://test.sidrasue.com/test.html"
      And I am on the page's page
    When I follow "Manage Parts"
      And I fill in "title" with "New Title"
      And I press "Update"
    Then I should see "New Title" within ".title"
    When I follow "Read"
    Then I should see "Retrieved from the web" within ".content"

