Feature: downloads metadata

  Scenario: epub page; author and tag strings are populated
    Given a page exists with tags: "my tag" AND add_author_string: "my author"
    Then the download epub command should include tags: "my tag"
    And the download epub command should include authors: "my author"
    And the download epub command should NOT include comments: "my author"
    But the download epub command should include comments: "my tag"

  Scenario: do not put aka in author tag for epub
    Given a page exists with add_author_string: "my author (AKA)"
    And the download epub command should include authors: "my author"
    But the download epub command should NOT include authors: "AKA"
    And the download epub command should NOT include comments: "my author (AKA)"

  Scenario: short and has a tag
    Given a page exists with tags: "tag1"
    And the download epub command should include tags: "tag1"
    And the download epub command should include tags: "short"
    And the download epub command should include tags: "unread"
    And the download epub command should include comments: "tag1, short"
    But the download epub command should NOT include comments: "unread"

  Scenario: long and has been read
    Given a page exists with last_read: "2014-01-01" AND url: "http://test.sidrasue.com/long.html" AND stars: "5"
    Then the download epub command should include tags: "medium"
    But the download epub command should NOT include tags: "unread"
    And the download epub command should NOT include tags: "2014"
    And the download epub command should include comments: "medium"
    But the download epub command should NOT include comments: "2014"
    And the download epub command should include rating: "10"

  Scenario: part titles shouldn't have size
    Given a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1 2 3"
    Then the download epub command should include tags: "long"
      And the download epub command should include comments: "long"
    When I am on the page's page
    And I view the content
     Then I should see "Part 1" within "h2"
     But I should NOT see "Part 1 (medium)" within "h2"

  Scenario: part epubs should have all metadata from parent except size
    Given a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1 2 3" AND fandoms: "harry potter" AND tags: "AU" AND add_author_string: "my author" AND stars: "4"
    Then the download epub command for "Part 2" should include series: "harry potter"
    But the download epub command for "Part 2" should NOT include tags: "harry potter"
    And the download epub command for "Part 2" should include tags: "AU"
    But the download epub command for "Part 2" should NOT include series: "AU"
    And the download epub command for "Part 2" should include comments: "harry potter, AU"
    And the download epub command for "Part 2" should include authors: "my author"
    But the download epub command for "Part 2" should NOT include comments: "my author"
    And the download epub command for "Part 2" should include tags: "medium"
    But the download epub command for "Part 2" should NOT include tags: "long"
    And the download epub command for "Part 2" should include comments: "medium"
    And the download epub command should include rating: "8"

  Scenario: tag changes => download tags change
    Given a page exists with tags: "tag1"
    When I am on the page's page
      And I download the epub
    Then the download epub file should exist
      And the download epub command should include tags: "tag1"

    When I am on the edit tag page for "tag1"
    And I fill in "tag_name" with "fandom1"
    And I press "Update"
    Then the download epub file should NOT exist
    When I am on the page's page
      And I download the epub
    Then the download epub file should exist
      And the download epub command should include tags: "fandom1"

    When I am on the edit tag page for "fandom1"
      And I select "Fandom" from "change"
      And I press "Change"
    Then the download epub file should NOT exist
    When I am on the page's page
      And I download the epub
    Then the download epub file should exist
      And the download epub command should include series: "fandom1"
