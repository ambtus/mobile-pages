Feature: basic stuff

Scenario: pasted html file
  Given a page exists
  When I change its raw html to "<p>This is a test</p>"
  Then I should see "Raw HTML updated" within "#flash_notice"

Scenario: pasted html file part 2
  Given a page exists
  When I change its raw html to "<p>This is a test</p>"
  Then the contents should include "This is a test"

Scenario: pasted plaintext
  Given a page exists
  When I change its raw html to "plain text"
  Then the contents should include "plain text"

Scenario: create a page from a single url
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
    And I am on the page's page
  Then "Original" should link to "http://test.sidrasue.com/test.html"

Scenario: must at least have a url or title
  Given I am on the homepage
  When I press "Store"
  Then I should have 0 pages
    And I should see "Both URL and Title can't be blank"

Scenario: create a page from a single url content
  Given I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then the contents should include "Retrieved from the web"

Scenario: pasted blank
  Given a page exists with url: "http://test.sidrasue.com/test.html"
  When I change its raw html to ""
  Then the contents should NOT include "Retrieved from the web"

Scenario: refetch original html part 1
  Given system down exists
  When I am on the page's page
  Then the contents should include "system down"

Scenario: refetch original html part 2
  Given system down exists
  When I am on the page's page
    And I follow "Refetch"
  Then the "url" field should contain "http://test.sidrasue.com/test.html"

Scenario: refetch original html part 3
  Given system down exists
   When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"

Scenario: refetch original html part 4
  Given system down exists
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then the contents should include "Retrieved from the web"
    And the contents should NOT include "system down"

Scenario: refetch original html from homepage
  Given system down exists
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"

Scenario: refetch original html from homepage
  Given system down exists
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Refetch"
  Then the contents should include "Retrieved from the web"
    And the contents should NOT include "system down"

Scenario: refetch fails
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Refetch"
  Then I should NOT see "Refetched"
    But I should see "Page not found. Find or Store instead." within "#flash_alert"
    And I should have 0 pages

Scenario: if refetch fails, can press store
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Refetch"
    And I press "Store"
  Then I should have 1 page

Scenario: if refetch fails, can press find
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Refetch"
    And I press "Find"
  Then I should see "Page not found"

Scenario: missing raw html directory
  Given a page exists with url: "http://test.sidrasue.com/test.html"
    And the page's directory is missing
  When I am on the page's page
  Then the contents should NOT include "Retrieved from the web"

Scenario: refetch when raw html directory is missing
  Given a page exists with url: "http://test.sidrasue.com/test.html"
    And the page's directory is missing
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then the contents should include "Retrieved from the web"

