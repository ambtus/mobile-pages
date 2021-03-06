Feature: filter my notes

  Scenario: Find pages by notes
    Given the following pages
      | title  | my_notes  |
      | One    | note      |
      | Two    | noted     |
      | Three  | a note    |
      | Four   | anoted    |
      | Five   | anotate   |
      | Six    | an        |
      And I am on the homepage
     When I fill in "page_my_notes" with "note"
      And I press "Find"
     Then I should see "One"
       And I should see "Two"
       And I should see "Three"
       And I should see "Four"
       And I should NOT see "Five"
       And I should NOT see "Six"
     When I fill in "page_my_notes" with "noted"
      And I press "Find"
     Then I should NOT see "One"
       And I should see "Two"
       And I should NOT see "Three"
       And I should see "Four"
       And I should NOT see "Five"
       And I should NOT see "Six"
     When I fill in "page_my_notes" with "an"
      And I press "Find"
     Then I should NOT see "One"
       And I should NOT see "Two"
       And I should NOT see "Three"
       And I should see "Four"
       And I should see "Five"
       And I should see "Six"

