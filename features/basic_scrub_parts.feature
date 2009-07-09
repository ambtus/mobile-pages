Feature: Basic scrub with parts
  What: scrub a parent page by scrubbing the parts
  Why: in order to be able to recreate the parent html from parts
  Result: when go to scrub a parent, should scrub the parts. also, scrubbing a part should re-make the parent's download

  Scenario: scrub a parent page
    Given I have no pages
      And I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
      And I fill in "page_url_substitutions" with "1 2"
      And I fill in "page_title" with "Parent of crufty Page"
      And I press "Store"
     Then I should see "Parent of crufty Page"
       And I should see "Part 1"
       And I should see "top cruft in part 1"
       And I should see "stuff for part 1"
       And I should see "bottom cruft in part 1"
       And I should see "Part 2"
       And I should see "stuff for part 2"
     When I follow "Download" in ".title"
     Then My document should contain "top cruft in part 1"
     When I am on the homepage
     When I follow "Parts"
     Then I should not see "Scrub" in ".title"
     When I follow "Scrub" in "#position_1"
      And I check boxes "0 2"
      And I press "Scrub"
     Then I should not see "top cruft in part 1"
       And I should not see "bottom cruft in part 1"
       And I should see "stuff for part 1"
    When I follow "Parent of crufty Page" in ".parent"
      And I follow "Download" in ".title"
    Then My document should not contain "top cruft in part 1"
      And My document should not contain "bottom cruft in part 1"
      And My document should contain "stuff for part 1"
      And My document should contain "stuff for part 2"
