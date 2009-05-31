Feature: basic genres
  What: automatically add genres to page
  Why: so I will be able to filter on it later
  Result: see what filter has been applied to a page

  Scenario: add unread genre
    Given I have no pages
      And I am on the homepage
    When I fill in "page_url" with "http://www.rawbw.com/~alice/test.html"
      And I fill in "page_title" with "Test"
      And I press "Store"
   Then I should see "unread" in ".genres"

  Scenario: add favorite genre
    Given I have no pages
      And I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/test.html"
      And I fill in "page_title" with "Test"
      And I press "Store"
    When I follow "Rate"
      And I press "1"
   Then I should see "favorite" in ".genres"
     And I should not see "unread" in ".genres"

   Scenario: add short genre
    Given I have no pages
      And I am on the homepage
    When I fill in "page_url" with "http://www.rawbw.com/~alice/short.html"
      And I fill in "page_title" with "Short"
      And I press "Store"
   Then I should see "short" in ".genres"
     And I should not see "long" in ".genres"
   When I follow "Refetch"
     When I fill in "url" with "http://www.rawbw.com/~alice/long.html"
     And I press "Refetch"
   Then I should not see "short" in ".genres"
     And I should see "long" in ".genres"

   Scenario: add long genre
    Given I have no pages
      And I am on the homepage
    When I fill in "page_url" with "http://www.rawbw.com/~alice/long.html"
      And I fill in "page_title" with "Long"
      And I press "Store"
   Then I should not see "short" in ".genres"
     And I should see "long" in ".genres"

   Scenario: add epic genre
    Given I have no pages
      And I am on the homepage
    When I fill in "page_url" with "http://www.rawbw.com/~alice/long.html"
      And I fill in "page_title" with "Long"
      And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Epic"
      And I press "Update"
      And I should see "long" in ".genres"
      And I follow "Manage Parts"
    When I fill in "url_list" with "http://www.rawbw.com/~alice/long.html\nhttp://www.rawbw.com/~alice/long2.html\nhttp://www.rawbw.com/~alice/long3.html\nhttp://www.rawbw.com/~alice/long4.html\nhttp://www.rawbw.com/~alice/long5.html\nhttp://www.rawbw.com/~alice/long6.html\nhttp://www.rawbw.com/~alice/long7.html\nhttp://www.rawbw.com/~alice/long8.html"
    And I press "Update"
    Then I should see "epic" in ".genres"
      And I should not see "long" in ".genres"
