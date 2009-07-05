Feature: error checking scrub

  Scenario: tidy ocassionally re-adds &nbsp;
    Given I have no pages
      And I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/tidy.html"
      And I fill in "page_title" with "tidy text test"
      And I press "Store"
      And I follow "Download" in ".title"
      And My document should not contain "nbsp"
