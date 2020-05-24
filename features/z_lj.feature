Feature: lj specific stuff

  Scenario: download livejournal adult content
    Given a page exists with url: "http://sidra.livejournal.com/3265.html"
    When I am on the page's page
      And I view the HTML
    Then I should not see "Adult Content"
      And I should see "alien"
