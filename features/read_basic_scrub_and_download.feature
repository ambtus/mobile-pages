Feature: Basic Scrub and download

  Scenario: download, scrub and download
    Given a titled page exists with url: "http://test.sidrasue.com/p.html"
    When I am on the page's page
      And I follow "Text" within ".title"
    Then I should see "top para"
      And I should see "content"
      And I should see "bottom para"
    When I am on the page's page
      And I follow "Scrub"
      And I check boxes "0 bottom2"
      And I press "Scrub"
      And I should not see "top para"
      And I should not see "bottom para"
      And I should see "content"
    When I follow "Text" within ".title"
    Then I should not see "top para"
      And I should not see "bottom para"
      And I should see "content"
