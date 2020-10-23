Feature: lj specific stuff

  Scenario: download livejournal adult content
    Given I have no pages
    And a page exists with url: "http://sidra.livejournal.com/3265.html"
    When I am on the page's page
      And I view the content
    Then I should NOT see "Adult Content"
      And I should see "alien"
