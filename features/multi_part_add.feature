Feature: add parts to parents and parents to parts

Scenario: create a new parent for an existing page
  Given a page exists with url: "http://test.sidrasue.com/test.html"
  When I am on the page's page
    And I add a parent with title "Parent"
  Then I should see "Parent (Book)" within ".title"
    And I should see "(1 part)" within ".size"
    And I should see "Page 1" within "#position_1"

Scenario: can't add a page to an ambiguous parent
  Given a page exists with title: "Ambiguous1"
    And a page exists with title: "Ambiguous2"
    And a page exists with title: "Single"
  When I am on the page with title "Single"
    And I add a parent with title "Ambiguous"
  Then I should see "More than one page with that title"
    And I should NOT see "Ambiguous" within ".title"

Scenario: can't add a part to a page with content
  Given a page exists with title: "Styled" AND url: "http://test.sidrasue.com/styled.html"
    And a page exists with title: "Single"
  When I am on the page with title "Single"
    And I add a parent with title "Styled"
  Then I should see "Parent with that title has content"
    And I should NOT see "Styled" within ".title"

Scenario: can't add yourself to your parts
  Given a page exists with url: "http://test.sidrasue.com/test.html"
  When I am on the page's page
    And I follow "Refetch"
  Then the page should NOT contain css "#url_list"
    But the page should contain css "#url"

Scenario: add an existing page to an existing page with parts
  Given a page exists with title: "Single" AND url: "http://test.sidrasue.com/parts/3.html"
    And a page exists with title: "Multi" AND base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the homepage
    And I follow "Single"
    And I add a parent with title "Multi"
  Then I should see "Page added to this parent"
    And I should see "3 parts" within ".size"
    And I should see "Part 1" within "#position_1"
    And I should see "Part 2" within "#position_2"
    And I should see "3. Single" within "#position_3"

Scenario: add a part shows last part's url for easy editing
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-2"
  When I am on the page's page
    And I follow "Add Part"
  Then the "add_url" field should contain "http://test.sidrasue.com/parts/2.html"

Scenario: add a single part to an existing parent
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-2"
  When I am on the page's page
    And I follow "Add Part"
    And I fill in "add_url" with "http://test.sidrasue.com/parts/3.html"
    And I press "Add"
  Then I should see "Page 1 (Book)"
    And I should see "(3 parts)" within ".size"
    And I should see "Part added"
    And I should see "Part 3" within "#position_3"
    And the contents should include "stuff for part 3"

Scenario: add two new parts via manage parts
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html"
  When I am on the page's page
    And I refetch the following
      """
      http://test.sidrasue.com/parts/1.html
      http://test.sidrasue.com/parts/2.html
      http://test.sidrasue.com/parts/3.html
      """
  Then I should see "Page 1 (Book)"
    And I should see "(3 parts)" within ".size"
    And I should see "Part 2" within "#position_2"
    And I should see "Part 3" within "#position_3"

Scenario: add two new parts via refetch
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html"
  When I am on the page's page
    And I refetch the following
      """
      http://test.sidrasue.com/parts/1.html
      http://test.sidrasue.com/parts/2.html
      http://test.sidrasue.com/parts/3.html
      """
  Then I should see "Refetched" within "#flash_notice"
    And the contents should include "stuff for part 2"
    And the contents should include "stuff for part 3"

Scenario: add a parent doesn't match the parent's read_after
  Given a page exists with title: "Page 1" AND url: "http://test.sidrasue.com/parts/1.html" AND read_after: "2050-01-01"
    And a page exists with title: "Page 2" AND url: "http://test.sidrasue.com/parts/2.html" AND read_after: "2050-01-02"
  When I am on the page with title "Page 2"
    And I add a parent with title "New Parent"
  Then the read after date for "Page 1" should be "2050-01-01"
    And the read after date for "Page 2" should be "2050-01-02"
    But the read after date for "New Parent" should be today

Scenario: add a part doesn't match the parent's read_after
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html" AND read_after: "2050-01-01"
  When I am on the page with title "Page 1"
    And I refetch the following
      """
      http://test.sidrasue.com/parts/1.html
      http://test.sidrasue.com/parts/2.html
      """
  Then the read after date for "Page 1" should be today
    And the read after date for "Part 1" should be "2050-01-01"
    And the read after date for "Part 2" should be today

