Feature: basic author and genre

  Scenario: filter on an author and genre
    Given I have no pages
    And the following pages
      | title                            | url                                   | read_after | add_author_string              | add_genre_string            |
      | The Mysterious Affair at Styles  | http://www.rawbw.com/~alice/maas.html | 2009-01-01 | agatha christie                | mystery, favorite           |
      | Grimm's Fairy Tales              | http://www.rawbw.com/~alice/gft.html  | 2009-01-02 | grimm                          | children, short stories     |
      | Alice's Adventures In Wonderland | http://www.rawbw.com/~alice/aa.html   | 2009-01-03 | lewis carroll, charles dodgson | fantasy, favorite, children |
      And I am on the homepage
    Then I should see "The Mysterious Affair at Styles"
    When I select "favorite"
    And I select "agatha christie"
      And I press "Filter"
    Then I should see "The Mysterious Affair at Styles" in ".title"
    When I select "children"
    And I select "lewis carroll"
      And I press "Filter"
    Then I should see "Alice's Adventures In Wonderland"
    When I select "charles dodgson"
    And I select "favorite"
      And I press "Filter"
    Then I should see "Alice's Adventures In Wonderland"
    When I select "grimm"
    And I select "favorite"
      And I press "Filter"
    Then I should not see "Grimm's Fairy Tales"
    And I should see "No page"
    And I should see "pages filtered by grimm and favorite"
