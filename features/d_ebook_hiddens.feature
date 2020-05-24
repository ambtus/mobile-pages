Feature: TODO an ebook with a hidden tag is also hidden from marvin - its author and tag strings are empty and put into the comment string.

  Scenario: epub download hidden page
    Given a page exists with title: "Charlie" AND hiddens: "hide me" AND tags: "my tag" AND add_author_string: "my author"
    When I am on the page with title "Charlie"
      And I follow "ePub"
    Then the download epub file should exist for page titled "Charlie"

  Scenario: epub with hidden part should not download that part

  Scenario: epub download hidden part
