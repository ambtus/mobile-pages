Feature: Basic Scrub and download

  Scenario: download, scrub and download
    Given the following page
      | title  | url |
      | multi  | http://sidrasue.com/tests/p.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "top para"
      And my document should contain "content"
      And my document should contain "bottom para"
    When I am on the homepage
      And I follow "Read"
      And I follow "Scrub"
      And I check boxes "0 2"
      And I press "Scrub"
      And I should not see "top para"
      And I should not see "bottom para"
      And I should see "content"
    When I follow "Download" in ".title"
    Then my document should not contain "top para"
      And my document should not contain "bottom para"
      And my document should contain "content"
