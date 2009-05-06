Feature: basic genres
  What: be able to add a genre to a page
  Why: so I will be able to filter on it later
  Result: see what filter has been applied to a page

  Scenario: add a genre to a page when there are no genres
    Given I have no filters
      And the following page
     | title | url |
     | Alice's Adventures | http://www.rawbw.com/~alice/aa.html |
      And I am on the homepage
      And I follow "Genres"
    When I fill in "genres" with "classic, children's"
      And I press "Add genres"
    Then I should see "classic" in ".genres"
      And I should see "children's" in ".genres"
    Given I am on the homepage
    Then I should see "children's" in ".genres"

  Scenario: select a genre for a page when there are genres
    Given the following pages
      | title | url | read_after | add_genre_string |
      | Grimm's Fairy Tales              | http://www.rawbw.com/~alice/gft.html  | 2009-01-02 |                             |
      | Alice's Adventures In Wonderland | http://www.rawbw.com/~alice/aa.html   | 2009-01-03 | fantasy, favorite, children's |
      And I am on the homepage
    Then I should see "Grimm's Fairy Tales"
    When I follow "Genres"
      And I select "children's"
      And I press "Update genres"
    Then I should see "Grimm's Fairy Tales"
      And I should see "children's" in ".genres"

  Scenario: add a genre to a page which has genres
    Given the following page
      | title               | url                                  | add_genre_string |
      | Grimm's Fairy Tales | http://www.rawbw.com/~alice/gft.html | children's       |
      And I am on the homepage
    Then I should see "Grimm's Fairy Tales"
      And I should see "children's" in ".genres"
    When I follow "Genres"
      And I follow "Add Genres"
      And I fill in "genres" with "classic, favorite"
      And I press "Add genres"
      And I should see "Grimm's Fairy Tales"
    Then I should see "classic" in ".genres"
      And I should see "children's" in ".genres"
      And I should see "favorite" in ".genres"
