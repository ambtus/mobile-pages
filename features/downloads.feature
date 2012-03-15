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

  Scenario: remove downloads
    Given a page exists with title: "Alice"
    When I am on the page's page
      And I follow "HTML"
    Then the download directory should exist for page titled "Alice"
    When I am on the page's page
       And I press "Remove Downloads"
    Then the download directory should not exist for page titled "Alice"

  Scenario: remove parent downloads
    Given a page exists with title: "Parent", urls: "http://test.sidrasue.com/parts/2.html##John\nhttp://test.sidrasue.com/parts/3.html"
    When I am on the page's page
      And I follow "HTML"
    Then the download directory should exist for page titled "Parent"
    When I am on the page's page
      And I follow "John"
       And I press "Remove Downloads"
    Then the download directory should not exist for page titled "Parent"

  Scenario: remove child downloads
    Given a page exists with title: "Parent", urls: "http://test.sidrasue.com/parts/2.html##John\nhttp://test.sidrasue.com/parts/3.html"
    When I am on the page's page
      And I follow "HTML"
    Then the download directory should exist for page titled "Parent"
      And the download directory should not exist for page titled "John"
    When I am on the page's page
       And I press "Remove Downloads"
    Then the download directory should not exist for page titled "Parent"
      And the download directory should not exist for page titled "John"
    When I am on the page's page
      And I follow "John"
      And I follow "HTML"
      And the download directory should exist for page titled "John"
    When I am on the page's page
       And I press "Remove Downloads"
    Then the download directory should not exist for page titled "Parent"
      And the download directory should not exist for page titled "John"
