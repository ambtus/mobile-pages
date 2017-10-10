Feature: stuff to do with notes

  Scenario: not filling in notes shouldn't give "Notes"
    When I am on the homepage
     And I fill in "page_title" with "no notes"
     And I press "Store"
   When I go to the page with title "no notes"
   Then I should not see "Notes" within ".notes"

  Scenario: long notes should be truncated at word boundaries in lists
    Given a titled page exists with notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam."
    When I am on the page's page
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium ante malesuada pulvinar. Phasellus nullam." within ".notes"
   When I am on the homepage
     Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id turpis pretium..." within "#position_1"

  Scenario: a note without a space after 75 characters
    Given a titled page exists with notes: "On Assignment for Dumbledore, in past, Harry sees his lover from a new perspective."
    When I am on the homepage
      Then I should see "On Assignment for Dumbledore, in past, Harry sees his lover from a new perspective."

  Scenario: add notes to a page without a note
    Given a titled page exists
    When I am on the page's page
      And I follow "Notes"
      And I fill in "page_notes" with "testing notes"
      And I press "Update"
    Then I should see "testing notes" within ".notes"

  Scenario: edit notes on a page with a note
    Given a titled page exists with notes: "some basic notes"
      And I am on the page's page
    Then I should see "some basic notes" within ".notes"
    When I follow "Notes"
      And I fill in "page_notes" with "new notes"
      And I press "Update"
    Then I should see "new notes" within ".notes"
      And I should not see "some basic notes" within ".notes"

  Scenario: Find pages by notes
    Given the following pages
      | title  | notes     |
      | One    | note      |
      | Two    | noted     |
      | Three  | a note    |
      | Four   | anoted    |
      | Five   | anotate   |
      | Six    | an        |
      And I am on the homepage
     When I fill in "page_notes" with "note"
      And I press "Find"
     Then I should see "One"
       And I should see "Two"
       And I should see "Three"
       And I should see "Four"
       And I should not see "Five"
       And I should not see "Six"
     When I fill in "page_notes" with "noted"
      And I press "Find"
     Then I should not see "One"
       And I should see "Two"
       And I should not see "Three"
       And I should see "Four"
       And I should not see "Five"
       And I should not see "Six"
     When I fill in "page_notes" with "an"
      And I press "Find"
     Then I should not see "One"
       And I should not see "Two"
       And I should not see "Three"
       And I should see "Four"
       And I should see "Five"
       And I should see "Six"

  Scenario: Update notes removes old html
    Given a titled page exists with notes: "Lorem ipsum dolor"
    When I am on the page's page
     When I follow "HTML"
    Then I should see "Lorem ipsum dolor"
    When I am on the page's page
    When I follow "Notes"
      And I fill in "page_notes" with "On Assignment for Dumbledore"
      And I press "Update"
    When I am on the page's page
     When I follow "HTML"
    Then I should not see "Lorem ipsum dolor"
      And I should see "On Assignment for Dumbledore"

  Scenario: notes but no content on multi-page view
    Given a page exists with title: "Multi", base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
   When I am on the page's page
   Then I should see "Part 1" within "#position_1"
     And I should see "Part 2" within "#position_2"
     And I should not see "stuff for part 1"
     And I should not see "stuff for part 2"
     And I should not see "Original" within ".title"
     But I should see "Original" within "#position_1"
     And I should see "Original" within "#position_2"
   When I follow "HTML" within "#position_1"
   Then I should see "stuff for part 1"
     And I should not see "stuff for part 2"
   When I am on the page's page
   And I follow "Part 1"
   When I follow "Notes"
     And I fill in "page_notes" with "This is a note"
     And I press "Update"
   When I am on the page's page
   Then I should see "This is a note" within "#position_1"
     And I should not see "stuff for part 1"
     And I follow "Part 1" within "#position_1"
   Then I should see "This is a note"
     And I should not see "stuff for part 1"


