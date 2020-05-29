Feature: an ebook with a hidden tag is also hidden from marvin

  Scenario: epub download hidden page; author and tag strings are empty
    Given a page exists with hiddens: "hide me" AND tags: "my tag" AND add_author_string: "my author"
    Then the download epub command should include tags: "hide me"
    But the download epub command should not include tags: "my tag"
    But the download epub command should include comments: "my tag"
    And the download epub command should not include authors: "my author"
    But the download epub command should include comments: "my author"

  @wip
  Scenario: epub download hidden part as standalone; author and tag strings are empty

  @wip
  Scenario: epub omits hidden part of parent; author and tag strings populated

