Feature: last created

  Scenario: find last created page if no pages
    Given I have no pages
    When I am on the homepage
    When I choose "sort_by_last_created"
      And I press "Find"
    Then I should see "No pages"

  Scenario: find last created page
    Given 2 pages exist
    When I am on the homepage
      And I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    When I am on the homepage
      And I choose "sort_by_last_created"
      And I press "Find"
    Then I should see "New Title" within "#position_1"
    When I wait 1 second
      And I follow "Page 1"
      And I follow "Manage Parts"
      And I fill in "url_list" with "http://test.sidrasue.com/short.html"
      And I press "Update"
    When I am on the homepage
      And I choose "sort_by_last_created"
      And I press "Find"
    Then I should see "Part 1" within "#position_1"
