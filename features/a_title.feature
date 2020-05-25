Feature: stuff to do with titles

  Scenario: change title
    Given a page exists with url: "http://test.sidrasue.com/test.html"
      And I am on the page's page
    When I follow "Manage Parts"
      And I fill in "title" with "New Title"
      And I press "Update"
    Then I should see "New Title" within ".title"
    When I view the content
    Then I should see "New Title" within "h1"

