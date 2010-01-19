Feature: basic sizes
  What: automatically add sizes to page
  Why: so I will be able to filter on it later
  Result: see what filter has been applied to a page

   Scenario: short state and long
    Given a titled page exists with url: "http://test.sidrasue.com/short.html"
    When I am on the page's page
   Then I should see "short" in ".size"
     And I should not see "long" in ".size"
   When I follow "Refetch"
     When I fill in "url" with "http://test.sidrasue.com/long.html"
     And I press "Refetch"
   Then I should not see "short" in ".size"
     And I should see "long" in ".size"
   When I follow "Refetch"
     When I fill in "url" with "http://test.sidrasue.com/short.html"
     And I press "Refetch"
   Then I should see "short" in ".size"
     And I should not see "long" in ".size"

  Scenario: add epic state
    Given a titled page exists with base_url: "http://test.sidrasue.com/long*.html", url_substitutions: "1 2 3 4 5 6 7 8"
   When I am on the page's page
   Then I should see "epic" in ".size"
     And I should not see "long" in ".size"
     And I should not see "short" in ".size"
   When I follow "Manage Parts"
     When I fill in "url_list" with "http://test.sidrasue.com/long.html"
     And I press "Update"
   Then I should not see "short" in ".size"
     And I should see "long" in ".size"
     And I should not see "epic" in ".size"
