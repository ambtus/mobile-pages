Feature: basic genres
  What: be able to add a genre to a page
  Why: so I will be able to filter on it later
  Result: see what filter has been applied to a page

  Scenario: add a genre to a page when there are no genres
    Given a titled page exists
    When I am on the page's page
      And I follow "Genres"
    When I fill in "genres" with "classic, children's"
      And I press "Add genres"
    Then I should see "classic" in ".genres"
      And I should see "children's" in ".genres"
    When I am on the homepage
    Then I select "classic"
    Then I select "children's"

  Scenario: select a genre for a page when there are genres
    Given a genre exists with name: "fantasy"
    And a titled page exists
    When I am on the page's page
    When I follow "Genres"
      And I select "fantasy"
      And I press "Update genres"
    Then I should see "fantasy" in ".genres"

  Scenario: add a genre to a page which has genres
    Given a titled page exists with add_genre_string: "classic"
    When I am on the page's page
    Then I should see "classic" in ".genres"
    When I follow "Genres"
      And I follow "Add Genres"
      And I fill in "genres" with "favorite, children's"
      And I press "Add genres"
    Then I should see "children's, classic, favorite" in ".genres"
    When I am on the homepage
    Then I select "classic"
      And I select "favorite"
      And I select "children's"
