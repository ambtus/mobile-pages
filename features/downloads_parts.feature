Feature: downloads metadata

  Scenario: download part titles shouldn't have size or info or stars or last read
    Given I have no pages
    And a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1 2 3"
    Then the download epub command should include tags: "long"
      And the download epub command should include comments: "30,003 words"
    When I am on the page's page
      And I follow "Part 1"
      And I follow "Rate"
      And I choose "5"
    And I press "Rate"
    When I follow "Edit Tags"
      And I fill in "tags" with "scrub"
      And I press "Add Info Tags"
    When I am on the page's page
    And I view the content
     Then I should see "Part 1" within "h2"
     And I should NOT see "medium" within "h2"
     And I should NOT see "long"
     And I should NOT see "scrub" within "h2"
     And I should NOT see "5 stars" within "h2"
     And I should NOT see today within "h2"

  Scenario: part epubs should have all metadata from parent except size and info
    Given I have no pages
    And a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1 2 3" AND fandoms: "harry potter" AND infos: "informational" AND tropes: "AU" AND add_author_string: "my author" AND stars: "4"
    Then the download epub command for "Part 2" should include authors: "my author&harry potter"
    But the download epub command for "Part 2" should NOT include tags: "harry potter"
    And the download epub command for "Part 2" should include tags: "AU"
    But the download epub command for "Part 2" should NOT include series: "AU"
    And the download epub command for "Part 2" should include comments: "AU"
    And the download epub command for "Part 2" should include authors: "my author&harry potter"
    But the download epub command for "Part 2" should NOT include comments: "my author"
    And the download epub command for "Part 2" should NOT include comments: "harry potter"
    And the download epub command for "Part 2" should include tags: "medium"
    But the download epub command for "Part 2" should NOT include tags: "long"
    And the download epub command for "Part 2" should include comments: "10,001 words"
    And the download epub command should include rating: "8"
    But the download epub command for "Part 2" should NOT include tags: "informational"
    But the download epub command for "Part 2" should NOT include comments: "informational"

  Scenario: download part titles should have unread
    Given I have no pages
    And a page exists with base_url: "http://test.sidrasue.com/test*.html" AND url_substitutions: "1 2 3"
    When I am on the page's page
      And I view the content
    Then I should NOT see "unread"
    When I am on the page's page
      And I follow "Part 3"
      And I follow "Rate"
      And I choose "5"
    And I press "Rate"
      And I follow "Edit Tags"
      And I fill in "tags" with "cute"
      And I press "Add Rating Tags"
    When I am on the page's page
    And I view the content
     Then I should see "Part 1 (unread)"
     And I should see "Part 2 (unread)"
     And I should see "Part 3 (cute)"
    When I am on the page's page
      And I follow "Part 1"
      And I follow "Rate"
      And I choose "5"
    And I press "Rate"
      And I follow "Edit Tags"
      And I fill in "tags" with "sweet"
      And I press "Add Rating Tags"
    When I am on the page's page
    And I view the content
     Then I should see "Part 1 (sweet)"
     And I should see "Part 2 (unread)"
     And I should see "Part 3 (cute)"
    When I am on the page's page
      And I follow "Rate"
      And I press "Rate unfinished"
    When I am on the page's page
    And I view the content
     Then I should see "Part 1 (sweet)"
     And I should see "Part 2 (unfinished)"
     And I should see "Part 3 (cute)"

