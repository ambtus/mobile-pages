Feature: raw html paste

Scenario: pasted raw notice
  Given a page exists
  When I change its raw html to "<p>This is a test</p>"
  Then I should see "Raw HTML updated" within "#flash_notice"

Scenario: pasted raw works
  Given a page exists
  When I change its raw html to "<p>This is a test</p>"
  Then raw should include "This is a test"

