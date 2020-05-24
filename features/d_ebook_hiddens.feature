Feature: TODO an ebook with a hidden tag is also hidden from marvin - its author and tag strings are empty and put into the comment string.

  Scenario: epub downloads
    Given a page exists with title: "Charlie" AND add_hiddens_from_string: "hide me" AND add_tags_from_string: "my tag" AND add_author_string: "my author"
    When I am on the page with title "Charlie"
      And I follow "ePub"
    Then the download epub file should exist for page titled "Charlie"
