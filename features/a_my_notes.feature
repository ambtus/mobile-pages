Feature: stuff to do with my notes

  Scenario: not filling in notes shouldn't give "My Notes"
    When I am on the homepage
     And I fill in "page_title" with "no notes"
     And I press "Store"
   When I am on the page with title "no notes"
   Then I should not see "My Notes" within ".my_notes"

  Scenario: long notes should be truncated at word boundaries in lists
    Given a page exists with my_notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam."
    When I am on the page's page
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam." within ".my_notes"
   When I am on the homepage
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium..." within "#position_1"

  Scenario: a note without a space after 75 characters
    Given a page exists with my_notes: "On Assignment for Dumbledore, in past, Harry sees his lover from a new perspective."
    When I am on the homepage
      Then I should see "On Assignment for Dumbledore, in past, Harry sees his lover from a new perspective."

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
      And I should not see "some basic notes" within ".my_notes"

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

