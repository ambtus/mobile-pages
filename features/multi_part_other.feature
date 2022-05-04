Feature: other mult-part tests

Scenario: download part
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
  When I read "Part 1" online
  Then I should see "stuff for part 1"
    But I should NOT see "stuff for part 2"

Scenario: link to next part from part
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
  When I am on the page's page
    And I follow "Part 1"
    And I follow "Part 2" within ".part"
  Then I should see "Part 2 (Chapter)" within ".title"

Scenario: reorder the parts on an existing page with parts
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the page's page
    And I refetch the following
      """
      http://test.sidrasue.com/parts/2.html
      http://test.sidrasue.com/parts/1.html
      """
    And I follow "HTML" within "#position_1"
  Then I should see "stuff for part 2"
    And I should NOT see "stuff for part 1"

Scenario: find a part
  Given the following pages
    | title   | base_url                              | url_substitutions |
    | Parent1 | http://test.sidrasue.com/parts/*.html | 1   |
    | Parent2 | http://test.sidrasue.com/parts/*.html | 2 3 |
   When I am on the filter page
     And I fill in "page_title" with "Part 2"
     And I press "Find"
   Then I should see "Part 2 of Parent2" within "#position_1"
     And the page should NOT contain css "#position_2"

Scenario: parent should be able to remove duplicate tags and authors
  Given a page exists with url: "http://test.sidrasue.com/parts/1.html" AND fandoms: "Harry Potter, SGA" AND authors: "JK Rowling"
    And a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND fandoms: "Harry Potter" AND title: "Parent" AND authors: "JK Rowling"
  When I am on the page with title "Parent"
    And I press "Remove Duplicate Tags"
  Then I should NOT see "Harry Potter" within "#position_1"
    And I should NOT see "JK Rowling" within "#position_1"
    But I should see "SGA" within "#position_1"

Scenario: parent shows parts by position, not created order
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the page's page
    And I refetch the following
      """
      http://test.sidrasue.com/parts/2.html
      http://test.sidrasue.com/parts/1.html
      """
  Then I should see "Part 2" before "Part 1"

Scenario: update without url bug
  Given I have a series with read_after "2009-01-02"
    And I am on the page's page
  When I refetch the following
    """
    ##Parent1
    ##Parent2
    http://test.sidrasue.com/long1.html##Single
    """
  Then I should see "Single" within "#position_3"

Scenario: refetch non-recursive
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
    And I change the raw html for "Part 1" to "<p>This is the new part 1</p>"
    And I change the raw html for "Part 2" to "<p>This is the new part 2</p>"
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then the contents should include "This is the new part 1"
    And the contents should include "This is the new part 2"
    But the contents should NOT include "stuff for part"

Scenario: refetch recursive
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
    And I change the raw html for "Part 1" to "<p>This is the new part 1</p>"
    And I change the raw html for "Part 2" to "<p>This is the new part 2</p>"
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch Recursive"
  Then the contents should include "stuff for part 1"
    And the contents should include "stuff for part 2"
    But the contents should NOT include "This is the new part"

