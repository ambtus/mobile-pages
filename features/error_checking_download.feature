Feature: errors on download

  Scenario: download with slashes in title
    Given the following page
      | title | url |
      | This title 1/2 | http://sidrasue.com/tests/test.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "Retrieved from the web"

  Scenario: download with periods in title
    Given the following page
      | title | url |
      | This.title.has.periods | http://sidrasue.com/tests/test.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "Retrieved from the web"

  Scenario: download with blank named anchor
    Given the following page
      | title           | url |
      | page with cutid | http://sidra.livejournal.com/838.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "Ron crouched"
      And my document should not contain "<a"