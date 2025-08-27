Feature: stuff to do with end notes

Scenario: end notes should not be truncated in show
  Given a page exists with end_notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam."
  When I am on the first page's page
  Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam." within ".end_notes"

Scenario: end notes should be truncated at word boundaries in index
  Given a page exists with end_notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam."
  When I am on the homepage
  Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet…" within "#position_1"

Scenario: a shorter end note won’t be truncated
  Given a page exists with end_notes: "On Assignment for Dumbledore, Harry sees his lover from a new perspective."
  When I am on the homepage
  Then I should see "On Assignment for Dumbledore, Harry sees his lover from a new perspective." within ".end_notes"

Scenario: end notes on multi-page view (self)
  Given a page exists with url: "http://test.sidrasue.com/parts/1.html" AND end_notes: "This is a note"
    And a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the first page's page
  Then I should see "This is a note" within ".end_notes"

Scenario: notes on multi-page view (parent)
  Given a page exists with url: "http://test.sidrasue.com/parts/1.html" AND end_notes: "This is an end note"
    And a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2" AND title: "Parent"
  When I am on the first page's page
    And I follow "Parent"
  Then I should see "This is an end note" within "#position_1"

Scenario: html end notes should be shown as text in index
  Given a page exists with end_notes: "<p>This.</p><p>is not.</p><p>actually.<p>a very long.</p><p>note<hr />(once you take out the <a href='http://some.domain.com'>html</a>)<br /></p>"
  When I am on the homepage
  Then I should see "This. is not. actually. a very long. note; (once you take out the html)" within "#position_1"

Scenario: html end notes should be shown as html in show
  Given a page exists with end_notes: "<p>This</p><p>is not</p><p>actually<p>a very long</p><p>note<br />(once you take out the <a href='http://some.domain.com'>html</a>)<br /></p>"
  When I am on the first page's page
  Then I should NOT see "This is not" within ".end_notes"
    But I should see "This" before "is not" within ".end_notes"
    And I should see "once you take out the html"
    And "html" should link to "http://some.domain.com"

Scenario: end notes are html safe
  Given a page exists with end_notes: "This is fun & cute <3"
  When I am on the homepage
  Then I should see "This is fun & cute <3" within "#position_1"

Scenario: end notes are html safe
  Given a page exists with end_notes: "This is fun & cute <3"
  When I am on the first page's page
  Then I should see "This is fun & cute <3" within ".end_notes"

Scenario: edit end notes
  Given a page exists with end_notes: "This is fun & cute <3"
  When I am on the first page's page
    And I follow "End Notes"
    And I fill in "page_end_notes" with "new notes"
    And I press "Update"
  Then I should see "new notes" within ".end_notes"
    But I should NOT see "This is fun" within ".end_notes"
