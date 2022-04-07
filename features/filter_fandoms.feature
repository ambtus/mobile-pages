Feature: filtering on fandoms

Scenario: find by fandom
  Given the following pages
    | title                  | fandoms    | tropes   |
    | Lord of the Rings      | fantasy    | adult    |
    | The Hobbit             | fantasy    | children |
    | Nancy Drew             | mystery    | children |
  When I am on the homepage
    And I select "fantasy" from "fandom"
    And I press "Find"
  Then I should see "Lord of the Rings" within "#position_1"
    And I should see "The Hobbit" within "#position_2"
    But I should NOT see "Nancy Drew"

