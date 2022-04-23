Feature: filter on author

Scenario: filter on author
  Given the following pages
    | title                            | authors |
    | The Mysterious Affair at Styles  | agatha christie   |
    | Grimm's Fairy Tales              | grimm             |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson |
    | Through the Looking Glass        | lewis carroll |
  When I am on the filter page
    And I select "charles dodgson" from "Author"
    And I press "Find"
  Then I should see "Alice's Adventures In Wonderland" within "#position_1"
    And "charles dodgson" should be selected in "author"
    But I should NOT see "Through the Looking Glass"
    And I should NOT see "The Mysterious Affair at Styles"
    And I should NOT see "Grimm's Fairy Tales"

Scenario: find by clicking link on show page
  Given the following pages
    | title                            | authors |
    | The Mysterious Affair at Styles  | agatha christie   |
    | Grimm's Fairy Tales              | grimm             |
    | Alice's Adventures In Wonderland | lewis carroll, charles dodgson |
    | Through the Looking Glass        | lewis carroll |
  When I am on the homepage
    And I follow "Alice's Adventures In Wonderland"
    And I follow "lewis carroll"
  Then I should see "Alice's Adventures In Wonderland" within "#position_1"
    And I should see "Through the Looking Glass"
    And the page should have title "Pages tagged with lewis carroll"
    But I should NOT see "The Mysterious Affair at Styles"
    And I should NOT see "Grimm's Fairy Tales"

Scenario: two authors can share an AKA
  Given a page exists with authors: "dick (boba)" AND title: "dicks' book"
    And a page exists with authors: "jane (boba)" AND title: "jane's book"
  When I am on the tags page
  Then I should see "dick (boba)"
    And I should see "jane (boba)"
