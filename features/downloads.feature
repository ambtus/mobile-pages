Feature: downloads

  Scenario: html downloads
    Given a page exists with title: "Alice"
    When I am on the page's page
      And I follow "HTML"
    Then the download directory should exist for page titled "Alice"
    Then the download html file should exist for page titled "Alice"
    Then the download epub file should not exist for page titled "Alice"

  Scenario: epub downloads
    Given a page exists with title: "Bob"
    When I am on the page's page
      And I follow "ePub"
    Then the download directory should exist for page titled "Bob"
    Then the download html file should exist for page titled "Bob"
    Then the download epub file should exist for page titled "Bob"
