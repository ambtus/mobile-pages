Feature: filter on titles

Scenario: Find page by title (first)
  Given a page exists with title: "A Christmas Carol by Charles Dickens"
   When I am on the filter page
     And I fill in "page_title" with "A"
     And I press "Find"
   Then I should see "A Christmas Carol by Charles Dickens" within "#position_1"

Scenario: Find page by title (middle)
  Given a page exists with title: "A Christmas Carol by Charles Dickens"
   When I am on the filter page
     And I fill in "page_title" with "by"
     And I press "Find"
   Then I should see "A Christmas Carol by Charles Dickens" within "#position_1"

Scenario: Find page by title (last)
  Given a page exists with title: "A Christmas Carol by Charles Dickens"
   When I am on the filter page
     And I fill in "page_title" with "Dickens"
     And I press "Find"
   Then I should see "A Christmas Carol by Charles Dickens" within "#position_1"

Scenario: Find page by title (whole)
  Given a page exists with title: "A Christmas Carol by Charles Dickens"
   When I am on the filter page
     And I fill in "page_title" with "A Christmas Carol by Charles Dickens"
     And I press "Find"
   Then I should see "A Christmas Carol by Charles Dickens" within "#position_1"

Scenario: check before No matching title
  Given a page exists
  When I am on the homepage
  Then I should see "Page 1"

Scenario: No matching title
  Given a page exists
  When I am on the filter page
    And I fill in "page_title" with "Pages"
    And I press "Find"
  Then I should see "No pages found" within "#flash_alert"
    And I should NOT see "Page 1"

Scenario: check before case insensitive title search
  Given 5 pages exist
    And a page exists with title: "The Blue Book" AND url: "http://test.sidrasue.com/test.html"
  When I am on the homepage
    Then I should NOT see "The Blue Book"

Scenario: case insensitive title search
  Given 5 pages exist
    And a page exists with title: "The Blue Book" AND url: "http://test.sidrasue.com/test.html"
  When I am on the filter page
    And I fill in "page_title" with "blue book"
    And I press "Find"
  Then I should see "The Blue Book"

Scenario: check before limit number of found pages
  Given 6 pages exist
  When I am on the filter page
    And I fill in "page_title" with "Page 6"
    And I press "Find"
  Then I should see "Page 6"

Scenario: limit number of found pages
  Given 6 pages exist
  When I am on the filter page
    And I fill in "page_title" with "Page"
    And I press "Find"
  Then I should see "Page 1"
    And I should see "Page 2"
    And I should see "Page 3"
    And I should see "Page 4"
    And I should see "Page 5"
    But I should NOT see "Page 6"
