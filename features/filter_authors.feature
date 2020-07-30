Feature: filter on author

  Scenario: filter on author
    Given the following pages
      | title                            | add_author_string |
      | The Mysterious Affair at Styles  | agatha christie   |
      | Grimm's Fairy Tales              | grimm             |
      | Alice's Adventures In Wonderland | lewis carroll, charles dodgson |
      | Through the Looking Glass | lewis carroll |
    When I am on the homepage
    When I select "grimm" from "Author"
      And I press "Find"
    Then I should see "Grimm's Fairy Tales" within "#position_1"
      And "grimm" should be selected in "author"
    When I select "charles dodgson" from "Author"
      And I press "Find"
    Then I should see "Alice's Adventures In Wonderland" within "#position_1"
      And "charles dodgson" should be selected in "author"
    When I select "agatha christie" from "Author"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles" within "#position_1"
      And "agatha christie" should be selected in "author"
    When I select "lewis carroll" from "Author"
      And I press "Find"
    Then I should see "Alice's Adventures In Wonderland" within "#position_1"
      And "lewis carroll" should be selected in "author"
    When I follow "Alice's Adventures In Wonderland"
      And I follow "lewis carroll"
      Then I should see "Alice's Adventures In Wonderland" within "#position_1"
      And I should see "Through the Looking Glass" within "#position_2"
      But I should NOT see "The Mysterious Affair at Styles"
      And I should NOT see "Grimm's Fairy Tales"

  Scenario: filter on author with AKA
    Given the following pages
      | title                            | add_author_string |
      | Alice's Adventures In Wonderland | lewis carroll (charles dodgson) |
      | Through the Looking Glass | lewis carroll |
      | The Mysterious Affair at Styles  | agatha christie   |
    When I am on the homepage
      And I select "lewis carroll" from "Author"
      And I press "Find"
    Then I should see "Alice's Adventures In Wonderland" within "#position_1"
      And "lewis carroll" should be selected in "author"
    When I am on the homepage
      And I select "charles dodgson" from "Author"
      And I press "Find"
    Then I should see "Alice's Adventures In Wonderland" within "#position_1"
    When I follow "Alice's Adventures In Wonderland"
      And I follow "lewis carroll"
      Then I should see "Alice's Adventures In Wonderland" within "#position_1"
      And I should see "Through the Looking Glass" within "#position_2"
      But I should NOT see "The Mysterious Affair at Styles"
      And I should NOT see "Grimm's Fairy Tales"
