Feature: error checking scrub

  Scenario: tidy ocassionally re-adds &nbsp;
    Given I have no pages
      And I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/tidy.html"
      And I fill in "page_title" with "tidy text test"
      And I press "Store"
      And I follow "Download" in ".title"
      And My document should not contain "nbsp"

  Scenario: scrub a sub-part
     Given I am on the homepage
     And I have no pages
       And I follow "Store Multiple"
       When I fill in "page_urls" with "#Title\n##First Part\nhttp://www.rawbw.com/~alice/parts/1.html###SubPart"
       And I fill in "page_title" with "Will be overwritten"
       And I press "Store"
       When I follow "Scrub"
       And I follow "Scrub First Part"
       And I follow "Scrub SubPart"
       And I check boxes "0 2"
       And I press "Scrub"
     When I am on the homepage
       And I follow "Download" in ".title"
     Then My document should contain "# First Part #"
       And My document should contain "## SubPart ##"
       And My document should contain "stuff for part 1"
     But My document should not contain "top cruft"
     And My document should not contain "bottom cruft"


