Feature: Basic scrub with parts
  What: scrub a parent page by scrubbing the parts
  Why: in order to be able to recreate the parent html from parts
  Result: when go to scrub a parent, should scrub the parts. also, scrubbing a part should re-make the parent's download

  Scenario: scrub a parent page
    Given a page exists with title: "Parent", base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
    And I am on the page's page
    When I follow "Read"
    Then I should see "cruft"
    When I follow "Download" in ".title"
    Then I should see "cruft"
    When I am on the page's page
    And I follow "Scrub" in ".title"
      And I follow "Scrub Part 1"
      And I check boxes "0 2"
      And I press "Scrub"
    Then I should not see "cruft"
      And I should see "stuff for part 1"
    When I follow "Parent" in ".parent"
      And I follow "Download" in ".title"
    Then I should not see "cruft"
      And I should see "stuff for part 1"
      And I should see "stuff for part 2"
