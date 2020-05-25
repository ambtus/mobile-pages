Feature: an ebook with a hidden tag is also hidden from marvin

  Scenario: epub download hidden page; author and tag strings are empty
    Given a page exists with hiddens: "hide me" AND tags: "my tag" AND add_author_string: "my author"
    When I am on the page's page
      And I download the epub
    Then the download epub file should exist

  Scenario: epub download hidden part; author and tag strings are empty

  Scenario: epub omits hidden part; author and tag strings populated

