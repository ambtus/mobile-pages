Feature: last_read

Scenario: no pages
  When I am on the homepage
    And I choose "sort_by_last_read"
    And I press "Find"
  Then I should see "No pages"

Scenario: find pages by last read
  Given the following pages
    | title  | last_read  |
    | first  | 2012-01-01 |
    | second | 2014-01-01 |
    | third  | 2013-01-01 |
    | fourth | 2011-01-01 |
    | fifth  |            |
  When I am on the homepage
    And I choose "sort_by_last_read"
    And I press "Find"
  Then I should see "second" within "#position_1"
    And I should see "third" within "#position_2"
    And I should see "first" within "#position_3"
    And I should see "fourth" within "#position_4"
    And I should see "fifth" within "#position_5"

Scenario: find pages by first read
  Given the following pages
    | title  | last_read  |
    | first  | 2012-01-01 |
    | second | 2014-01-01 |
    | third  | 2013-01-01 |
    | fourth | 2011-01-01 |
    | fifth  |            |
  When I am on the homepage
    And I choose "sort_by_first_read"
    And I press "Find"
  Then I should see "fourth" within "#position_1"
    And I should see "first" within "#position_2"
    And I should see "third" within "#position_3"
    And I should see "second" within "#position_4"
    And I should NOT see "fifth"
    And the page should NOT contain css "#position_5"

