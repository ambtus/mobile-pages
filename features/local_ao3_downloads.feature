Feature: ao3 testing that can use local files

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
  Then I should see "Leave Kudos or Comments on: Time Was, Time Is"
    And Leave Kudos or Comments on "Time Was, Time Is" should link to the last chapter comments
    And I should NOT see "Leave Kudos or Comments on: Where am I?"
    And I should NOT see "Leave Kudos or Comments on: Hogwarts"

Scenario: kudos link if series of singles
  Given Counting Drabbles exists
  When I read "Counting Drabbles" online
  Then I should see "Leave Kudos or Comments on: Skipping Stones"
    And I should see "Leave Kudos or Comments on: The Flower"
    But I should NOT see "Leave Kudos or Comments on: Counting Drabbles"

Scenario: kudos link if series of chaptered books
  Given Misfits existed
  When I read "Misfit Series" online
  Then I should see "Leave Kudos or Comments on: Three Misfits in New York"
    And I should see "Leave Kudos or Comments on: A Misfit Working Holiday In New York"
    But I should NOT see "Leave Kudos or Comments on: Misfit Series"
    And I should NOT see "Leave Kudos or Comments on: Chapter 1"
