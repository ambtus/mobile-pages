Feature: size bugs

   Scenario: remove extra size states
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
      And I am on the page's page
   Then I should see "long" in ".size"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/medium.html"
     And I press "Refetch"
   Then I should not see "short" in ".size"
     And I should not see "long" in ".size"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/short.html"
     And I press "Refetch"
   Then I should see "short" in ".size"
     And I should not see "long" in ".size"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/medium.html"
     And I press "Refetch"
   Then I should not see "short" in ".size"
     And I should not see "long" in ".size"
