Feature: bugs on download

  Scenario: download with slashes in title
    Given the following page
      | title | url |
      | This title 1/2 | http://test.sidrasue.com/test.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then I should see "Retrieved from the web"

  Scenario: download with periods in title
    Given the following page
      | title | url |
      | This.title.has.periods | http://test.sidrasue.com/test.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then I should see "Retrieved from the web"

  Scenario: download with blank named anchor
    Given the following page
      | title           | url |
      | page with cutid | http://sidra.livejournal.com/838.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then I should see "Ron crouched"
      And I should not see "<a"

  Scenario: download with spaces in title
    Given the following page
      | title | url |
      | This title has spaces | http://test.sidrasue.com/test.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then I should see "Retrieved from the web"

  Scenario: download livejournal adult content
    Given the following page
      | title           | url |
      | page with cutid | http://sidra.livejournal.com/3265.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then I should not see "Adult Content"
      And I should see "alien"

