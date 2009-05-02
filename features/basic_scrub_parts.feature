Feature: Basic scrubbing of parent
  What: scrub a parent page by scrubbing the parts
  Why: in order to be able to recreate the parent html from parts
  Result: when go to scrub a parent, should scrub the parts. also, scrubbing a part should re-make the parent's download

  Scenario: scrub a parent page
    Given I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
      And I fill in "page_url_substitutions" with "1 2 3"
      And I fill in "page_title" with "Multiple pages from base"
      And I press "Create"
     Then I should see "Multiple pages from base"
       And I should see "Part 1"
       And I should see "top cruft in part 1"
       And I should see "stuff for part 1"
       And I should see "bottom cruft in part 1"
       And I should see "Part 2"
     When I follow "Multiple pages from base" in ".title"
     Then My document should contain "top cruft in part 1"
     When I am on the homepage
     When I follow "Read"
     When I follow "Scrub"
      And I follow "Part 1"
      And I check boxes "0 2"
      And I press "Scrub"
     Then I should not see "top cruft in part 1"
       And I should not see "bottom cruft in part 1"
       And I should see "stuff for part 1"
       And I should see "stuff for part 2"
       And I should see "stuff for part 3"
    When I follow "Multiple pages from base" in ".title"
    Then My document should not contain "top cruft in part 1"
      And My document should not contain "bottom cruft in part 1"
      And My document should contain "stuff for part 1"
      And My document should contain "stuff for part 2"
      And My document should contain "stuff for part 3"
