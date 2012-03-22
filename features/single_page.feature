Feature: single-part pages

  Scenario: hinted fields
    When I go to the homepage
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
    Given a titled page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
     And I follow "Edit Raw HTML"
    When I fill in "pasted" with "<p>This is a test</p>"
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
    When I follow "HTML"
      And I should see "This is a test"
      And I should not see "Retrieved from the web"

  Scenario: pasted plaintext is okay
    Given a titled page exists
      And I am on the page's page
    When I follow "Edit Raw HTML"
      And I fill in "pasted" with "plain text"
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
    When I follow "HTML"
      And I should see "plain text" within ".content"

  Scenario: pasted blank is okay
    Given a titled page exists
      And I am on the page's page
    When I follow "Edit Raw HTML"
      And I fill in "pasted" with ""
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
    When I follow "HTML"
      And I should see "" within ".content"

  Scenario: holder page for parts is okay
    Given I am on the homepage
    When I fill in "page_title" with "Only entered Title"
      And I press "Store"
    Then I should see "Page created" within "#flash_notice"

  Scenario: url with surrounding whitespace okay
    Given a titled page exists with url: " http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "HTML"
    Then I should see "Retrieved from the web"

  Scenario: refetch original html
    Given a titled page exists with url: "http://test.sidrasue.com/test.html"
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

  Scenario: page not found should display error
    When I am on the homepage
      And I fill in "page_title" with "bad url"
      And I fill in "page_url" with "http://test.sidrasue.com/style.html"
      And I press "Store"
    Then I should see "error retrieving content" within "#flash_alert"
      And I should not see "Page created"

  Scenario: download livejournal adult content
    Given a titled page exists with url: "http://sidra.livejournal.com/3265.html"
    When I go to the page's page
      And I follow "HTML" within ".title"
    Then I should not see "Adult Content"
      And I should see "alien"
