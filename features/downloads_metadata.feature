Feature: downloads metadata

  Scenario: drabble and has an info tag (not displayed)
    Given a page exists with infos: "tag1"
    And the download epub command should NOT include tags: "tag1"
    And the download epub command should include tags: "drabble"
    And the download epub command should include tags: "unread"
    And the download epub command should include comments: "0 words"
    But the download epub command should NOT include comments: "tag1"
    And the download epub command should NOT include comments: "drabble"

  Scenario: epub page; author and tag strings are populated
    Given I have no pages
    And a page exists with tropes: "my tag" AND add_author_string: "my author"
    Then the download epub command should include tags: "my tag"
    And the download epub command should include authors: "my author"
    And the download epub command should NOT include comments: "my author"
    But the download epub command should include comments: "my tag"

  Scenario: do not put aka in author tag for epub
    Given I have no pages
    And a page exists with add_author_string: "my author (AKA)"
    And the download epub command should include authors: "my author"
    But the download epub command should NOT include authors: "AKA"
    And the download epub command should NOT include comments: "my author (AKA)"

  Scenario: drabble and has a tag
    Given I have no pages
    And a page exists with tropes: "tag1"
    And the download epub command should include tags: "tag1"
    And the download epub command should include tags: "drabble"
    And the download epub command should include tags: "unread"
    And the download epub command should include comments: "tag1, 0 words"
    But the download epub command should NOT include comments: "unread"

  Scenario: long and has been read
    Given I have no pages
    And a page exists with last_read: "2014-01-01" AND url: "http://test.sidrasue.com/long.html" AND stars: "5"
    Then the download epub command should include tags: "medium"
    But the download epub command should NOT include tags: "unread"
    And the download epub command should NOT include tags: "2014"
    And the download epub command should include comments: "10,005 words"
    But the download epub command should NOT include comments: "2014"
    And the download epub command should include rating: "10"

  Scenario: tag changes => download tags change
    Given I have no pages
    And a page exists with tropes: "tag1"
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
      And the download epub command should include authors: "fandom1"

  Scenario: many fandoms, many characters => characters in tags, fandom in authors
    Given I have no pages
    And a page exists with fandoms: "harry potter, sga" AND characters: "harry/snape, john/rodney"
    And the download epub command should include authors: "harry potter"
    And the download epub command should include authors: "sga"
    And the download epub command should include tags: "harry/snape"
    And the download epub command should include tags: "john/rodney"
    And the download epub command should include comments: "harry/snape, john/rodney"
    But the download epub command should NOT include comments: "harry potter"
