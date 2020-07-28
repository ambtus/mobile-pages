Feature: filtering on relationships

  Scenario: find by relationship
    Given the following pages
      | title                  | relationships    | tropes     |
      | Mirror of Maybe        | snarry           | au       |
      | A Nick in Time         | snarry           | kidfic   |
      | A Single Love          | Harry/Tom        | kidfic   |
    When I am on the homepage
      And I select "snarry" from "relationship"
      And I press "Find"
    Then I should see "Mirror of Maybe" within "#position_1"
      And I should see "A Nick in Time" within "#position_2"
      But I should NOT see "A Single Love"
    When I am on the homepage
      And I select "kidfic" from "tag"
      And I press "Find"
    Then I should NOT see "Mirror of Maybe"
      But I should see "A Nick in Time" within "#position_1"
      And I should see "A Single Love" within "#position_2"
   When I am on the homepage
      And I select "snarry" from "relationship"
      And I select "kidfic" from "tag"
      And I press "Find"
    Then I should NOT see "Mirror of Maybe"
      And I should NOT see "A Single Love"
      But I should see "A Nick in Time" within "#position_1"
