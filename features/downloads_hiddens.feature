Feature: an ebook with a hidden tag is also hidden from marvin

  Scenario: epub download hidden page; author and tag and fandom strings are empty
    Given I have no pages
    And a page exists with hiddens: "hide me" AND tropes: "my tag" AND add_author_string: "my author" AND fandoms: "my fandom"
    Then the download epub command should include tags: "hide me"
    But the download epub command should NOT include tags: "my tag"
    But the download epub command should include comments: "my tag"
    And the download epub command should NOT include authors: "my author"
    But the download epub command should include comments: "my author"
    And the download epub command should NOT include series: "my fandom"
    But the download epub command should include comments: "my fandom"

  Scenario: epub of a parent omits hidden part but author and tag strings populated. epub download of a hidden part as standalone: author and tag strings are empty but are in comments
    Given I have no pages
    And a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2 3" AND tropes: "show me" AND add_author_string: "my author"
    When I am on the page with title "Part 2"
      And I edit its tags
      And I fill in "tags" with "hide me"
      And I press "Add Hidden Tags"
    When I am on the homepage
      Then I should NOT see "Part 2"
    When I am on the page's page
      Then I should see "Part 2"
      And I should see "hide me" within "#position_2"
    When I view the content
      Then I should NOT see "Part 2"
      And I should NOT see "hide me"
      And I should NOT see "stuff for part 2"
    And the download epub command should include tags: "show me"
    But the download epub command should NOT include tags: "hide me"
    And the download epub command should include authors: "my author"
    When I am on the page with title "Part 2"
      And I view the content
      Then I should see "stuff for part 2"
    And the download epub command for "Part 2" should NOT include tags: "show me"
    But the download epub command for "Part 2" should include tags: "hide me"
    And the download epub command for "Part 2" should NOT include authors: "my author"
    And the download epub command for "Part 2" should include comments: "by my author"
    And the download epub command for "Part 2" should include comments: "show me"
