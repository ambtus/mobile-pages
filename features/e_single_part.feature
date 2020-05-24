Feature: single-part pages

  Scenario: hinted fields
    When I am on the homepage
    Then the "page_title" field should contain "Title"
    When I fill in "page_title" with "Something"
      And I press "Find"
    Then the "page_title" field should contain "Something"
      And the "page_title" field should not contain "Title"

  Scenario: fill title in url box by mistake
    Given I am on the homepage
    When I fill in "page_url" with "Title of the Fic"
      And I press "Store"
    Then I should see "Title can't be blank"

  Scenario: fill title in url box with Title
    Given I am on the homepage
    When I fill in "page_title" with "Title"
      And I press "Store"
    Then I should see "Title can't be blank or 'Title'"

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
      And I should not see "Page created"

  Scenario: store using a pasted html file
    Given a page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
     And I follow "Edit Raw HTML"
    When I fill in "pasted" with "<p>This is a test</p>"
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
    When I follow "HTML"
      And I should see "This is a test"
      And I should not see "Retrieved from the web"

  Scenario: pasted plaintext is okay
    Given a page exists
      And I am on the page's page
    When I follow "Edit Raw HTML"
      And I fill in "pasted" with "plain text"
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
    When I follow "HTML"
      And I should see "plain text" within ".content"

  Scenario: pasted blank is okay
    Given a page exists
      And I am on the page's page
    When I follow "Edit Raw HTML"
      And I fill in "pasted" with ""
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
    When I follow "HTML"
      And I should see "" within ".content"

  Scenario: url with surrounding whitespace okay
    Given a page exists with url: " http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "HTML"
    Then I should see "Retrieved from the web"

    Scenario: duplicate url
    Given a page exists with title: "Original" AND url: "http://test.sidrasue.com/test.html"
    When I am on the homepage
      And I fill in "page_title" with "duplicate"
      And I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I press "Store"
    Then I should see "Url has already been taken" within "#flash_alert"
      And I should not see "duplicate"

  Scenario: create a page from a single url with author and notes
    Given a tag exists with name: "mytag"
    Given an author exists with name: "myauthor"
      And I am on the homepage
      And I fill in "page_url" with "http://test.sidrasue.com/test.html"
     And I fill in "page_title" with "Simple test"
     And I fill in "page_notes" with "some notes"
     And I select "mytag" from "tag"
     And I select "myauthor" from "Author"
     And I press "Store"
   Then I should see "Page created" within "#flash_notice"
     And I should see "Simple test" within ".title"
     And I should see "mytag" within ".tags"
     And I should see "some notes" within ".notes"
     And I should see "myauthor" within ".authors"
   When I follow "HTML"
     Then I should see "Retrieved from the web" within ".content"
   When I am on the page with title "Simple test"
     And "Original" should link to "http://test.sidrasue.com/test.html"

  Scenario: page not found should display error
    When I am on the homepage
      And I fill in "page_title" with "bad url"
      And I fill in "page_url" with "http://test.sidrasue.com/style.html"
      And I press "Store"
    Then I should see "error retrieving content" within "#flash_alert"
      And I should not see "Page created"

  Scenario: refetch original html
    Given a page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "Edit Raw HTML"
      And I fill in "pasted" with "system down"
      And I press "Update Raw HTML"
    When I follow "HTML"
    Then I should see "system down" within ".content"
    When I am on the page's page
    When I follow "Refetch"
    Then the "url" field should contain "http://test.sidrasue.com/test.html"
    When I press "Refetch"
    When I follow "HTML"
    Then I should see "Retrieved from the web" within ".content"
