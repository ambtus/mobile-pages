Feature: refetch raw

Scenario: refetch shows existing url
  Given system down exists
  When I am on the first page's page
    And I follow "Refetch"
  Then the "url" field should contain "http://test.sidrasue.com/test.html"

Scenario: add url after
  Given a page exists with title: "test me"
  When I refetch it with url: 'http://test.sidrasue.com/test.html'
  Then my page with title: 'test me' should have url: 'http://test.sidrasue.com/test.html'

Scenario: refetch notice
  Given system down exists
  When I refetch it
  Then I should see "Refetched" within "#flash_notice"

Scenario: refetch original html check baseline
  Given system down exists
  When I am on the first page's page
  Then raw should include "system down"

Scenario: refetch original changes raw
  Given system down exists
  When I refetch it
  Then raw should include "Retrieved from the web"
    And raw should NOT include "system down"

Scenario: refetch when raw html directory is missing
  Given a page exists with url: "http://test.sidrasue.com/test.html"
    And the page's directory is missing
  When I refetch it
  Then raw should include "Retrieved from the web"
