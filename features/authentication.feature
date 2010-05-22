Feature: quick test of devise integration

  Scenario: test must log in
    Given I am not authenticated
    When I go to the homepage
    Then I should not see "Home Random Last"
    Given I am an authenticated user
    When I go to the homepage
    Then I should see "Home Random Last"
