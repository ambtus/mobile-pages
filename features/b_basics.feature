Feature: basic stuff

  Scenario: store using a pasted html file
    Given a page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
     And I follow "Edit Raw HTML"
    When I fill in "pasted" with "<p>This is a test</p>"
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
    When I view the content
      And I should see "This is a test"
      And I should NOT see "Retrieved from the web"

  Scenario: pasted plaintext is okay
    Given a page exists
      And I am on the page's page
    When I follow "Edit Raw HTML"
      And I fill in "pasted" with "plain text"
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
    When I view the content
      And I should see "plain text" within ".content"

  Scenario: pasted blank is okay
    Given a page exists
      And I am on the page's page
    When I follow "Edit Raw HTML"
      And I fill in "pasted" with ""
      And I press "Update Raw HTML"
    Then I should see "Raw HTML updated" within "#flash_notice"
    When I view the content
      And I should see "" within ".content"

  Scenario: create a page from a single url with author and notes
    Given a tag exists with name: "mytag" AND type: "Fandom"
    Given an author exists with name: "myauthor"
      And I am on the homepage
      And I fill in "page_url" with "http://test.sidrasue.com/test.html"
     And I fill in "page_title" with "Simple test"
     And I fill in "page_notes" with "some notes"
     And I select "mytag" from "fandom"
     And I select "myauthor" from "Author"
     And I press "Store"
   Then I should see "Page created" within "#flash_notice"
     And I should see "Simple test" within ".title"
     And I should see "mytag" within ".fandoms"
     And I should see "some notes" within ".notes"
     And I should see "myauthor" within ".authors"
   When I view the content
     Then I should see "Retrieved from the web" within ".content"
   When I am on the page with title "Simple test"
     And "Original" should link to "http://test.sidrasue.com/test.html"

  Scenario: refetch original html
    Given a page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      Then "Original" should link to "http://test.sidrasue.com/test.html"
      And I follow "Edit Raw HTML"
      And I fill in "pasted" with "system down"
      And I press "Update Raw HTML"
    When I view the content
    Then I should see "system down" within ".content"
    When I am on the page's page
    When I follow "Refetch"
    Then the "url" field should contain "http://test.sidrasue.com/test.html"
    When I press "Refetch"
    When I view the content
    Then I should see "Retrieved from the web" within ".content"

  Scenario: refetch after moving directory
    Given a page exists with url: "http://test.sidrasue.com/test.html"
    And the page's directory is missing
    When I am on the page's page
    And I follow "Refetch"
      When I press "Refetch"
    When I view the content
    Then I should see "Retrieved from the web"
