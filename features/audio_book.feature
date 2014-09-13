Feature: preparation for reading

  Scenario: audiobook link
    Given a page exists with title: "Alice"
    When I am on the page's page
      And I follow "Sectioned"
    Then the download directory should exist for page titled "Alice"
    Then the download html file should exist for page titled "Alice"
    Then the download epub file should not exist for page titled "Alice"

  Scenario: audiobook sections
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I follow "Sectioned"
      Then I should see "Lorem ipsum dolor"
      And I should see "READ SLOWLY"
      And I should see "Section 1"
      And I should see "Section 2"

  Scenario: part sections
    When I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/2.html
        """
     And I fill in "page_title" with "Multiple pages from urls"
     And I press "Store"
   When I go to the page with title "Multiple pages from urls"
   Then I should see "Sectioned" within "#position_1"
