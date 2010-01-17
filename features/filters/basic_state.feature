Feature: basic states
  What: automatically add states to page
  Why: so I will be able to filter on it later
  Result: see what filter has been applied to a page

  Scenario: unread and favorite states
    Given the following page
      |title | url |
      | Test | http://test.sidrasue.com/test.html |
    When I am on the homepage
    Then I should see "unread" in ".last_read"
    When I follow "Rate"
      And I press "1"
   Then I should see "favorite" in ".favorite"
     And I should not see "unread" in ".last_read"
    When I follow "Rate"
      And I press "2"
   Then I should not see "favorite" in ".favorit"
     And I should not see "unread" in ".last_read"
