Feature: bugs on download

  Scenario: download with slashes in title 
    Given a page exists with title: "This title 1/2"
    When I go to the page's page
      And I follow "Download" in ".title"

  Scenario: download with periods in title
    Given a page exists with title: "This.title.has.periods"
    When I go to the page's page
      And I follow "Download" in ".title"

  Scenario: download with blank named anchor
    Given a titled page exists with url: "http://sidra.livejournal.com/838.html"
    When I go to the page's page
      And I follow "Download" in ".title"
    Then I should see "Ron crouched"
      And I should not see "<a"

  Scenario: download with spaces in title
    Given a page exists with title: "This title has spaces"
    When I go to the page's page
      And I follow "Download" in ".title"

  Scenario: download livejournal adult content
    Given a titled page exists with url: "http://sidra.livejournal.com/3265.html"
    When I go to the page's page
      And I follow "Download" in ".title"
    Then I should not see "Adult Content"
      And I should see "alien"

