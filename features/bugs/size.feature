Feature: size bugs

   Scenario: remove short state
    Given the following page
      | title | url |
      | Short | http://test.sidrasue.com/short.html |
      And I am on the homepage
   Then I should see "short" in ".size"
     And I should not see "long" in ".size"
   When I follow "Read"
     And I follow "Refetch"
     When I fill in "url" with "http://test.sidrasue.com/medium.html"
     And I press "Refetch"
   Then I should not see "short" in ".size"
     And I should not see "long" in ".size"

   Scenario: remove long state
    Given the following page
      | title | url |
      | Short | http://test.sidrasue.com/long.html |
      And I am on the homepage
   Then I should see "long" in ".size"
   When I follow "Read"
     And I follow "Refetch"
     When I fill in "url" with "http://test.sidrasue.com/medium.html"
     And I press "Refetch"
   Then I should not see "short" in ".size"
     And I should not see "long" in ".size"
