Feature: URL error messages

Scenario: no url or title should display error
  Given I am on the create single page
  When I press "Store"
  Then I should have 0 pages
    And I should see "Both URL and Title can't be blank" within "#flash_alert"

Scenario: switch title for url by mistake should display error
  Given I am on the create single page
  When I fill in "page_url" with "Title of the Fic"
    And I fill in "page_title" with "http://test.sidrasue.com/test.html"
    And I store the page
  Then I should have 0 pages
    And I should see "Url is invalid" within "#flash_alert"

Scenario: url can't be resolved should display error
  Given I am on the create single page
  When I fill in "page_title" with "bad url"
    And I fill in "page_url" with "http://w.sidrasue.com/tests/test.html"
    And I press "Store"
  Then I should have 0 pages
    And I should see "couldn't resolve host name" within "#flash_alert"

Scenario: duplicate url should display error
  Given a page exists with url: "http://test.sidrasue.com/test.html"
  When I am on the create single page
    And I fill in "page_title" with "duplicate"
    And I fill in "page_url" with "http://test.sidrasue.com/test.html"
    And I store the page
  Then I should have 1 page
    And I should see "Url has already been taken" within "#flash_alert"
    And my page with url: 'http://test.sidrasue.com/test.html' should have title: 'Page 1'

Scenario: 404 not found should display error
  Given I am on the create single page
  When I fill in "page_title" with "bad url"
    And I fill in "page_url" with "http://test.sidrasue.com/style.html"
    And I store the page
  Then I should have 0 pages
    And I should see "error retrieving content" within "#flash_alert"

Scenario: ao3 user should display error
  Given I am on the mini page
  When I fill in "page_url" with "https://archiveofourown.org/users/Sidra"
    And I store the page
  Then I should have 0 pages
    And I should see "Url cannot be ao3 user"

Scenario: ao3 collection should display error
  Given I am on the mini page
  When I fill in "page_url" with "https://archiveofourown.org/collections/Heliocentrism"
    And I store the page
  Then I should have 0 pages
    And I should see "Url cannot be an ao3 collection"
