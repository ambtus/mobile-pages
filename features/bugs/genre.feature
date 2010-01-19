Feature: bugs with genres

  Scenario: genres with extraneous whitespace
    Given a titled page exists
    When I go to the page's page
      And I follow "Genres"
      And I fill in "genres" with "  funny,  joy  joy,happy happy  "
      And I press "Add genres"
    Then I should see "funny, happy happy, joy joy" in ".genres"
