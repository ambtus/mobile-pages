Feature: uncollect a work which is really just a collection of shorts

Scenario: uncollect should delete parent
  Given I am on the homepage
  When I follow "Store Multiple"
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
