Feature: stuff to do with my notes

  Scenario: not filling in notes shouldn't give "My Notes"
    When I am on the homepage
     And I fill in "page_title" with "no notes"
     And I press "Store"
   When I am on the page with title "no notes"
   Then I should NOT see "My Notes" within ".my_notes"

  Scenario: long notes should be truncated at word boundaries in index
    Given a page exists with my_notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam."
    When I am on the page's page
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam." within ".my_notes"
   When I am on the homepage
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet…" within "#position_1"

  Scenario: a shorter note won’t be truncated
    Given a page exists with my_notes: "On Assignment for Dumbledore, Harry sees his lover from a new perspective."
    When I am on the homepage
      Then I should see "On Assignment for Dumbledore, Harry sees his lover from a new perspective."

  Scenario: add notes to a page without a note
    Given a page exists
    When I am on the page's page
      And I follow "My Notes"
      And I fill in "page_my_notes" with "testing my notes"
      And I press "Update"
    Then I should see "testing my notes" within ".my_notes"

  Scenario: edit notes on a page with a note
    Given a page exists with my_notes: "some basic notes"
      And I am on the page's page
    Then I should see "some basic notes" within ".my_notes"
    When I follow "My Notes"
      And I fill in "page_my_notes" with "new notes"
      And I press "Update"
    Then I should see "new notes" within ".my_notes"
      And I should NOT see "some basic notes" within ".my_notes"

  Scenario: notes on multi-page view
    Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
   When I am on the page's page
   And I follow "Part 1"
   When I follow "My Notes"
     And I fill in "page_my_notes" with "This is a note"
     And I press "Update"
   When I am on the page's page
   Then I should see "This is a note" within "#position_1"
     And I follow "Part 1" within "#position_1"
   Then I should see "This is a note" within ".my_notes"

  Scenario: my html notes should be shown as truncated text in index but html in show
    Given a page exists with my_notes: "<p>This</p><p>is not</p><p>actually<p>a very long</p><p>note<br />(once you take out the <a href='http://some.domain.com'>html</a>)<br /></p>"
   When I am on the homepage
     Then I should see "This is not actually a very long note (once you take out the html)" within ".my_notes"
    When I am on the page's page
     ## This ¶ is not
     Then I should NOT see "This is not" within ".my_notes"
     But I should see "once you take out the "
     And "html" should link to "http://some.domain.com"

  Scenario: my html notes are html save
    Given a page exists with my_notes: "This is fun & cute <3"
   When I am on the homepage
     Then I should see "This is fun & cute <3" within ".my_notes"
