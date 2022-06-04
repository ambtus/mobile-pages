Feature: multi-part pages

Scenario: children should NOT show up on front page by themselves
  Given a page exists with title: "Parent" AND urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
  When I am on the homepage
  Then I should see "Parent" within "#position_1"
    But I should NOT see "Part 1"

Scenario: holder page for parts is okay
  Given I am on the create page
  When I fill in "page_title" with "Only entered Title"
    And I press "Store"
  Then I should see "Page created" within "#flash_notice"
    And I should have 1 page

Scenario: create from a list of urls
  When I am on the "Store Multiple" page
    And I fill in "page_urls" with
      """
      http://test.sidrasue.com/parts/1.html
      http://test.sidrasue.com/parts/2.html
      """
   And I fill in "page_title" with "Multiple pages from urls"
   And I press "Store"
   And I read "Multiple pages from urls" online
 Then I should see "Part 1"
   And I should see "Part 2"
   And I should see "stuff for part 1"
   And I should see "stuff for part 2"

Scenario: create a page from a list of urls with author and tags and notes
  Given "mytag" is a "Fandom"
    And "myauthor" is an "Author"
  When I am on the "Store Multiple" page
    And I fill in "page_urls" with
      """
      http://test.sidrasue.com/parts/1.html
      http://test.sidrasue.com/parts/2.html
      """
    And I fill in "page_title" with "Multiple pages from urls"
    And I fill in "page_notes" with "some notes"
    And I select "mytag"
    And I select "myauthor"
    And I press "Store"
  Then I should see "Multiple pages from urls"
    And I should see "mytag" within ".fandoms"
    And I should see "some notes" within ".notes"
    And I should see "myauthor" within ".authors"
    And I should see "Part 1" within "#position_1"
    And I should see "Part 2" within "#position_2"

Scenario: create from a list of urls some of which have titles
  Given I am on the "Store Multiple" page
  When I fill in "page_urls" with
      """
      http://test.sidrasue.com/parts/1.html

      http://test.sidrasue.com/parts/2.html##part title
      """
    And I fill in "page_title" with "my title"
    And I press "Store"
  Then I should see "Part 1" within "#position_1"
    And I should see "part title" within "#position_2"
    But I should NOT see "Part 2"

Scenario: create from base url plus range
  Given I am on the "Store Multiple" page
    And I fill in "page_base_url" with "http://test.sidrasue.com/parts/*.html"
    And I fill in "page_url_substitutions" with "1-3"
    And I fill in "page_title" with "Multiple pages from base"
    And I press "Store"
  When I read it online
  Then I should see "Part 1"
    And I should see "Part 2"
    And I should see "Part 3"
    And I should see "stuff for part 1"
    And I should see "stuff for part 2"
    And I should see "stuff for part 3"

Scenario: create from base url plus substitutions
  Given I am on the "Store Multiple" page
    And I fill in "page_base_url" with "http://test.sidrasue.com/parts/*.html"
    And I fill in "page_url_substitutions" with "1 3"
    And I fill in "page_title" with "Multiple pages from base"
    And I press "Store"
  When I read it online
  Then I should see "Part 1"
    And I should see "Part 2"
    But I should NOT see "Part 3"
    And I should see "stuff for part 1"
    And I should NOT see "stuff for part 2"
    But I should see "stuff for part 3"

Scenario: ignore empty lines in list or urls during create
  Given I am on the "Store Multiple" page
  When I fill in "page_urls" with
      """

      ##Child 1

      http://test.sidrasue.com/parts/3.html##Child 2

      """
   And I fill in "page_title" with "Parent"
   And I press "Store"
 Then I should see "Parent" within ".title"
   And I should see "Child 1" within "#position_1"
   And I should see "Child 2" within "#position_2"
   And the page should NOT contain css "#position_3"

