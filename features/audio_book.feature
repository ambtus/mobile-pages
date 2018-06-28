Feature: audiobook

  Scenario: audiobook link
    Given a page exists with title: "Alice"
    When I am on the page's page
      And I follow "Text"
    Then the download directory should exist for page titled "Alice"
    Then the download html file should exist for page titled "Alice"
    Then the download epub file should not exist for page titled "Alice"

  Scenario: audiobook sections
    Given a titled page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I follow "Text"
      Then I should see "Lorem ipsum dolor"
      And I should see "SLOW DOWN"
      And I should see "1"
      And I should see "2"

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
   Then I should see "Text" within "#position_1"

  Scenario: audiobook created adds the hidden audio tag and makes it a favorite and updates last read
    Given the following pages
      | title  | last_read  | favorite |
      | first  | 2014-01-01 | 2 |
      | second | 2014-02-01 | 2 |
    When I am on the homepage
    Then I should see "first" within "#position_1"
    And I should not see "favorite"
    And I should not see "audio"
    When I follow "first" within "#position_1"
    And I follow "Text"
    And I press "Audiobook created"
    When I am on the page with title "first"
    Then I should see "audio" within ".hiddens"
    And I should see "favorite" within ".favorite"
    When I am on the homepage
    Then I should see "second" within "#position_1"
      And I should not see "first"
      And I should see "2014"
    When I select "audio" from "Hidden"
      And I press "Find"
    Then I should see "first" within "#position_1"
    And I should not see "second"
      And I should not see "2014"
