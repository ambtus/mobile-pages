Feature: find last created

  Scenario: find last created page if no pages
    When I am on the homepage
    When I follow "Last"
    Then I should see "No pages"

  Scenario: find last created page
    Given 2 titled pages exist
    When I am on the homepage
      And I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    When I am on the homepage
    When I follow "Last"
    Then I should see "" in ".parts"
      And I should see "New Title" in ".title"
