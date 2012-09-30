Feature: log in

Scenario: authentication
  When I go to the login page
  Then I should see "Log in"
  When I fill in the following:
    | Name     | tester  |
    | Password | secret  |
  And I press "Log in"
  Then I should see "Logged in!"
  And I should be on the homepage

Scenario: bad login
  When I go to the login page
  And I fill in the following:
    | Name     | tester  |
    | Password | wrong   |
  And I press "Log in"
  Then I should see "Invalid name or password"
  And I should be on the sessions page
