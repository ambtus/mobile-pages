Feature: extended store

  Scenario: refetch original html
    Given the following page
      |title | url |
      | test | http://sidrasue.com/tests/test.html |
    When I am on the homepage
      And I follow "Read"
      And I follow "Edit Raw HTML"
      And I fill in "pasted" with "system down"
      And I press "Update Raw HTML"
    Then I should see "system down" in ".content"
    When I follow "Refetch"
    Then the field with id "url" should contain "http://sidrasue.com/tests/test.html"
    When I press "Refetch"
    Then I should see "Retrieved from the web" in ".content"

  Scenario: refetch original html for parts
    Given the following page
      |title | urls |
      | test | http://sidrasue.com/tests/parts/1.html |
    When I am on the homepage
      And I follow "Read"
    When I follow "Refetch" in ".title"
    Then the field with id "url_list" should contain "http://sidrasue.com/tests/parts/1.html"
    When I fill in "url_list" with lines "http://sidrasue.com/tests/parts/2.html\nhttp://sidrasue.com/tests/parts/1.html"
      And I press "Refetch"
    Then I should see "stuff for part 2"

  Scenario: add utf8
    Given the following page
      |title | url |
      | test | http://sidrasue.com/tests/sbutf8.html |
    When I am on the homepage
      And I follow "Read"
    Then I should see "â€œ"
    When I press "Raw HTML to UTF8"
    Then I should see "“H"

  Scenario: add utf8 to parts
    Given the following page
      |title | urls |
      | test | http://sidrasue.com/tests/sbutf8.html |
    When I am on the homepage
      And I follow "Read"
    Then I should see "â€œ"
    When I press "Raw HTML to UTF8"
    Then I should see "“H"

  Scenario: rebuild from latin1
    Given the following page
      |title | url |
      | test | http://sidrasue.com/tests/1252.html |
    When I am on the homepage
      And I follow "Read"
      And I follow "Scrub"
      And I check boxes "0"
      And I press "Scrub"
    Then I should not see "“H"
    When I press "Raw HTML to Latin1"
    Then I should see "“H"

  Scenario: rebuild from original (not raw) html
    Given the following page
      |title | url |
      | test | http://sidrasue.com/tests/1252.html |
    When I am on the homepage
      And I follow "Read"
      And I follow "Scrub"
      And I check boxes "0"
      And I press "Scrub"
    Then I should not see "“H"
      And I should see "Don’t—"
    When I press "Clean HTML"
    Then I should not see "“H"
      And I should see "Don’t—"
