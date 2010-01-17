Feature: bugs with genres

  Scenario: genres with extraneous whitespace
    Given I have no filters
      And the following page
       | title | url |
       | Alice's Adventures | http://test.sidrasue.com/aa.html |
    When I am on the homepage
      And I follow "Read"
      And I follow "Genres"
      And I fill in "genres" with "  funny,  joy  joy,happy happy  "
      And I press "Add genres"
    Then I should see "funny, happy happy, joy joy" in ".genres"
