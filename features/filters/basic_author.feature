Feature: basic authors

  Scenario: filter on an author
    Given the following pages
      | title                            | add_author_string |
      | The Mysterious Affair at Styles  | agatha christie   |
      | Grimm's Fairy Tales              | grimm             |
      | Alice's Adventures In Wonderland | lewis carroll, charles dodgson |
    When I am on the homepage
    When I select "grimm"
      And I press "Find"
    Then I should see "Grimm's Fairy Tales" in "#position_1"
      And "grimm" should be selected in "author"
    When I select "charles dodgson"
      And I press "Find"
    Then I should see "Alice's Adventures In Wonderland"
      And "charles dodgson" should be selected in "author"
    When I select "agatha christie"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles" in "#position_1"
      And "agatha christie" should be selected in "author"
    When I select "lewis carroll"
      And I press "Find"
    Then I should see "Alice's Adventures In Wonderland" in "#position_1"
      And "lewis carroll" should be selected in "author"

  Scenario: add authors to a page when there are no authors
    Given a page exists with title: "Alice"
      And I am on the page's page
    When I follow "Authors"
      And I fill in "authors" with "lewis carroll, charles dodgson"
      And I press "Add authors"
    Then I should see "lewis carroll" in ".authors"
      And I should see "charles dodgson" in ".authors"
    When I am on the homepage
      And I select "charles dodgson"
      And I select "lewis carroll"

  Scenario: add an author for a page when there are authors
    Given a page exists with title: "Alice"
      And an author exists with name: "lewis carroll"
    When I am on the page's page
    Then I should not see "lewis carroll" in ".authors"
    When I follow "Authors"
      And I select "lewis carroll"
      And I press "Update authors"
    Then I should see "lewis carroll" in ".authors"

  Scenario: add an author to a page which has authors
    Given a page exists with title: "Alice", add_author_string: "lewis carroll"
    When I am on the page's page
    Then I should see "lewis carroll" in ".authors"
    When I follow "Authors"
      And I follow "Add Authors"
      And I fill in "authors" with "charles dodgson"
      And I press "Add authors"
    Then I should see "lewis carroll" in ".authors"
      And I should see "charles dodgson" in ".authors"
    When I am on the homepage
    Then I select "charles dodgson"
