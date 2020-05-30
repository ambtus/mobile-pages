Feature: audiobook

  Scenario: audiobook sections
    Given a page exists with url: "http://test.sidrasue.com/long.html"
    When I am on the page's page
      And I want to edit the text
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
   When I am on the page with title "Multiple pages from urls"
   Then I should see "Text" within "#position_1"

  Scenario: audiobook created adds the audio tag and updates last read
    Given a page exists with last_read: "2014-01-01"
    When I am on the page's page
    Then I should see "2014" within ".last_read"
    Then I should NOT see "audio"
    When I want to edit the text
    And I press "Audiobook created"
    When I am on the page's page
    Then I should see "audio" within ".tags"
    And last read should be today
    And I should NOT see "2014" within ".last_read"
