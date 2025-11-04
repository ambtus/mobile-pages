Feature: most basic actions from new (mini) page: Store, Refetch & Find

Scenario: create a page from a single url
  Given I am on the mini page
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I store the page
  Then "Original" should link to "http://test.sidrasue.com/test.html"

Scenario: must at least have a url or title
  Given I am on the mini page
  When I press "Store"
  Then I should have 0 pages
    And I should see "Both URL and Title can't be blank"

Scenario: create a page from a single url content
  Given I am on the mini page
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I store the page
  Then the contents should include "Retrieved from the web"

Scenario: refetch original html from homepage
  Given system down exists
  When I refetch it from mini
  Then I should see "Refetched" within "#flash_notice"

Scenario: refetch original html from homepage
  Given system down exists
  When I refetch it from mini
  Then the contents should include "Retrieved from the web"
    And the contents should NOT include "system down"

Scenario: refetch fails
  Given I am on the mini page
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Refetch"
  Then I should NOT see "Refetched"
    But I should see "Page not found. Find or Store instead." within "#flash_alert"
    And I should have 0 pages

Scenario: if refetch fails, can press store
  Given I am on the mini page
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Refetch"
    And I store the page
  Then I should have 1 page

Scenario: if refetch fails, can press find
  Given I am on the mini page
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Refetch"
    And I press "Find"
  Then I should see "Page not found"

Scenario: find page by title
  Given a test page exists
  When I am on the mini page
    And I fill in "page_url" with "Test"
    And I press "Find"
  Then I should see "Page found"
    And I should see "Test (Single)"

Scenario: find page by url
  Given a test page exists
  When I am on the mini page
    And I fill in "page_url" with "http://test.sidrasue.com/short.html"
    And I press "Find"
  Then I should see "Page found"
    And I should see "Test (Single)"

Scenario: failed to find
  When I am on the mini page
    And I fill in "page_url" with "Test"
    And I press "Find"
  Then I should see "Page not found"
    And I should be on the "pages" page
