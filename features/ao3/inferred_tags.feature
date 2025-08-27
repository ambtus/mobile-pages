Feature: ao3 testing that can use local files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: default is not
  Given a page exists
  When I am on the first page's page
  Then I should NOT see "Time Travel" within ".pros"

Scenario: Single is
  Given Fuuinjutsu exists
  When I am on the first page's page
  Then I should see "Time Travel" within ".pros"

Scenario: time-travel in Single comments is NOT
  Given Where am I exists
  When I am on the first page's page
  Then I should NOT see "Time Travel" within ".pros"

Scenario: time-travel in Book comments is NOT
  Given Time Was exists
  When I am on the first page's page
  Then I should NOT see "Time Travel" within ".pros"

Scenario: default is not
  Given a page exists
  When I am on the first page's page
  Then I should NOT see "Fix-it" within ".pros"

Scenario: Single is
  Given not a chance exists
  When I am on the first page's page
  Then I should see "Fix-it" within ".pros"

Scenario: fix-it in Single comments is NOT
  Given not a chance exists
  When I am on the first page's page
  Then I should NOT see "Fix-It" within ".pros"

