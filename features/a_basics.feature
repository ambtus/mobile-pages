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

Scenario: pasted blank
  Given a page exists with url: "http://test.sidrasue.com/test.html"
  When I change its raw html to ""
  Then the contents should NOT include "Retrieved from the web"

Scenario: refetch original html part 1
  Given system down exists
  When I am on the first page's page
  Then the contents should include "system down"

Scenario: refetch original html part 2
  Given system down exists
  When I am on the first page's page
    And I follow "Refetch"
  Then the "url" field should contain "http://test.sidrasue.com/test.html"

Scenario: refetch original html part 3
  Given system down exists
   When I am on the first page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Refetched" within "#flash_notice"

Scenario: refetch original html part 4
  Given system down exists
  When I am on the first page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then the contents should include "Retrieved from the web"
    And the contents should NOT include "system down"

Scenario: missing raw html directory
  Given a page exists with url: "http://test.sidrasue.com/test.html"
    And the page's directory is missing
  When I am on the first page's page
  Then the contents should NOT include "Retrieved from the web"

Scenario: refetch when raw html directory is missing
  Given a page exists with url: "http://test.sidrasue.com/test.html"
    And the page's directory is missing
  When I am on the first page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then the contents should include "Retrieved from the web"

