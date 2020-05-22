Feature: lj specific stuff

  Scenario: download livejournal adult content
    Given a titled page exists with url: "http://sidra.livejournal.com/3265.html"
    When I go to the page's page
      And I view the HTML
    Then I should not see "Adult Content"
      And I should see "alien"
