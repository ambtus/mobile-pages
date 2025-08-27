Feature: stuff to do with my notes

Scenario: not filling in notes shouldn't give "My Notes"
  Given I am on the create single page
    And I fill in "page_title" with "Title"
  When I press "Store"
    And I am on the first page's page
  Then I should NOT see "My Notes" within ".my_notes"

Scenario: long notes should not be truncated in show
  Given a page exists with my_notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam."
  When I am on the first page's page
  Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam." within ".my_notes"

Scenario: long notes should be truncated at word boundaries in index
  Given a page exists with my_notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam."
  When I am on the homepage
  Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet…" within "#position_1"

Scenario: a shorter note won’t be truncated
  Given a page exists with my_notes: "On Assignment for Dumbledore, Harry sees his lover from a new perspective."
  When I am on the homepage
  Then I should see "On Assignment for Dumbledore, Harry sees his lover from a new perspective." within ".my_notes"

Scenario: add notes to a page without a note
  Given a page exists
  When I am on the first page's page
    And I follow "My Notes"
    And I fill in "page_my_notes" with "testing my notes"
    And I press "Update"
  Then I should see "testing my notes" within ".my_notes"

Scenario: edit notes on a page with a note part 1
  Given a page exists with my_notes: "some basic notes"
  When I am on the first page's page
  Then I should see "some basic notes" within ".my_notes"

Scenario: edit notes on a page with a note part 2
  Given a page exists with my_notes: "some basic notes"
  When I am on the first page's page
    And I follow "My Notes"
    And I fill in "page_my_notes" with "new notes"
    And I press "Update"
  Then I should see "new notes" within ".my_notes"
    But I should NOT see "some basic notes" within ".my_notes"

Scenario: notes on multi-page view (self)
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the first page's page
    And I follow "Part 1"
    And I follow "My Notes"
    And I fill in "page_my_notes" with "This is a note"
    And I press "Update"
  Then I should see "This is a note" within ".my_notes"
    And I should see "Part 1" within ".title"

Scenario: notes on multi-page view (parent)
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the first page's page
    And I follow "Part 1"
    And I follow "My Notes"
    And I fill in "page_my_notes" with "This is my note"
    And I press "Update"
    And I follow "Page 1"
  Then I should see "This is my note" within "#position_1"

Scenario: my html notes should be shown as text in index
  Given a page exists with my_notes: "<p>This.</p><p>is not.</p><p>actually.<p>a very long.</p><p>note<hr />(once you take out the <a href='http://some.domain.com'>html</a>)<br /></p>"
  When I am on the homepage
  Then I should see "This. is not. actually. a very long. note; (once you take out the html)" within "#position_1"

Scenario: my html notes should be shown as html in show
  Given a page exists with my_notes: "<p>This</p><p>is not</p><p>actually<p>a very long</p><p>note<br />(once you take out the <a href='http://some.domain.com'>html</a>)<br /></p>"
  When I am on the first page's page
  Then I should NOT see "This is not" within ".my_notes"
    But I should see "This" before "is not" within ".my_notes"
    And I should see "once you take out the html"
    And "html" should link to "http://some.domain.com"

Scenario: my html notes are html safe
  Given a page exists with my_notes: "This is fun & cute <3"
  When I am on the homepage
  Then I should see "This is fun & cute <3" within "#position_1"

Scenario: my html notes are html safe
  Given a page exists with my_notes: "This is fun & cute <3"
  When I am on the first page's page
  Then I should see "This is fun & cute <3" within ".my_notes"
