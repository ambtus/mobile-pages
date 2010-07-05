Feature: quick test of devise integration

  Scenario: test must log in
    Given I am not authenticated
    When I go to the homepage
    Then I should see "You need to sign in or sign up before continuing."
      And I should see "Email"
      And I should not see "Unread"
    Given I am an authenticated user
    When I go to the homepage
    Then I should not see "You need to sign in or sign up before continuing."
      And I should see "Unread"
      And I should not see "Email"
