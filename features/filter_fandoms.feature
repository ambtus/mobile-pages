Feature: filtering on fandoms

Scenario: find by fandom
  Given the following pages
    | title                  | fandoms    | pros   |
    | Lord of the Rings      | fantasy    | abc123 |
    | The Hobbit             | fantasy    | lmn345 |
    | Nancy Drew             | mystery    | lmn345 |
  When I am on the filter page
    And I select "fantasy" from "fandom"
    And I press "Find"
  Then I should see "Lord of the Rings" within "#position_1"
    And I should see "The Hobbit" within "#position_2"
    But I should NOT see "Nancy Drew"

Scenario: filter on AKA
  Given the following pages
    | title                            | fandoms         |
    | The Mysterious Affair at Styles  | abc123          |
    | Grimm's Fairy Tales              | xyz987          |
    | Alice's Adventures In Wonderland | lmn345 (aka123) |
    | Through the Looking Glass        | lmn345          |
  When I am on the filter page
    And I select "aka123" from "fandom"
    And I press "Find"
  Then I should see "Alice's Adventures In Wonderland"
    And I should see "Through the Looking Glass"
    And "aka123" should be selected in "fandom"
    But I should NOT see "The Mysterious Affair at Styles"
    And I should NOT see "Grimm's Fairy Tales"
