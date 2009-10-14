Feature: basic authors

  Scenario: filter on an author
    Given the following pages
      | title                            | url                                 | add_author_string |
      | The Mysterious Affair at Styles  | http://sidrasue.com/tests/maas.html | agatha christie   |
      | Grimm's Fairy Tales              | http://sidrasue.com/tests/gft.html  | grimm             |
      | Alice's Adventures In Wonderland | http://sidrasue.com/tests/aa.html   | lewis carroll, charles dodgson |
    When I am on the homepage
    When I select "grimm"
      And I press "Filter"
    Then I should see "Grimm's Fairy Tales" in ".title"
      And "grimm" should be selected in "author"
    When I select "charles dodgson"
      And I press "Filter"
    Then I should see "Alice's Adventures In Wonderland"
      And "charles dodgson" should be selected in "author"
    When I select "agatha christie"
      And I press "Filter"
    Then I should see "The Mysterious Affair at Styles" in ".title"
      And "agatha christie" should be selected in "author"
    When I select "lewis carroll"
      And I press "Filter"
    Then I should see "Alice's Adventures In Wonderland"
      And "lewis carroll" should be selected in "author"

  Scenario: add authors to a page when there are no authors
    Given I have no filters
      And the following page
     | title | url |
     | Alice's Adventures | http://sidrasue.com/tests/aa.html |
    When I am on the homepage
      And I follow "Read"
      And I follow "Authors"
    When I fill in "authors" with "lewis carroll, charles dodgson"
      And I press "Add authors"
    Then I should see "lewis carroll" in ".authors"
      And I should see "charles dodgson" in ".authors"
    When I am on the homepage
    Then I select "charles dodgson"

  Scenario: add an author for a page when there are authors
    Given the following page
        | title              | url                                 |
        | Alice's Adventures | http://sidrasue.com/tests/aa.html   |
      And the following author
        | name          |
        | lewis carroll |
    When I am on the homepage
    Then I should not see "lewis carroll" in ".authors"
      But I should see "lewis carroll" in ".author"
    When I follow "Read"
      And I follow "Authors"
      And I select "lewis carroll"
      And I press "Update authors"
    Then I should see "lewis carroll" in ".authors"

  Scenario: add an author to a page which has authors
    Given the following page
        | title              | url                                 | add_author_string |
        | Alice's Adventures | http://sidrasue.com/tests/aa.html   | lewis carroll     |
    When I am on the homepage
    Then I should see "lewis carroll" in ".authors"
    When I follow "Read"
      And I follow "Authors"
      And I follow "Add Authors"
      And I fill in "authors" with "charles dodgson"
      And I press "Add authors"
      And I should see "Alice's Adventures"
    Then I should see "lewis carroll" in ".authors"
      And I should see "charles dodgson" in ".authors"
    When I am on the homepage
    Then I select "charles dodgson"
