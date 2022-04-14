Feature: an ebook with a hidden tag is also hidden from marvin's tag collections
         but author and fandom still show on cover

Scenario: epub download hidden page => tag strings are empty, but authors still includes authors & fandoms
  Given a page exists with hiddens: "hide me" AND pros: "my tag" AND authors: "my author" AND fandoms: "my fandom"
  Then the download epub command should include tags: "hide me"
    But the download epub command should NOT include tags: "my tag"
    But the download epub command should include comments: "my tag"
    And the download epub command should include authors: "my author"
    And the download epub command should include authors: "my fandom"
    But the download epub command should NOT include comments: "my author"
    And the download epub command should NOT include comments: "my fandom"

Scenario: epub parent of hidden part hides hidden part
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2 3" AND pros: "show me" AND authors: "my author" AND fandoms: "my fandom"
  When I am on the page with title "Part 2"
    And I edit its tags
    And I fill in "tags" with "hide me"
    And I press "Add Hidden Tags"
    And I follow "Page 1"
    And I follow "ePub"
  Then the epub html contents for "Page 1" should NOT contain "Part 2"
    And the epub html contents for "Page 1" should NOT contain "stuff for part 2"
    And the download epub command should include tags: "show me"
    And the download epub command should NOT include tags: "hide me"

Scenario: epub download hidden part as standalone => other tag strings are empty, but author and fandom aren't
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2 3" AND pros: "show me" AND authors: "my author" AND fandoms: "my fandom"
  When I am on the page with title "Part 2"
    And I edit its tags
    And I fill in "tags" with "hide me"
    And I press "Add Hidden Tags"
    And I edit its tags
    And I fill in "tags" with "devil"
    And I press "Add Con Tags"
    And I follow "ePub"
  Then the epub html contents for "Part 2" should contain "stuff for part 2"
    And the epub html contents for "Part 2" should contain "Part 2"
    And the download epub command for "Part 2" should include tags: "hide me"
    And the download epub command for "Part 2" should include authors: "my author"
    And the download epub command for "Part 2" should include authors: "my fandom"
    But the download epub command for "Part 2" should NOT include tags: "devil"
    And the download epub command for "Part 2" should NOT include tags: "show me"
    But the download epub command for "Part 2" should include comments: "show me"
    And the download epub command for "Part 2" should include comments: "devil"
