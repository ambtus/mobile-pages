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

Scenario: filter with AKA
  Given the following pages
    | title                            | fandoms         |
    | The Mysterious Affair at Styles  | abc123          |
    | Grimm's Fairy Tales              | xyz987          |
    | Alice's Adventures In Wonderland | lmn345 (aka123) |
    | Through the Looking Glass        | lmn345          |
  When I am on the filter page
    And I select "lmn345" from "fandom"
    And I press "Find"
  Then I should see "Alice's Adventures In Wonderland"
    And I should see "Through the Looking Glass"
    But I should NOT see "The Mysterious Affair at Styles"
    And I should NOT see "Grimm's Fairy Tales"

Scenario: find by all with fandom
  Given the following pages
    | title                  | fandoms    | pros   |
    | Lord of the Rings      | fantasy    | abc123 |
    | The Hobbit             | fantasy    | lmn345 |
    | Nancy Drew             | mystery    | lmn345 |
    | Something Else         |            | abc123 |
  When I am on the filter page
    And I click on "show_fandoms_all"
    And I press "Find"
  Then I should see "Lord of the Rings" within "#position_1"
    And I should see "The Hobbit" within "#position_2"
    And I should see "Nancy Drew"
    But I should NOT see "Something Else"

Scenario: find by all without fandom
  Given the following pages
    | title                  | fandoms    | pros   |
    | Lord of the Rings      | fantasy    | abc123 |
    | The Hobbit             | fantasy    | lmn345 |
    | Nancy Drew             | mystery    | lmn345 |
    | Something Else         |            | abc123 |
    | Another Page           |            | lmn345 |
  When I am on the filter page
    And I click on "show_fandoms_none"
    And I press "Find"
  Then I should NOT see "Lord of the Rings"
    And I should NOT see "The Hobbit"
    And I should NOT see "Nancy Drew"
    But I should see "Something Else" within "#position_1"
    And I should see "Another Page" within "#position_2"

Scenario: find by all with fandom and pro
  Given the following pages
    | title                  | fandoms    | pros   |
    | Lord of the Rings      | fantasy    | abc123 |
    | The Hobbit             | fantasy    | lmn345 |
    | Nancy Drew             | mystery    | lmn345 |
    | Something Else         |            | abc123 |
  When I am on the filter page
    And I click on "show_fandoms_all"
    And I select "abc123"
    And I press "Find"
  Then I should see "Lord of the Rings" within "#position_1"
    And I should NOT see "The Hobbit"
    And I should NOT see "Nancy Drew"
    But I should NOT see "Something Else"

Scenario: find by all without fandom but with pro
  Given the following pages
    | title                  | fandoms    | pros   |
    | Lord of the Rings      | fantasy    | abc123 |
    | The Hobbit             | fantasy    | lmn345 |
    | Nancy Drew             | mystery    | lmn345 |
    | Something Else         |            | abc123 |
    | Another Page           |            | lmn345 |
  When I am on the filter page
    And I click on "show_fandoms_none"
    And I select "abc123"
    And I press "Find"
  Then I should NOT see "Lord of the Rings"
    And I should NOT see "The Hobbit"
    And I should NOT see "Nancy Drew"
    But I should see "Something Else" within "#position_1"
    And I should NOT see "Another Page"
