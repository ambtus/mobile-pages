Feature: filter my notes

Scenario: Find pages by my notes
  Given the following pages
    | title  | my_notes  |
    | One    | note      |
    | Two    | noted     |
    | Three  | a note    |
    | Four   | anoted    |
    | Five   | anotate   |
    | Six    | an        |
  When I am on the homepage
    And I fill in "page_my_notes" with "noted"
    And I press "Find"
  Then I should NOT see "One"
    But I should see "Two"
    And I should NOT see "Three"
    But I should see "Four"
    And I should NOT see "Five"
    And I should NOT see "Six"

Scenario: Find pages by my notes
  Given the following pages
    | title  | my_notes  |
    | One    | note      |
    | Two    | noted     |
    | Three  | a note    |
    | Four   | anoted    |
    | Five   | anotate   |
    | Six    | an        |
  When I am on the homepage
    And I fill in "page_my_notes" with "an"
    And I press "Find"
  Then I should NOT see "One"
    And I should NOT see "Two"
    And I should NOT see "Three"
    But I should see "Four"
    And I should see "Five"
    And I should see "Six"

