Feature: stuff to do with notes

  Scenario: not filling in notes shouldn't give "Notes"
    When I am on the homepage
     And I fill in "page_title" with "no notes"
     And I press "Store"
   When I am on the page with title "no notes"
   Then I should NOT see "Notes" within ".notes"

  Scenario: long notes should be truncated at word boundaries in lists
   Given I have no pages
   And a page exists with notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam."
    When I am on the page's page
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam." within ".notes"
   When I am on the homepage
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam. Lorem ipsum dolor sit amet…" within "#position_1"

  Scenario: a shorter note won’t be truncated
    Given a page exists with notes: "On Assignment for Dumbledore, Harry sees his lover from a new perspective."
    When I am on the homepage
      Then I should see "On Assignment for Dumbledore, Harry sees his lover from a new perspective."

  Scenario: add notes to a page without a note
    Given a page exists
    When I am on the page's page
      And I follow "Notes"
      And I fill in "page_notes" with "testing notes"
      And I press "Update"
    Then I should see "testing notes" within ".notes"

  Scenario: edit notes on a page with a note
    Given I have no pages
    And a page exists with notes: "some basic notes"
      And I am on the page's page
    Then I should see "some basic notes" within ".notes"
    When I follow "Notes"
      And I fill in "page_notes" with "new notes"
      And I press "Update"
    Then I should see "new notes" within ".notes"
      And I should NOT see "some basic notes" within ".notes"

  Scenario: html notes should be shown as truncated text in lists
    Given I have no pages
    And a page exists with notes: "<p>This</p><p>is not</p><p>actually<p>a very long</p><p>note<br />(once you take out the <a href='http://some.domain.com'>html</a>)<br /></p>"
   When I am on the homepage
     Then I should see "This is not actually a very long note (once you take out the html)" within ".notes"
    When I am on the page's page
     Then I should NOT see "This is not" within ".notes"
     But I should see "is not"
     And "html" should link to "http://some.domain.com"

  Scenario: scrub numerous tildas to hr
    Given I have no pages
    And a page exists with notes: "<p>Sorry it took so long, I suck at romantic stuff.<br />~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~</p><p>Cheers!</p>"
    When I am on the homepage
      Then I should see "Sorry it took so long, I suck at romantic stuff. Cheers!"
      And I should NOT see "~~~"
    When I am on the page's page
      Then I should see "Sorry it took so long, I suck at romantic stuff."
      And I should NOT see "~~~"

  Scenario: very long notes are truncated in show
    Given I have no pages
    And a page with very long notes exists
    When I am on the homepage
    Then I should see "consectetur…" within ".notes"
    When I am on the page's page
    Then I should see "sit..." within ".notes"
    When I follow "full notes"
    Then I should NOT see "..."
    And I should NOT see "…"

