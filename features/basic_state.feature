Feature: basic states
  What: automatically add states to page
  Why: so I will be able to filter on it later
  Result: see what filter has been applied to a page

  Scenario: unread and favorite states
    Given the following page
      |title | url |
      | Test | http://test.sidrasue.com/test.html |
    When I am on the homepage
    Then I should see "unread" in ".states"
    When I follow "Rate"
      And I press "1"
   Then I should see "favorite" in ".states"
     And I should not see "unread" in ".states"
    When I follow "Rate"
      And I press "2"
   Then I should not see "favorite" in ".states"
     And I should not see "unread" in ".states"

   Scenario: short state and long
    Given the following page
      |title | url |
      | Test | http://test.sidrasue.com/short.html |
    When I am on the homepage
   Then I should see "short" in ".states"
     And I should not see "long" in ".states"
   When I follow "Read"
     And I follow "Refetch"
     When I fill in "url" with "http://test.sidrasue.com/long.html"
     And I press "Refetch"
   Then I should not see "short" in ".states"
     And I should see "long" in ".states"
   When I follow "Refetch"
     When I fill in "url" with "http://test.sidrasue.com/short.html"
     And I press "Refetch"
   Then I should see "short" in ".states"
     And I should not see "long" in ".states"

  Scenario: add epic state
    Given the following page
      | title | base_url | url_substitutions |
      | Multi | http://test.sidrasue.com/long*.html| 1 2 3 4 5 6 7 8 |
   When I am on the homepage
   Then I should see "epic" in ".states"
     And I should not see "long" in ".states"
     And I should not see "short" in ".states"
   When I follow "Read"
     And I follow "Manage Parts"
     When I fill in "url_list" with "http://test.sidrasue.com/long.html"
     And I press "Update"
   Then I should not see "short" in ".states"
     And I should see "long" in ".states"
     And I should not see "epic" in ".states"
