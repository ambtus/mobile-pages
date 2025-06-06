Feature: url stuff

Scenario: switch title for url by mistake
  Given I am on the create page
  When I fill in "page_url" with "Title of the Fic"
    And I fill in "page_title" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should see "Url is invalid" within "#flash_alert"
    And I should have 0 pages

Scenario: url can't be resolved should throw error
  Given I am on the create page
  When I fill in "page_title" with "bad url"
    And I fill in "page_url" with "http://w.sidrasue.com/tests/test.html"
    And I press "Store"
  Then I should see "couldn't resolve host name" within "#flash_alert"
    But I should NOT see "Base"
    And I should NOT see "Page created"
    And I should have 0 pages

Scenario: url with surrounding whitespace okay
  Given a page exists with url: " http://test.sidrasue.com/test.html "
  When I am on the page's page
  Then the contents should include "Retrieved from the web"
    And my page named 'Page 1' should have url: 'http://test.sidrasue.com/test.html'

Scenario: duplicate url not saved
  Given a page exists with title: "Original" AND url: "http://test.sidrasue.com/test.html"
  When I am on the create page
    And I fill in "page_title" with "duplicate"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
  Then I should see "Url has already been taken" within "#flash_alert"
    And I should NOT see "duplicate"

Scenario: duplicate url doesn't affect original
  Given a page exists with title: "Original" AND url: "http://test.sidrasue.com/test.html"
  When I am on the create page
    And I fill in "page_title" with "duplicate"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I press "Store"
    And I press "Find"
  Then I should see "Original (Single)" within ".title"

Scenario: 404 not found should display error
  Given I am on the create page
  When I fill in "page_title" with "bad url"
    And I fill in "page_url" with "http://test.sidrasue.com/style.html"
    And I press "Store"
  Then I should see "error retrieving content" within "#flash_alert"
    And I should NOT see "Page created"
    And I should have 0 pages

Scenario: ao3 user should display error
  Given I am on the mini page
  When I fill in "page_url" with "https://archiveofourown.org/users/Sidra"
    And I press "Store"
  Then I should see "Url cannot be ao3 user"
    And I should have 0 pages

Scenario: ao3 user should display error
  Given I am on the mini page
  When I fill in "page_url" with "https://archiveofourown.org/collections/Heliocentrism"
    And I press "Store"
  Then I should see "Url cannot be an ao3 collection"
    And I should have 0 pages

Scenario: add url after
  Given a page exists with title: "test me"
  When I am on the page's page
    And I follow "Refetch"
    And I fill in "url" with "http://test.sidrasue.com/test.html"
    And I press "Refetch"
  Then I should see "test me (Single)"
    And the contents should include "Retrieved from the web"

Scenario: remove #workskin
  When I am on the mini page
  When I fill in "page_url" with "https://archiveofourown.org/works/35366320/chapters/88150261#workskin"
    And I press "Store"
  Then I should have 1 page
    And my page named "temp" should have url: "https://archiveofourown.org/works/35366320/chapters/88150261"
