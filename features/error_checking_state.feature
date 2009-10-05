Feature: state errors

   Scenario: remove short state
    Given the following page
      | title | url |
      | Short | http://sidrasue.com/tests/short.html |
      And I am on the homepage
   Then I should see "short" in ".states"
     And I should not see "long" in ".states"
   When I follow "Read"
     And I follow "Refetch"
     When I fill in "url" with "http://sidrasue.com/tests/medium.html"
     And I press "Refetch"
   Then I should not see "short" in ".states"
     And I should not see "long" in ".states"

   Scenario: remove long state
    Given the following page
      | title | url |
      | Short | http://sidrasue.com/tests/long.html |
      And I am on the homepage
   Then I should see "long" in ".states"
   When I follow "Read"
     And I follow "Refetch"
     When I fill in "url" with "http://sidrasue.com/tests/medium.html"
     And I press "Refetch"
   Then I should not see "short" in ".states"
     And I should not see "long" in ".states"
