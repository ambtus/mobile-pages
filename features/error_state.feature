Feature: state errors

   Scenario: remove short state
    Given I have no pages
      And I am on the homepage
    When I fill in "page_url" with "http://www.rawbw.com/~alice/short.html"
      And I fill in "page_title" with "Short"
      And I press "Store"
   Then I should see "short" in ".states"
     And I should not see "long" in ".states"
   When I follow "Refetch"
     When I fill in "url" with "http://www.rawbw.com/~alice/medium.html"
     And I press "Refetch"
   Then I should not see "short" in ".states"
     And I should not see "long" in ".states"

   Scenario: remove long state
    Given I have no pages
      And I am on the homepage
    When I fill in "page_url" with "http://www.rawbw.com/~alice/long.html"
      And I fill in "page_title" with "Long"
      And I press "Store"
   Then I should see "long" in ".states"
   When I follow "Refetch"
     When I fill in "url" with "http://www.rawbw.com/~alice/medium.html"
     And I press "Refetch"
   Then I should not see "short" in ".states"
     And I should not see "long" in ".states"
