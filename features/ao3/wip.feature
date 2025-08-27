Feature: ao3 testing that can use local files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: 2/40 is a WIP
  Given wip exists
  When I am on the first page's page
  Then I should see "WIP" within ".size"

Scenario: 2/2 is not a WIP
  Given Open the Door exists
  When I am on the page with title "Open the Door"
  Then I should NOT see "WIP" within ".size"

Scenario: 2/? is a WIP
  Given Time Was exists
  When I am on the page with title "Time Was, Time Is"
  Then I should see "WIP" within ".size"

Scenario: a Single is not a WIP if it's fetched as a chapter of a WIP
  Given Where am I exists
  When I am on the page with title "Where am I?"
  Then I should NOT see "WIP" within ".size"

Scenario: a Single is a WIP if it's fetched as a work
  Given Fuuinjutsu exists
  When I am on the first page's page
  Then I should see "WIP" within ".size"

