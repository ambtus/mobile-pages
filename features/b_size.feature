Feature: page size

   Scenario: changing sizes
    Given I have no pages
    And a page exists with url: "http://test.sidrasue.com/40000.html"
      And I am on the page's page
   Then I should see "40,020 words" within ".size"
   When I am on the homepage
    When I choose "size_long"
      And I press "Find"
    And I follow "Page 1"
   And I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/8000.html"
     And I press "Refetch"
   Then I should see "8,318 words" within ".size"
   When I am on the homepage
    When I choose "size_medium"
      And I press "Find"
    And I follow "Page 1"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/short.html"
     And I press "Refetch"
   Then I should see "948 words" within ".size"
   When I am on the homepage
    When I choose "size_short"
      And I press "Find"
    And I follow "Page 1"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/40000.html"
     And I press "Refetch"
   Then I should see "40,020 words" within ".size"
   When I am on the homepage
    When I choose "size_long"
      And I press "Find"
    Then I should see "Page 1"

  Scenario: changing sizes with parts
    Given I have no pages
    And a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1 2 3 4 5 6 7 8"
   When I am on the page's page
   Then I should see "80,008 words" within ".size"
   When I am on the homepage
    When I choose "size_long"
      And I press "Find"
    And I follow "Page 1"
   When I follow "Manage Parts"
     When I fill in "url_list" with "http://test.sidrasue.com/long.html"
     And I press "Update"
   Then I should see "10,005 words" within ".size"
   When I am on the homepage
    When I choose "size_medium"
      And I press "Find"
    Then I should see "Page 1"
