Feature: Basic Scrub and download
  What: download after rescrubbing a page
  Why: maybe only noticed something after read it offline
  Result: new download should remove scrubbed content

  Scenario: download, scrub and download
    Given I have no pages
      And I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/styled.html"
      And I fill in "page_title" with "Styled text test"
      And I press "Store"
      And I follow "Download" in ".title"
      And My document should contain "#This is a header#"
    When I am on the homepage
      And I follow "Read"
      And I follow "Scrub"
      And I check boxes "0 3 4"
      And I press "Scrub"
      And I should not see "This is a header"
    When I follow "Download" in ".title"
    Then My document should not contain "#This is a header#"
      And My document should not contain "_________"
      And My document should contain "This sentence"
      And My document should contain "and some utf…"

