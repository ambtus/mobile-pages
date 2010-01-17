Feature: basic filters
  What: be able filter on a genre
  Why: sometimes I am in the mood for something specific, but not a particular page
  Result: be offered the next page of a specific genre

  Scenario: filter on a genre
    Given the following pages
      | title                            | url                                 | add_genre_string          |
      | The Mysterious Affair at Styles  | http://test.sidrasue.com/maas.html | mystery                   |
      | Grimm's Fairy Tales              | http://test.sidrasue.com/gft.html  | children, short stories   |
      | Alice's Adventures In Wonderland | http://test.sidrasue.com/aa.html   | fantasy                   |
    When I am on the homepage
    When I select "children"
      And I press "Filter"
    Then I should see "Grimm's Fairy Tales" in ".title"
    When I select "mystery"
      And I press "Filter"
    Then I should see "The Mysterious Affair at Styles" in ".title"
    When I select "fantasy"
      And I press "Filter"
    Then I should see "Alice's Adventures In Wonderland" in ".title"
    When I select "short stories"
      And I press "Filter"
    Then I should see "Grimm's Fairy Tales" in ".title"

  Scenario: continue to filter on the same genre
    Given the following pages
      | title                            | url                                 | read_after | add_genre_string|
      | The Mysterious Affair at Styles  | http://test.sidrasue.com/maas.html | 2009-01-01 | mystery         |
      | Grimm's Fairy Tales              | http://test.sidrasue.com/gft.html  | 2009-01-02 | children, great |
      | Dracula                          | http://test.sidrasue.com/drac.html | 2009-01-03 | horror          |
      | A Christmas Carol                | http://test.sidrasue.com/cc.html   | 2009-01-04 | great           |
    When I am on the homepage
    Then I should see "The Mysterious Affair at Styles" in ".title"
    When I select "great"
      And I press "Filter"
    Then "great" should be selected in "genre"
      And I should see "Grimm's Fairy Tales" in ".title"
    When I press "Read Later"
    Then I should see "A Christmas Carol"


