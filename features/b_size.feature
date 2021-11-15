Feature: page size

   Scenario: changing sizes
    Given I have no pages
    And a page exists with url: "http://test.sidrasue.com/40000.html"
      And I am on the page's page
   Then I should see "long" within ".size"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/8000.html"
     And I press "Refetch"
   Then I should see "medium" within ".size"
     And I should NOT see "long" within ".size"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/short.html"
     And I press "Refetch"
   Then I should see "short" within ".size"
     And I should NOT see "long" within ".size"
     And I should NOT see "medium" within ".size"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/40000.html"
     And I press "Refetch"
   Then I should NOT see "short" within ".size"
     And I should NOT see "medium" within ".size"
     And I should see "long" within ".size"

  Scenario: changing sizes with parts
    Given I have no pages
    And a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1 2 3 4 5 6 7 8"
   When I am on the page's page
   Then I should see "long" within ".size"
     And I should NOT see "medium" within ".size"
     And I should NOT see "short" within ".size"
   When I follow "Manage Parts"
     When I fill in "url_list" with "http://test.sidrasue.com/long.html"
     And I press "Update"
   Then I should NOT see "short" within ".size"
     And I should see "medium" within ".size"
     And I should NOT see "long" within ".size"
