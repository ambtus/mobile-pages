Feature: primarily genre tests

  Scenario: strip genre whitespace
    Given a titled page exists
    When I go to the page's page
      And I follow "Genres"
      And I fill in "genres" with "  funny,  joy  joy,happy happy  "
      And I press "Add Genres"
    Then I should see "funny, happy happy, joy joy" within ".genres"

  Scenario: no genres
    Given I am on the homepage
      And I have no pages
      And I have no genres
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select genre"
    When I fill in "genres" with "my genre"
      And I press "Add Genres"
    Then I should see "my genre" within ".genres"

  Scenario: no genre selected
    Given a genre exists with name: "first"
      And I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"
    Then I should see "Please select genre"
    When I select "first" from "page_genre_ids_"
      And I press "Update Genres"
    Then I should see "first" within ".genres"

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
    Given a titled page exists with add_genres_from_string: "classic"
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

  Scenario: new parent for an existing page should have genre
    Given a titled page exists with add_genres_from_string: "genre"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" within ".title"
    And I should see "genre" within ".genres"

  Scenario: list the genres
    Given a genre exists with name: "fantasy"
      And a genre exists with name: "science fiction"
    When I am on the genres page
    Then I should see "fantasy"
      And I should see "science fiction"
    When I follow "edit"
      Then I should see "Edit genre: fantasy"

  Scenario: edit the genre name
    Given a genre exists with name: "fantasy"
    When I am on the homepage
      And I select "fantasy" from "Genre"
    When I am on the genre's edit page
    And I fill in "genre_name" with "Fantasy"
    And I press "Update"
    When I am on the homepage
      And I select "Fantasy" from "Genre"

  Scenario: delete a genre
    Given a genre exists with name: "science fiction"
      And a titled page exists with add_genres_from_string: "science fiction"
    When I am on the genre's edit page
    And I follow "Destroy"
    When I press "Yes"
    Then I should have no genres
    When I am on the homepage
      Then I should not see "science fiction"

  Scenario: merge two genres
    Given a genre exists with name: "better name"
      And a titled page exists with add_genres_from_string: "bad name"
    When I go to the edit page for "bad name"
      And I select "better name" from "merge"
      And I press "Merge"
    Then I should see "better name"
      And I should not see "bad name"
    When I am on the homepage
      Then I should see "better name" within ".genres"
      And I should not see "bad name" within ".genres"
    When I select "better name" from "Genre"
      And I press "Find"
    Then I should not see "No pages found"

  Scenario: find by genre
    Given the following pages
      | title                            | add_genres_from_string  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
      And I select "mystery" from "Genre"
      And I press "Find"
    Then I should see "The Mysterious Affair at Styles"
      And I should see "The Boxcar Children"
      But I should not see "Alice in Wonderland"

  Scenario: find by not genre
    Given the following pages
      | title                            | add_genres_from_string  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
      And I select "mystery" from "Genre"
      And I check "Not"
      And I press "Find"
    Then I should see "Alice in Wonderland"
      But I should not see "The Mysterious Affair at Styles"
      And I should not see "The Boxcar Children"

  Scenario: find by two genres
    Given the following pages
      | title                            | add_genres_from_string  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
      And I select "mystery" from "Genre"
      And I select "children" from "Genre2"
      And I press "Find"
    Then I should see "The Boxcar Children"
      But I should not see "The Mysterious Affair at Styles"
      And I should not see "Alice in Wonderland"

  Scenario: find by two genres and a not
    Given the following pages
      | title                            | add_genres_from_string  |
      | The Mysterious Affair at Styles  | mystery           |
      | Alice in Wonderland              | children          |
      | The Boxcar Children              | mystery, children |
    When I am on the homepage
      And I select "mystery" from "Genre"
      And I check "Not"
      And I select "children" from "Genre2"
      And I press "Find"
    Then I should see "Alice in Wonderland"
      And I should not see "The Mysterious Affair at Styles"
      And I should not see "The Boxcar Children"
