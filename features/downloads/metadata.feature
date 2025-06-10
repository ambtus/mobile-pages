Feature: downloads metadata

Scenario: basic
  Given a page exists with pros: "tag1"
  When I download its epub
  Then the download epub file should exist
    And the download epub command should include tags: "tag1"

Scenario: wip?
  Given wip exists
  When I download its epub
  Then the download epub file should exist
    And the download epub command should include tags: "WIP"
    And the download epub command should include comments: "WIP"

Scenario: favorite tag
  Given favorite exists
  When I download its epub
  Then the download epub file should exist
    And the download epub command should include tags: "Favorite"
    And the download epub command should include comments: "Favorite"

Scenario: author and fandom and tag strings are all in tags (as well as author)
  Given a page exists with fandoms: "my fandom" AND authors: "my author" AND pros: 'my pro'
  Then the download epub command should include tags: "my fandom"
    And the download epub command should include tags: "my author"
    And the download epub command should include tags: "my pro"
    And the download epub command should include authors: "my author"
    And the download epub command should include authors: "my fandom"
  But the download epub command should NOT include comments: "my author"
    And the download epub command should NOT include comments: "my fandom"
    And the download epub command should include comments: "my pro"

Scenario: drabble and has an info tag (not displayed)
  Given a page exists with infos: "tag1"
  Then the download epub command should NOT include tags: "tag1"
    And the download epub command should include tags: "drabble"
    And the download epub command should include tags: "unread"
    And the download epub command should include comments: "0 words"
    But the download epub command should NOT include comments: "tag1"
    And the download epub command should NOT include comments: "drabble"

Scenario: epub page; author and tag strings are populated
  Given a page exists with pros: "my tag" AND authors: "my author"
  Then the download epub command should include tags: "my tag"
    And the download epub command should include authors: "my author"
    And the download epub command should NOT include comments: "my author"
    But the download epub command should include comments: "my tag"

Scenario: do not put aka in author tag for epub
  Given a page exists with authors: "my author (AKA)"
  Then the download epub command should include authors: "my author"
    But the download epub command should NOT include authors: "AKA"
    And the download epub command should NOT include comments: "my author (AKA)"

Scenario: drabble and has a tag
  Given a page exists with pros: "tag1"
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
  Given a page exists with pros: "tag1"
  When I download its epub
    And I am on the edit tag page for "tag1"
    And I fill in "tag_name" with "fandom1"
    And I press "Update"
  Then the download epub file should NOT exist

Scenario: tag name changes => new epub has new name
  Given a page exists with pros: "tag1"
  When I download its epub
    And I am on the edit tag page for "tag1"
    And I fill in "tag_name" with "fandom1"
    And I press "Update"
    And I download its epub
  Then the download epub file should exist
    And the download epub command should include tags: "fandom1"
    And the download epub command should NOT include tags: "tag1"
    And the download epub command should NOT include authors: "fandom1"

Scenario: tag type changes => remove outdated downloads
  Given a page exists with pros: "fandom1"
  When I download its epub
    And I am on the edit tag page for "fandom1"
    And I select "Fandom" from "change"
    And I press "Change"
  Then the download epub file should NOT exist

Scenario: tag type changes => new epub reflects change
  Given a page exists with pros: "fandom1"
  When I download its epub
    And I am on the edit tag page for "fandom1"
    And I select "Fandom" from "change"
    And I press "Change"
    And I download its epub
  Then the download epub file should exist
    And the download epub command should include authors: "fandom1"
    And the download epub command should include tags: "fandom1"

Scenario: many fandoms, many pros => pros in tags and comments, fandom in authors only
  Given a page exists with fandoms: "harry potter, sga" AND pros: "harry/snape, john/rodney"
  Then the download epub command should include authors: "harry potter"
    And the download epub command should include authors: "sga"
    And the download epub command should include tags: "harry/snape"
    And the download epub command should include tags: "john/rodney"
    And the download epub command should include comments: "harry/snape, john/rodney"
    But the download epub command should NOT include comments: "harry potter"
    And the download epub command should NOT include comments: "sga"
    But the download epub command should include tags: "harry potter"
    And the download epub command should include tags: "sga"

Scenario: suppress AKA's
  Given a page exists with fandoms: "harry potter (Fantastic Beasts)" AND authors: "jane (june)"
  Then the download epub command should include authors: "harry potter"
    And the download epub command should include authors: "jane"
    But the download epub command should NOT include authors: "Fantastic Beasts"
    And the download epub command should NOT include authors: "june"
    And the download epub command should NOT include comments: "june"
    And the download epub command should NOT include comments: "Fantastic Beasts"
    And the download epub command should include tags: "harry potter"
    And the download epub command should include tags: "jane"
    But the download epub command should NOT include tags: "Fantastic Beasts"
    And the download epub command should NOT include tags: "june"
