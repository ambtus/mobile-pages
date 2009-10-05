Feature: Basic scrub with parts
  What: scrub a parent page by scrubbing the parts
  Why: in order to be able to recreate the parent html from parts
  Result: when go to scrub a parent, should scrub the parts. also, scrubbing a part should re-make the parent's download

  Scenario: scrub a parent page
    Given the following page
      | title | base_url | url_substitutions |
      | Parent | http://sidrasue.com/tests/parts/*.html | 1 2 |
    When I am on the homepage
      And I follow "Parts"
      And I follow "Read"
      And I should see "cruft"
    When I follow "Download" in ".title"
    Then my document should contain "cruft"
    When I am on the homepage
    When I follow "Parts"
      And I follow "Scrub" in "#position_1"
      And I check boxes "0 2"
      And I press "Scrub"
    Then I should not see "cruft"
      And I should see "stuff for part 1"
    When I follow "Parent" in ".parent"
      And I follow "Download" in ".title"
    Then my document should not contain "cruft"
      And my document should contain "stuff for part 1"
      And my document should contain "stuff for part 2"
