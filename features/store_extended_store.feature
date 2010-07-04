Feature: extended store

  Scenario: refetch original html
    Given a titled page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "Edit Raw HTML"
      And I fill in "pasted" with "system down"
      And I press "Update Raw HTML"
    Then I should see "system down" within ".content"
    When I follow "Refetch"
    Then the "url" field should contain "http://test.sidrasue.com/test.html"
    When I press "Refetch"
    Then I should see "Retrieved from the web" within ".content"

  Scenario: refetch original html for parts
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html"
    When I am on the page's page
    When I follow "Refetch" within ".title"
    Then the "url_list" field should contain "http://test.sidrasue.com/parts/1.html"
    When I fill in "url_list" with 
      """
      http://test.sidrasue.com/parts/2.html
      http://test.sidrasue.com/parts/1.html
      """
      And I press "Refetch"
    Then I should see "stuff for part 2"
    And I should see "stuff for part 1"

  Scenario: utf8
    Given a titled page exists with url: "http://test.sidrasue.com/sbutf8.html"
    When I am on the page's page
      And I follow "Read"
    Then I should see "“H"

  Scenario: utf8 in parts
    Given a titled page exists with urls: "http://test.sidrasue.com/sbutf8.html"
    When I am on the page's page
      And I follow "Read"
    Then I should see "“H"

  Scenario: latin1
    Given a titled page exists with url: "http://test.sidrasue.com/1252.html"
    When I am on the page's page
      And I follow "Read"
    Then I should see "“H"
