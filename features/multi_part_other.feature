Feature: other mult-part tests

Scenario: download part
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
  When I am on the page's page
    And I follow "Part 1"
    And I view the content
  Then I should see "stuff for part 1"
    And I should NOT see "stuff for part 2"

Scenario: link to next part from part
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
  When I am on the page's page
    And I follow "Part 1"
    And I follow "Part 2" within ".part"
    And I view the content
  Then I should see "stuff for part 2"
    And I should NOT see "stuff for part 1"

Scenario: reorder the parts on an existing page with parts
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the page's page
    And I follow "Manage Parts"
    And I fill in "url_list" with
      """
      http://test.sidrasue.com/parts/2.html
      http://test.sidrasue.com/parts/1.html
      """
    And I press "Update"
    And I view the content for part 1
  Then I should see "stuff for part 2"

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

Scenario: new parent for an existing page should have the same last read date
  Given a page exists with title: "Single" AND last_read: "2008-01-01"
  When I am on the homepage
    And I follow "Single"
    And I follow "Manage Parts"
    And I fill in "add_parent" with "New Parent"
    And I press "Update"
    And I am on the homepage
  Then I should see "New Parent" within "#position_1"
    And I should see "2008-01-01" within "#position_1"

Scenario: parent should be able to remove duplicate tags and authors
  Given a page exists with url: "http://test.sidrasue.com/parts/1.html" AND fandoms: "Harry Potter, SGA" AND authors: "JK Rowling"
    And a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND fandoms: "Harry Potter" AND title: "Parent" AND authors: "JK Rowling"
  When I am on the page with title "Parent"
    And I press "Remove Duplicate Tags"
  Then I should NOT see "Harry Potter" within "#position_1"
    And I should NOT see "JK Rowling" within "#position_1"
    But I should see "SGA" within "#position_1"

