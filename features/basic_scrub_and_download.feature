Feature: Basic Scrub and download
  What: download after rescrubbing a page
  Why: maybe only noticed something after read it offline
  Result: new download should remove scrubbed content

  Scenario: download, scrub and download
    Given I have no pages
      And I am on the homepage
      And I fill in "page_url" with "http://sidrasue.com/tests/p.html"
      And I fill in "page_title" with "test"
      And I press "Store"
      And I follow "Download" in ".title"
      And My document should contain "top para"
      And My document should contain "content"
      And My document should contain "bottom para"
    When I am on the homepage
      And I follow "Read"
      And I follow "Scrub"
      And I check boxes "0 2"
      And I press "Scrub"
      And I should not see "top para"
      And I should not see "bottom para"
      And I should see "content"
    When I follow "Download" in ".title"
    Then My document should not contain "top para"
      And My document should not contain "bottom para"
      And My document should contain "content"
