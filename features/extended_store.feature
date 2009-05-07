Feature: extended store

  Scenario: refetch original html
    Given I am on the homepage
    When I fill in "page_title" with "test refetch"
      And I fill in "page_url" with "http://www.rawbw.com/~alice/test.html"
      And I fill in "page_pasted" with "system down"
      And I press "Store"
    When I follow "Refetch"
    Then the field with id "url" should contain "http://www.rawbw.com/~alice/test.html"
    When I press "Refetch"
    Then I should see "Retrieved from the web"
