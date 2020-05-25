Feature: stuff to do with notes

  Scenario: not filling in notes shouldn't give "Notes"
    When I am on the homepage
     And I fill in "page_title" with "no notes"
     And I press "Store"
   When I am on the page with title "no notes"
   Then I should not see "Notes" within ".notes"

  Scenario: long notes should be truncated at word boundaries in lists
    Given a page exists with notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam."
    When I am on the page's page
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam." within ".notes"
   When I am on the homepage
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium..." within "#position_1"

  Scenario: a note without a space after 75 characters
    Given a page exists with notes: "On Assignment for Dumbledore, in past, Harry sees his lover from a new perspective."
    When I am on the homepage
      Then I should see "On Assignment for Dumbledore, in past, Harry sees his lover from a new perspective."

  Scenario: add notes to a page without a note
    Given a page exists
    When I am on the page's page
      And I follow "Notes"
      And I fill in "page_notes" with "testing notes"
      And I press "Update"
    Then I should see "testing notes" within ".notes"

  Scenario: edit notes on a page with a note
    Given a page exists with notes: "some basic notes"
      And I am on the page's page
    Then I should see "some basic notes" within ".notes"
    When I follow "Notes"
      And I fill in "page_notes" with "new notes"
      And I press "Update"
    Then I should see "new notes" within ".notes"
      And I should not see "some basic notes" within ".notes"

