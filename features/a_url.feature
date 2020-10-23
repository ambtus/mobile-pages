Feature: url stuff

  Scenario: switch title for url by mistake
    Given I am on the homepage
    When I fill in "page_url" with "Title of the Fic"
      And I fill in "page_title" with "http://test.sidrasue.com/test.html"
      And I press "Store"
    Then I should see "Url is invalid"

  Scenario: url can't be resolved should throw error
    When I am on the homepage
      And I fill in "page_title" with "bad url"
      And I fill in "page_url" with "http://w.sidrasue.com/tests/test.html"
      And I press "Store"
    Then I should see "couldn't resolve host name" within "#flash_alert"
      And I should NOT see "Page created"

  Scenario: url with surrounding whitespace okay
    Given I have no pages
    And a page exists with url: " http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I view the content
    Then I should see "Retrieved from the web"

    Scenario: duplicate url
    Given a page exists with title: "Original" AND url: "http://test.sidrasue.com/test.html"
    When I am on the homepage
      And I fill in "page_title" with "duplicate"
      And I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I press "Store"
    Then I should see "Url has already been taken" within "#flash_alert"
      And I should NOT see "duplicate"

  Scenario: page not found should display error
    When I am on the homepage
      And I fill in "page_title" with "bad url"
      And I fill in "page_url" with "http://test.sidrasue.com/style.html"
      And I press "Store"
    Then I should see "error retrieving content" within "#flash_alert"
      And I should NOT see "Page created"
