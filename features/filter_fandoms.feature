Feature: filtering on fandoms

  Scenario: find by fandom
    Given the following pages
      | title                  | fandoms    | tags     |
      | Lord of the Rings      | fantasy    | adult    |
      | The Hobbit             | fantasy    | children |
      | Nancy Drew             | mystery    | children |
    When I am on the homepage
      And I select "fantasy" from "fandom"
      And I press "Find"
    Then I should see "Lord of the Rings" within "#position_1"
      And I should see "The Hobbit" within "#position_2"
      But I should not see "Nancy Drew"
    When I am on the homepage
      And I select "children" from "tag"
      And I press "Find"
    Then I should not see "Lord of the Rings"
      But I should see "The Hobbit" within "#position_1"
      And I should see "Nancy Drew" within "#position_2"
   When I am on the homepage
      And I select "fantasy" from "fandom"
      And I select "children" from "tag"
      And I press "Find"
    Then I should not see "Lord of the Rings"
      And I should not see "Nancy Drew"
      But I should see "The Hobbit" within "#position_1"
