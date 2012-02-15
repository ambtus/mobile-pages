Feature: page size

  Scenario: filter on a size
    Given the following pages
      | title  | url                                   |
      | Short  | http://test.sidrasue.com/short.html   |
      | Medium | http://test.sidrasue.com/medium.html  |
      | Long   | http://test.sidrasue.com/long.html    |
    And a page exists with title: "Long2", base_url: "http://test.sidrasue.com/medium*.html", url_substitutions: "1 2 3"
    And a page exists with title: "Novel", base_url: "http://test.sidrasue.com/long*.html", url_substitutions: "1 2 3"
    And a page exists with title: "Epic", base_url: "http://test.sidrasue.com/long*.html", url_substitutions: "4 5 6 7 8 9"
    When I am on the homepage
      And I choose "size_any"
      And I press "Find"
    Then I should see "Short" within "#position_1"
      And I should see "Medium" within "#position_2"
      And I should see "Long" within "#position_3"
      And I should see "Long2" within "#position_4"
      And I should see "Novel" within "#position_5"
      And I should see "Epic" within "#position_6"
    When I choose "size_short"
      And I press "Find"
    Then I should see "Short" within "#position_1"
      And I should see "Medium" within "#position_2"
      And I should not see "Long"
      And I should not see "Novel"
      And I should not see "Epic"
      And I should not see "Part 1"
    When I choose "size_medium"
      And I press "Find"
    Then I should see "Long" within "#position_1"
      And I should see "Long2" within "#position_2"
      And I should not see "Short"
      And I should not see "Medium"
      And I should not see "Epic"
      And I should not see "Part 1"
    When I choose "size_long"
      And I press "Find"
    Then I should see "Novel" within "#position_1"
      And I should see "Epic" within "#position_2"
      And I should not see "Short"
      And I should not see "Medium"
      And I should not see "Long"
      And I should not see "Part 1"

   Scenario: changing sizes
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
      And I am on the page's page
   Then I should see "medium" within ".size"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/medium.html"
     And I press "Refetch"
   Then I should see "short" within ".size"
     And I should not see "medium" within ".size"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/short.html"
     And I press "Refetch"
   Then I should see "short" within ".size"
     And I should not see "long" within ".size"
     And I should not see "medium" within ".size"
   When I follow "Refetch"
     And I fill in "url" with "http://test.sidrasue.com/long.html"
     And I press "Refetch"
   Then I should not see "short" within ".size"
     And I should see "medium" within ".size"
     And I should not see "long" within ".size"

  Scenario: changing sizes with parts
    Given a titled page exists with base_url: "http://test.sidrasue.com/long*.html", url_substitutions: "1 2 3 4 5 6 7 8"
   When I am on the page's page
   Then I should see "long" within ".size"
     And I should not see "medium" within ".size"
     And I should not see "short" within ".size"
   When I follow "Manage Parts"
     When I fill in "url_list" with "http://test.sidrasue.com/long.html"
     And I press "Update"
   Then I should not see "short" within ".size"
     And I should see "medium" within ".size"
     And I should not see "novel" within ".size"
