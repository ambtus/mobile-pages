Feature: error checking scrub

  Scenario: tidy ocassionally re-adds &nbsp;
    Given I have no pages
      And I am on the homepage
      And I fill in "page_url" with "http://sidrasue.com/tests/tidy.html"
      And I fill in "page_title" with "tidy text test"
      And I press "Store"
      And I follow "Download" in ".title"
      And My document should not contain "nbsp"

  Scenario: scrub a sub-part
     Given I am on the homepage
     And I have no pages
       And I follow "Store Multiple"
       When I fill in "page_urls" with "#Title\n##First Part\nhttp://sidrasue.com/tests/parts/1.html###SubPart"
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

  Scenario: scrub when many headers and short fic
    Given I have no pages
      And I am on the homepage
      And I fill in "page_url" with "http://sidrasue.com/tests/headers.html"
      And I fill in "page_title" with "header test"
      And I press "Store"
    When I follow "Scrub"
      And I check boxes "2 4"
      And I press "Scrub"
    When I am on the homepage
      And I follow "Download" in ".title"
    Then My document should contain "actual content"
      And My document should not contain "header"
