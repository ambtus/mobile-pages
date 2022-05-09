Feature: removing parts from parents and parents from parts

Scenario: uncollect should delete parent
  Given I am on the "Store Multiple" page
    And I fill in "page_urls" with
      """
      http://test.sidrasue.com/parts/1.html##One
      http://test.sidrasue.com/parts/2.html##Two
      """
    And I fill in "page_title" with "Page 1"
    And I press "Store"
    And I am on the page's page
    And I press "Uncollect"
  Then I should see "Uncollected" within "#flash_notice"
    And I should see "One"
    And I should see "Two"
    And I should NOT see "Page 1"
    And I should have 2 pages

Scenario: remove a part from an existing page with parts (make single)
  Given a page exists with title: "Multi" AND base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 3"
  When I am on the page with title "Part 2"
    And I press "Make Single"
    And I am on the homepage
  Then I should see "Multi" within "#position_1"
    And I should see "Part 2" within "#position_2"

Scenario: remove a part from an existing page with parts (content)
  Given a page exists with title: "Multi" AND base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-3"
  When I am on the page with title "Part 2"
    And I press "Make Single"
    And I am on the page's page
  Then the contents should include "stuff for part 1"
    And the contents should include "stuff for part 3"
    But the contents should NOT include "stuff for part 2"

Scenario: remove a part from an existing page with parts (content)
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-3"
  When I am on the page's page
    And I refetch the following
      """
      http://test.sidrasue.com/parts/1.html
      http://test.sidrasue.com/parts/2.html
      """
  Then I should see "(2 parts)" within ".size"
    And I should NOT see "Part 3"
    But I should see "Part 1"
    And I should see "Part 2"

Scenario: remove a part from an existing page with parts (manage parts)
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-3"
  When I am on the page's page
    And I refetch the following
      """
      http://test.sidrasue.com/parts/1.html
      http://test.sidrasue.com/parts/2.html
      """
    And I am on the homepage
  Then I should see "Page 1" within "#position_1"
    And I should see "Part 3" within "#position_2"

