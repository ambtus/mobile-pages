Feature: error checking with genres

  Scenario: genres with extraneous whitespace
    Given I have no filters
      And the following page
     | title | url |
     | Alice's Adventures | http://www.rawbw.com/~alice/aa.html |
      And I am on the homepage
      And I follow "Genres"
    When I fill in "genres" with "  funny,happy happy  , joy "
      And I press "Add genres"
    Then I should see "funny" in ".genres"
      And I should not see "  funny" in ".genres"
      And I should see "happy happy" in ".genres"
      And I should not see "happy happy  " in ".genres"
      And I should see "joy" in ".genres"
      And I should not see " joy " in ".genres"
