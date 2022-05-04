Feature: ao3 testing that can use local files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: end notes link to kudos for Single chapter
  Given Where am I exists
  When I read it online
  Then Leave Kudos or Comments on "Where am I?" should link to its comments

Scenario: end notes link to kudos for Single work
  Given Where am I existed and was read
  When I read it online
  Then Leave Kudos or Comments on "Time Was, Time Is" should link to its comments

Scenario: end notes link to kudos for Chapter of work
  Given Time Was exists
  When I read "Where am I?" online
  Then Leave Kudos or Comments on "Where am I?" should link to its comments

Scenario: end notes link to kudos for last chapter for Works
  Given Time Was exists
  When I read it online
  Then Leave Kudos or Comments on "Hogwarts" should link to its comments
    And I should NOT see "Leave Kudos or Comments on \"Where am I?\""
    And I should NOT see "Leave Kudos or Comments on \"Timw Was, Time Is\""

Scenario: hr between kudos and rating
  Given Where am I exists
  When I read it online
  Then I should see a horizontal rule
