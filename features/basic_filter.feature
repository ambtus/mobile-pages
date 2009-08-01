Feature: basic filters
  What: be able filter on a genre
  Why: sometimes I am in the mood for something specific, but not a particular page
  Result: be offered the next page of a specific genre

  Scenario: filter on a genre
    Given the following pages
      | title                            | url                                   | read_after | add_genre_string            |
      | The Mysterious Affair at Styles  | http://sidrasue.com/tests/maas.html | 2009-01-01 | mystery, great           |
      | Grimm's Fairy Tales              | http://sidrasue.com/tests/gft.html  | 2009-01-02 | children, short stories     |
      | Alice's Adventures In Wonderland | http://sidrasue.com/tests/aa.html   | 2009-01-03 | fantasy, great, children |
      | Dracula                          | http://sidrasue.com/tests/drac.html | 2009-01-04 | horror, unread              |
      | A Christmas Carol                | http://sidrasue.com/tests/cc.html   | 2009-01-05 | holiday, great           |
      And I am on the homepage
    Then I should see "The Mysterious Affair at Styles"
    When I select "mystery"
      And I press "Filter"
    Then "mystery" should be selected in "genre"
      And I should see "The Mysterious Affair at Styles" in ".title"
    When I select "great"
      And I press "Filter"
    Then "great" should be selected in "genre"
      And I should see "The Mysterious Affair at Styles" in ".title"
    When I select "short stories"
      And I press "Filter"
    Then "short stories" should be selected in "genre"
      And I should see "Grimm's Fairy Tales" in ".title"
    When I select "children"
      And I press "Filter"
    Then I should see "Grimm's Fairy Tales"
    When I select "horror"
      And I press "Filter"
    Then I should see "Dracula"
    When I select "unread"
      And I press "Filter"
    Then I should see "Dracula"
    When I select "fantasy"
      And I press "Filter"
    Then I should see "Alice's Adventures In Wonderland"
    When I select "holiday"
      And I press "Filter"
    Then I should see "A Christmas Carol"
    When I follow "Home"
    Then I should see "The Mysterious Affair at Styles"
    When I select "great"
      And I press "Filter"
    Then I should see "The Mysterious Affair at Styles"
    When I press "Read Later"
    Then I should see "Alice's Adventures In Wonderland"
    When I press "Read Later"
    Then I should see "A Christmas Carol"
    When I press "Read Later"
    Then I should see "The Mysterious Affair at Styles"


