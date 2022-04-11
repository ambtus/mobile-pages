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

Scenario: filter on AKA
  Given the following pages
    | title                            | fandoms |
    | The Mysterious Affair at Styles  | agatha christie   |
    | Grimm's Fairy Tales              | grimm             |
    | Alice's Adventures In Wonderland | lewis carroll (charles dodgson) |
    | Through the Looking Glass        | lewis carroll |
  When I am on the homepage
    And I select "charles dodgson" from "fandom"
    And I press "Find"
  Then I should see "Alice's Adventures In Wonderland"
    And I should see "Through the Looking Glass"
    And "charles dodgson" should be selected in "fandom"
    But I should NOT see "The Mysterious Affair at Styles"
    And I should NOT see "Grimm's Fairy Tales"
