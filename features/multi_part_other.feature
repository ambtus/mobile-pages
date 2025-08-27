Feature: other mult-part tests

Scenario: download part
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
  When I read "Part 1" online
  Then I should see "stuff for part 1"
    But I should NOT see "stuff for part 2"

Scenario: link to next part from part
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
  When I am on the first page's page
    And I follow "Part 1"
    And I follow "Part 2" within ".part"
  Then I should see "Part 2 (Chapter)" within ".title"

Scenario: link to previous part from part
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
  When I am on the first page's page
    And I follow "Part 2"
    And I follow "Part 1" within ".part"
  Then I should see "Part 1 (Chapter)" within ".title"

Scenario: next, not previous
  Given Counting Drabbles exists
  When I am on the first page's page
    And I follow "Skipping Stones"
  Then I should see "Next: The Flower"
    But I should NOT see 'Previous: The Flower'

Scenario: previous, not next
  Given Counting Drabbles exists
  When I am on the first page's page
    And I follow "The Flower"
  Then I should see "Previous: Skipping Stones"
    But I should NOT see 'Next: Skipping Stones'

Scenario: reorder the parts on an existing page with parts
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the first page's page
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
     And I click on "type_all"
     And I press "Find"
   Then I should see "Part 2 of Parent2" within "#position_1"
     And the page should NOT contain css "#position_2"

Scenario: remove tag from child bug
  Given a book with a tagged chapter exists
    And I am on the page with title "chapter 1"
    And I should see "interesting" within ".pros"
  When I follow "Tags" within ".meta"
    And I unselect "interesting"
  And I press "Update"
    Then I should NOT see "interesting" within ".pros"

Scenario: parent shows parts by position, not created order
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the first page's page
    And I refetch the following
      """
      http://test.sidrasue.com/parts/2.html
      http://test.sidrasue.com/parts/1.html
      """
  Then I should see "Part 2" before "Part 1"

Scenario: update without url bug
  Given I have a series with read_after "2009-01-02"
    And I am on the first page's page
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
  When I am on the first page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then the contents should include "This is the new part 1"
    And the contents should include "This is the new part 2"
    But the contents should NOT include "stuff for part"

Scenario: refetch recursive
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
    And I change the raw html for "Part 1" to "<p>This is the new part 1</p>"
    And I change the raw html for "Part 2" to "<p>This is the new part 2</p>"
  When I am on the first page's page
    And I follow "Refetch"
    And I press "Refetch Recursive"
  Then the contents should include "stuff for part 1"
    And the contents should include "stuff for part 2"
    But the contents should NOT include "This is the new part"

