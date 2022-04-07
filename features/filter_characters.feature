Feature: filtering on characters

Scenario: find by character
  Given the following pages
    | title                  | characters       | tropes     |
    | Mirror of Maybe        | snarry           | au       |
    | A Nick in Time         | snarry           | kidfic   |
    | A Single Love          | Harry/Tom        | kidfic   |
  When I am on the homepage
    And I select "snarry" from "character"
    And I press "Find"
  Then I should see "Mirror of Maybe" within "#position_1"
    And I should see "A Nick in Time" within "#position_2"
    But I should NOT see "A Single Love"

