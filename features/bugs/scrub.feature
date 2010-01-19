Feature: bugs with scrub

  Scenario: tidy ocassionally re-adds &nbsp;
    Given a titled page exists with url: "http://test.sidrasue.com/tidy.html"
    When I am on the page's page
      And I follow "Download" in ".title"
    Then I should not see "nbsp"

  Scenario: scrub a sub-part
    Given a titled page exists with urls: "##First Part\nhttp://test.sidrasue.com/parts/1.html###SubPart"
    When I am on the page's page
      And I follow "Scrub"
      And I follow "Scrub First Part"
      And I follow "Scrub SubPart"
      And I check boxes "0 2"
      And I press "Scrub"
    When I am on the homepage
      And I follow "Download" in ".title"
    Then I should see "First Part #"
      And I should see "## SubPart ##"
      And I should see "stuff for part 1"
    But I should not see "top cruft"
    And I should not see "bottom cruft"

  Scenario: scrub when many headers and short fic
    Given a titled page exists with url: "http://test.sidrasue.com/headers.html"
    When I am on the page's page
      And I follow "Scrub"
      And I check boxes "2 4"
      And I press "Scrub"
      And I follow "Download" in ".title"
    Then I should see "actual content"
      And I should not see "header"
