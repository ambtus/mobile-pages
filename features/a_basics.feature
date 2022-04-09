Feature: basic stuff

Scenario: pasted html file
  Given a page exists
  When I am on the page's page
    And I follow "Edit Raw HTML"
    And I fill in "pasted" with "<p>This is a test</p>"
    And I press "Update Raw HTML"
  Then I should see "Raw HTML updated" within "#flash_notice"
  When I view the content
    And I should see "This is a test"

Scenario: pasted html file part 2
  Given a page exists
  When I am on the page's page
    And I follow "Edit Raw HTML"
    And I fill in "pasted" with "<p>This is a test</p>"
    And I press "Update Raw HTML"
    And I view the content
  Then I should see "This is a test"

Scenario: pasted plaintext
  Given a page exists
    And I am on the page's page
  When I follow "Edit Raw HTML"
    And I fill in "pasted" with "plain text"
    And I press "Update Raw HTML"
    And I view the content
  Then I should see "plain text" within ".content"

Scenario: create a page from a single url
  Given I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
    And I view the content
  Then I should see "Retrieved from the web" within ".content"

Scenario: create a page from a single url
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_title" with "Simple test"
    And I press "Store"
    And I am on the page with title "Simple test"
  Then "Original" should link to "http://test.sidrasue.com/test.html"

Scenario: create a page from a single url with author and fandom and notes
  Given "mytag" is a "Fandom"
    And "myauthor" is an author
  When I am on the homepage
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I fill in "page_notes" with "some notes"
    And I select "mytag" from "fandom"
    And I select "myauthor" from "Author"
    And I press "Store"
  Then I should see "Page created" within "#flash_notice"
    And I should see "Title" within ".title"
    And I should see "mytag" within ".fandoms"
    And I should see "some notes" within ".notes"
    And I should see "myauthor" within ".authors"

Scenario: pasted blank
  Given a page exists with url: "http://test.sidrasue.com/test.html"
    And I am on the page's page
  When I follow "Edit Raw HTML"
    And I fill in "pasted" with ""
    And I press "Update Raw HTML"
    And I view the content
  Then I should see "" within ".content"
    But I should NOT see "Retrieved from the web" within ".content"

Scenario: refetch original html part 1
  Given system down exists
  When I am on the page's page
    And I view the content
  Then I should see "system down" within ".content"

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
    And I view the content
  Then I should see "Retrieved from the web" within ".content"
    And I should NOT see "system down" within ".content"

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
    And I view the content
  Then I should see "Retrieved from the web" within ".content"
    And I should NOT see "system down" within ".content"

Scenario: refetch fails
  Given I am on the homepage
  When I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Refetch"
  Then I should NOT see "Refetched"
    But I should see "Page not found. Find or Store instead." within "#flash_alert"
    And I should have 0 pages

Scenario: missing raw html directory
  Given a page exists with url: "http://test.sidrasue.com/test.html"
    And the page's directory is missing
  When I am on the page's page
    And I view the content
  Then I should NOT see "Retrieved from the web"

Scenario: refetch when raw html directory is missing
  Given a page exists with url: "http://test.sidrasue.com/test.html"
    And the page's directory is missing
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
    And I view the content
  Then I should see "Retrieved from the web"

