Feature: downloads metadata

Scenario: basic
  Given a page exists with tropes: "tag1"
  When I am on the page's page
    And I download the epub
  Then the download epub file should exist
    And the download epub command should include tags: "tag1"

Scenario: drabble and has an info tag (not displayed)
  Given a page exists with infos: "tag1"
  Then the download epub command should NOT include tags: "tag1"
    And the download epub command should include tags: "drabble"
    And the download epub command should include tags: "unread"
    And the download epub command should include comments: "0 words"
    But the download epub command should NOT include comments: "tag1"
    And the download epub command should NOT include comments: "drabble"

Scenario: epub page; author and tag strings are populated
  Given a page exists with tropes: "my tag" AND add_author_string: "my author"
  Then the download epub command should include tags: "my tag"
    And the download epub command should include authors: "my author"
    And the download epub command should NOT include comments: "my author"
    But the download epub command should include comments: "my tag"

Scenario: do not put aka in author tag for epub
  Given a page exists with add_author_string: "my author (AKA)"
  Then the download epub command should include authors: "my author"
    But the download epub command should NOT include authors: "AKA"
    And the download epub command should NOT include comments: "my author (AKA)"

Scenario: drabble and has a tag
  Given a page exists with tropes: "tag1"
    And the download epub command should include tags: "tag1"
    And the download epub command should include tags: "drabble"
    And the download epub command should include tags: "unread"
    And the download epub command should include comments: "tag1, 0 words"
    But the download epub command should NOT include comments: "unread"

Scenario: medium and has been read
  Given a page exists with last_read: "2014-01-01" AND url: "http://test.sidrasue.com/long.html" AND stars: "5"
  Then the download epub command should include tags: "medium"
    But the download epub command should NOT include tags: "unread"
    And the download epub command should NOT include tags: "2014"
    And the download epub command should include comments: "10,005 words"
    But the download epub command should NOT include comments: "2014"
    And the download epub command should include rating: "10"

Scenario: long
  Given a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1 2 3"
  Then the download epub command should include tags: "long"
    And the download epub command should include comments: "30,003 words"

Scenario: tag name changes => remove outdated downloads
  Given a page exists with tropes: "tag1"
  When I am on the page's page
    And I download the epub
    And I am on the edit tag page for "tag1"
    And I fill in "tag_name" with "fandom1"
    And I press "Update"
  Then the download epub file should NOT exist

Scenario: tag name changes => new epub has new name
  Given a page exists with tropes: "tag1"
  When I am on the page's page
    And I download the epub
    And I am on the edit tag page for "tag1"
    And I fill in "tag_name" with "fandom1"
    And I press "Update"
    And I am on the page's page
    And I download the epub
  Then the download epub file should exist
    And the download epub command should include tags: "fandom1"
    And the download epub command should NOT include tags: "tag1"
    And the download epub command should NOT include authors: "fandom1"

Scenario: tag type changes => remove outdated downloads
  Given a page exists with tropes: "fandom1"
  When I am on the page's page
    And I download the epub
    And I am on the edit tag page for "fandom1"
    And I select "Fandom" from "change"
    And I press "Change"
  Then the download epub file should NOT exist

Scenario: tag type changes => new epub reflects change
  Given a page exists with tropes: "fandom1"
  When I am on the page's page
    And I download the epub
    And I am on the edit tag page for "fandom1"
    And I select "Fandom" from "change"
    And I press "Change"
    And I am on the page's page
    And I download the epub
  Then the download epub file should exist
    And the download epub command should include authors: "fandom1"
    And the download epub command should NOT include tags: "fandom1"

Scenario: many fandoms, many characters => characters in tags and comments, fandom in authors only
  Given a page exists with fandoms: "harry potter, sga" AND characters: "harry/snape, john/rodney"
  Then the download epub command should include authors: "harry potter"
    And the download epub command should include authors: "sga"
    And the download epub command should include tags: "harry/snape"
    And the download epub command should include tags: "john/rodney"
    And the download epub command should include comments: "harry/snape, john/rodney"
    But the download epub command should NOT include comments: "harry potter"
    And the download epub command should NOT include tags: "sga"
