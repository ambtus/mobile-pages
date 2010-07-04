Feature: basic genres
  What: be able to add a genre to a page
  Why: so I will be able to filter on it later
  Result: see what filter has been applied to a page

  Scenario: add a genre to a page when there are no genres
    Given a titled page exists
    When I am on the page's page
      And I follow "Genres"
    When I fill in "genres" with "classic, children's"
      And I press "Add Genres"
    Then I should see "classic" within ".genres"
      And I should see "children's" within ".genres"
    When I am on the homepage
    Then I select "classic" from "Genre"
    Then I select "children's" from "Genre"

  Scenario: select a genre for a page when there are genres
    Given a genre exists with name: "fantasy"
    And a titled page exists
    When I am on the page's page
    When I follow "Genres"
      And I select "fantasy" from "page_genre_ids_"
      And I press "Update Genres"
    Then I should see "fantasy" within ".genres"

  Scenario: add a genre to a page which has genres
    Given a titled page exists with add_genre_string: "classic"
    When I am on the page's page
    Then I should see "classic" within ".genres"
    When I follow "Genres"
      And I follow "Add Genres"
      And I fill in "genres" with "something, children's"
      And I press "Add Genres"
    Then I should see "children's, classic, something" within ".genres"
    When I am on the homepage
    Then I select "classic" from "Genre"
      And I select "something" from "Genre"
      And I select "children's" from "Genre"
