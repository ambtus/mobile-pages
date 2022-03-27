Feature: stuff to do with titles

  Scenario: fill title in url box by mistake
    Given I am on the homepage
    And I have no pages
    When I fill in "page_url" with "Title"
      And I press "Store"
    Then I should see "Url is invalid"
      And I should have 0 pages

  Scenario: fill in title with Title
    Given I am on the homepage
    And I have no pages
    When I fill in "page_title" with "Title"
      And I press "Store"
    Then I should NOT see "Title can't be blank or 'Title'"
      And I should have 1 page

  Scenario: change title
    Given a page exists with url: "http://test.sidrasue.com/test.html"
      And I am on the page's page
    When I follow "Manage Parts"
      And I fill in "title" with "New Title"
      And I press "Update"
    Then I should see "New Title" within ".title"
