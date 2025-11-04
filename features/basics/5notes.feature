Feature: add some notes

Scenario: not filling in notes removes placeholder
  Given I am on the create single page
    And I fill in "page_title" with "Title"
  When I press "Store"
    And I am on the first page's page
  Then I should NOT see "Notes" within ".notes"

Scenario: add notes to a page without a note
  Given a page exists
  When I am on the first page's page
    And I follow "Notes"
    And I fill in "page_notes" with "testing notes"
    And I press "Update"
  Then I should see "testing notes" within ".notes"

Scenario: short notes
  Given a page exists with notes: "some basic notes"
  When I am on the first page's page
  Then I should see "some basic notes" within ".notes"

Scenario: edit notes
  Given a page exists with notes: "some basic notes"
  When I am on the first page's page
    And I follow "Notes"
    And I fill in "page_notes" with "new notes"
    And I press "Update"
  Then I should see "new notes" within ".notes"
    But I should NOT see "some basic notes" within ".notes"

Scenario: html notes should be shown as text in index
  Given a page exists with notes: "<p>This.</p><p>is not.</p><p>actually.<p>a very long.</p><p>note<hr />(once you take out the <a href='http://some.domain.com'>html</a>)<br /></p>"
  When I am on the pages page
  Then I should see "This. is not. actually. a very long. note; (once you take out the html)" within "#position_1"

Scenario: html notes should be shown as html in show
  Given a page exists with notes: "<p>This</p><p>is not</p><p>actually<p>a very long</p><p>note<br />(once you take out the <a href='http://some.domain.com'>html</a>)<br /></p>"
  When I am on the first page's page
  Then I should NOT see "This is not" within ".notes"
    But I should see "This" before "is not" within ".notes"
    And I should see "once you take out the html"
    And "html" should link to "http://some.domain.com"

Scenario: html notes are html safe in index
  Given a page exists with notes: "This is fun & cute <3"
  When I am on the pages page
  Then I should see "This is fun & cute <3" within "#position_1"

Scenario: html notes are html safe in show
  Given a page exists with notes: "This is fun & cute <3"
  When I am on the first page's page
  Then I should see "This is fun & cute <3" within ".notes"

Scenario: very long notes are truncated in index
  Given a page with very long notes exists
  When I am on the pages page
  Then I should see "amet…" within ".notes"

Scenario: very long notes are truncated in show
  Given a page with very long notes exists
  When I am on the pages page
  Then I should see "amet…" within ".notes"

Scenario: very long notes are not truncated in note's view
  Given a page with very long notes exists
  When I am on the first page's page
    And I follow "full notes"
  Then I should NOT see "..."
    And I should NOT see "…"
    But I should see "amet"

