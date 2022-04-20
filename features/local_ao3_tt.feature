Feature: ao3 testing that can use local files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: default is not
  Given a page exists
  When I am on the page's page
  Then I should NOT see "Time Travel" within ".pros"

Scenario: Single is
  Given Fuuinjutsu exists
  When I am on the page's page
  Then I should see "Time Travel" within ".pros"

Scenario: But can be toggled off
  Given Fuuinjutsu exists
  When I am on the page's page
    And I press "Toggle Time Travel"
  Then I should NOT see "Time Travel" within ".pros"

Scenario: time-travel in Single comments is NOT
  Given Where am I exists
  When I am on the page's page
  Then I should NOT see "Time Travel" within ".pros"

Scenario: But can be toggled on
  Given Where am I exists
  When I am on the page's page
    And I press "Toggle Time Travel"
  Then I should see "Time Travel" within ".pros"

Scenario: time-travel in Book comments is NOT
  Given Time Was exists
  When I am on the page's page
  Then I should NOT see "Time Travel" within ".pros"

Scenario: But can be toggled on
  Given Time Was exists
  When I am on the page's page
    And I press "Toggle Time Travel"
  Then I should see "Time Travel" within ".pros"

Scenario: and off again
  Given Time Was exists
  When I am on the page's page
    And I press "Toggle Time Travel"
    And I press "Toggle Time Travel"
  Then I should NOT see "Time Travel" within ".pros"
