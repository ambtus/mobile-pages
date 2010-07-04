Feature: basic authors

  Scenario: filter on an author
    Given the following pages
      | title                            | add_author_string |
      | The Mysterious Affair at Styles  | agatha christie   |
      | Grimm's Fairy Tales              | grimm             |
      | Alice's Adventures In Wonderland | lewis carroll, charles dodgson |
    When I am on the homepage
    When I select "grimm" from "Author"
      And I press "Find"
    Then I should see "Grimm's Fairy Tales" within "#position_1"
      And "grimm" should be selected in "author"
    When I select "charles dodgson" from "Author"
      And I press "Find"
    Then I should see "Alice's Adventures In Wonderland"
      And "charles dodgson" should be selected in "author"
    When I select "agatha christie" from "Author"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles" within "#position_1"
      And "agatha christie" should be selected in "author"
    When I select "lewis carroll" from "Author"
      And I press "Find"
    Then I should see "Alice's Adventures In Wonderland" within "#position_1"
      And "lewis carroll" should be selected in "author"

  Scenario: add authors to a page when there are no authors
    Given a page exists with title: "Alice"
      And I am on the page's page
    When I follow "Authors"
      And I fill in "authors" with "lewis carroll, charles dodgson"
      And I press "Add Authors"
    Then I should see "lewis carroll" within ".authors"
      And I should see "charles dodgson" within ".authors"
    When I am on the homepage
      And I select "charles dodgson" from "Author"
      And I select "lewis carroll" from "Author"

  Scenario: add an author for a page when there are authors
    Given a page exists with title: "Alice"
      And an author exists with name: "lewis carroll"
    When I am on the page's page
    Then I should not see "lewis carroll" within ".authors"
    When I follow "Authors"
      And I select "lewis carroll" from "page_author_ids_"
      And I press "Update Authors"
    Then I should see "lewis carroll" within ".authors"

  Scenario: add an author to a page which has authors
    Given a page exists with title: "Alice", add_author_string: "lewis carroll"
    When I am on the page's page
    Then I should see "lewis carroll" within ".authors"
    When I follow "Authors"
      And I follow "Add Authors"
      And I fill in "authors" with "charles dodgson"
      And I press "Add Authors"
    Then I should see "lewis carroll" within ".authors"
      And I should see "charles dodgson" within ".authors"
    When I am on the homepage
    Then I select "charles dodgson" from "Author"
