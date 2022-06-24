Feature: page size

Scenario: long
  Given a page exists with url: "http://test.sidrasue.com/40000.html"
  When I am on the page's page
  Then I should see "40,020 words" within ".size"

Scenario: find and change size from long to medium
  Given a page exists with url: "http://test.sidrasue.com/40000.html"
  When I am on the filter page
    And I click on "size_long"
    And I press "Find"
    And I follow "Page 1"
    And I follow "Refetch"
    And I fill in "url" with "http://test.sidrasue.com/8000.html"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"
    And I should see "8,318 words" within ".size"

Scenario: find and change size from medium to short
  Given a page exists with url: "http://test.sidrasue.com/8000.html"
  When I am on the filter page
    And I click on "size_medium"
    And I press "Find"
    And I follow "Page 1"
    And I follow "Refetch"
    And I fill in "url" with "http://test.sidrasue.com/short.html"
    And I press "Refetch"
  Then I should see "948 words" within ".size"

Scenario: find and change size from short to long
  Given a page exists with url: "http://test.sidrasue.com/short.html"
  When I am on the filter page
    And I click on "size_short"
    And I press "Find"
    And I follow "Page 1"
    And I follow "Refetch"
    And I fill in "url" with "http://test.sidrasue.com/40000.html"
    And I press "Refetch"
  Then I should see "40,020 words" within ".size"

Scenario: sizes of parts
  Given a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1-2"
  When I am on the page's page
  Then I should see "20,002 words" within ".size"

Scenario: find by size of parent and change size of part
  Given a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1-2"
  When I am on the filter page
  When I click on "size_medium"
    And I press "Find"
    And I follow "Page 1"
    And I follow "Part 1"
    And I follow "Refetch"
    And I fill in "url" with "http://test.sidrasue.com/8000.html"
    And I press "Refetch"
  Then I should see "8,318 words" within ".size"

Scenario: new size of parent
  Given a page exists with base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1-2"
  When I am on the page's page
    And I follow "Part 1"
    And I follow "Refetch"
    And I fill in "url" with "http://test.sidrasue.com/8000.html"
    And I press "Refetch"
    And I follow "Page 1" within ".parent"
  Then I should see "18,319 words" within ".size"

Scenario: new size of part
  Given a page exists with base_url: "http://test.sidrasue.com/epic*.html" AND url_substitutions: "1-2"
  When I am on the page's page
    And I follow "Part 1"
    And I follow "Refetch"
    And I fill in "url" with "http://test.sidrasue.com/8000.html"
    And I press "Refetch"
    And I am on the filter page
  When I click on "size_medium"
  And I click on "type_Chapter"
    And I press "Find"
  Then I should see "Part 1 of Page 1" within "#position_1"
    And I should NOT see "Part 2 of Page 1"
