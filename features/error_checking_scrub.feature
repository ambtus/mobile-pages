Feature: error checking scrub

  Scenario: tidy ocassionally re-adds &nbsp;
    Given the following page
      |title | url |
      | test | http://sidrasue.com/tests/tidy.html |
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should not contain "nbsp"

  Scenario: scrub a sub-part
    Given the following page
      |title | urls |
      | test | #Title\n##First Part\nhttp://sidrasue.com/tests/parts/1.html###SubPart |
      And I am on the homepage
    When I follow "Read"
      And I follow "Scrub"
      And I follow "Scrub First Part"
      And I follow "Scrub SubPart"
      And I check boxes "0 2"
      And I press "Scrub"
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "# First Part #"
      And my document should contain "## SubPart ##"
      And my document should contain "stuff for part 1"
    But my document should not contain "top cruft"
    And my document should not contain "bottom cruft"

  Scenario: scrub when many headers and short fic
    Given the following page
      |title | url |
      | test | http://sidrasue.com/tests/headers.html |
      And I am on the homepage
    When I follow "Read"
      And I follow "Scrub"
      And I check boxes "2 4"
      And I press "Scrub"
    When I am on the homepage
      And I follow "Download" in ".title"
    Then my document should contain "actual content"
      And my document should not contain "header"
