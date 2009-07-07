Feature: basic authors

  Scenario: filter on an author
    Given I have no pages
    And the following pages
      | title                            | url                                   | read_after | add_author_string            |
      | The Mysterious Affair at Styles  | http://www.rawbw.com/~alice/maas.html | 2009-01-01 | agatha christie          |
      | Grimm's Fairy Tales              | http://www.rawbw.com/~alice/gft.html  | 2009-01-02 | grimm     |
      | Alice's Adventures In Wonderland | http://www.rawbw.com/~alice/aa.html   | 2009-01-03 | lewis carroll, charles dodgson |
      And I am on the homepage
    Then I should see "The Mysterious Affair at Styles"
    When I select "agatha christie"
      And I press "Filter"
    Then "agatha christie" should be selected in "author"
      And I should see "The Mysterious Affair at Styles" in ".title"
    When I select "grimm"
      And I press "Filter"
    Then "grimm" should be selected in "author"
      And I should see "Grimm's Fairy Tales" in ".title"
    When I select "lewis carroll"
      And I press "Filter"
    Then I should see "Alice's Adventures In Wonderland"
    When I select "charles dodgson"
      And I press "Filter"
    Then I should see "Alice's Adventures In Wonderland"

  Scenario: add an author to a page when there are no authors
    Given I have no pages
    And the following page
     | title | url |
     | Alice's Adventures | http://www.rawbw.com/~alice/aa.html |
    And I have no filters
      And I am on the homepage
      And I follow "Authors"
    When I fill in "authors" with "lewis carroll, charles dodgson"
      And I press "Add authors"
    Then I should see "lewis carroll" in ".authors"
      And I should see "charles dodgson" in ".authors"
    Given I am on the homepage
    Then I should see "lewis carroll" in ".authors"

  Scenario: add an author for a page when there are authors
    Given I have no pages
    And the following pages
      | title | url | read_after | add_author_string |
      | Through the Looking Glass    | http://www.rawbw.com/~alice/test.html     | 2009-01-02 |               |
      | Alice's Adventures In Wonderland | http://www.rawbw.com/~alice/aa.html   | 2009-01-03 | lewis carroll |
      And I am on the homepage
    Then I should see "Through the Looking Glass"
    When I follow "Authors"
      And I select "lewis carroll"
      And I press "Update authors"
    Then I should see "Through the Looking Glass"
      And I should see "lewis carroll" in ".authors"

  Scenario: add an author to a page which has authors
    Given I have no pages
    And the following page
      | title                            | url                                   | add_author_string |
      | Alice's Adventures In Wonderland | http://www.rawbw.com/~alice/aa.html   | lewis carroll    |
      And I am on the homepage
    Then I should see "Alice's Adventures In Wonderland"
      And I should see "lewis carroll" in ".authors"
    When I follow "Authors"
      And I follow "Add Authors"
      And I fill in "authors" with "charles dodgson"
      And I press "Add authors"
      And I should see "Alice's Adventures In Wonderland"
    Then I should see "lewis carroll" in ".authors"
      And I should see "charles dodgson" in ".authors"
