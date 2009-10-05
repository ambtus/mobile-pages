Feature: basic genres
  What: be able to add a genre to a page
  Why: so I will be able to filter on it later
  Result: see what filter has been applied to a page

  Scenario: add a genre to a page when there are no genres
    Given I have no filters
      And the following page
     | title | url |
     | Alice's Adventures | http://sidrasue.com/tests/aa.html |
    When I am on the homepage
      And I follow "Genres"
    When I fill in "genres" with "classic, children's"
      And I press "Add genres"
    Then I should see "classic" in ".genres"
      And I should see "children's" in ".genres"
    When I am on the homepage
    Then I select "classic"

  Scenario: select a genre for a page when there are genres
    Given the following genres
      | name |
      | fantasy |
      And the following page
        | title | url |
        | Alice's Adventures In Wonderland | http://sidrasue.com/tests/aa.html   |
    When I am on the homepage
    When I follow "Genres"
      And I select "fantasy"
      And I press "Update genres"
    Then I should see "fantasy" in ".genres"

  Scenario: add a genre to a page which has genres
    Given the following page
      | title               | url                                | add_genre_string |
      | Grimm's Fairy Tales | http://sidrasue.com/tests/gft.html | classic          |
    When I am on the homepage
    Then I should see "Grimm's Fairy Tales"
      And I should see "classic" in ".genres"
    When I follow "Genres"
      And I follow "Add Genres"
      And I fill in "genres" with "favorite, children's"
      And I press "Add genres"
      And I should see "Grimm's Fairy Tales"
    Then I should see "children's, classic, favorite" in ".genres"
    When I am on the homepage
    Then I select "classic"
      And I select "favorite"
      And I select "children's"
