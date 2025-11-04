Feature: edit scrubbed html

Scenario: pasted edited notice
  Given a page exists
  When I change its scrubbed html to '<p>bar</p>'
  Then I should see "Clean HTML updated" within "#flash_notice"

Scenario: pasted edited works
  Given a page exists
  When I change its scrubbed html to "<p>This is a test</p>"
  Then edited should include "This is a test"
