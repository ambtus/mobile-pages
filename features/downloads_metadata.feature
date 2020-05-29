Feature: downloads metadata

  Scenario: epub page; author and tag strings are populated
    Given a page exists with tags: "my tag" AND add_author_string: "my author"
    Then the download epub command should include tags: "my tag"
    And the download epub command should include authors: "my author"
    And the download epub command should not include comments: "my author"
    But the download epub command should include comments: "my tag"

  Scenario: do not put aka in author tag for epub
    Given a page exists with add_author_string: "my author (AKA)"
    And the download epub command should include authors: "my author"
    But the download epub command should not include authors: "AKA"
    And the download epub command should not include comments: "my author (AKA)"

  Scenario: short and has a tag
    Given a page exists with tags: "tag1"
    And the download epub command should include tags: "tag1"
    And the download epub command should include tags: "short"
    And the download epub command should include tags: "unread"
    And the download epub command should include comments: "tag1, short"
    But the download epub command should not include comments: "unread"

  Scenario: long and has been read
    Given a page exists with last_read: "2014-01-01" AND url: "http://test.sidrasue.com/long.html"
    Then the download epub command should include tags: "medium"
    But the download epub command should not include tags: "unread"
    And the download epub command should not include tags: "2014"
    And the download epub command should include comments: "medium"
    But the download epub command should not include comments: "2014"
