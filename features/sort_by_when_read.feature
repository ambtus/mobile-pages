Feature: last_read (also unread)

  Scenario: find recently read page if no pages
    Given I have no pages
    When I am on the homepage
    When I choose "sort_by_last_read"
      And I press "Find"
    Then I should see "No pages"

  Scenario: find pages by when read
    Given the following pages
      | title  | last_read  |
      | first  | 2012-01-01 |
      | second | 2014-01-01 |
      | third  | 2013-01-01 |
      | fourth | 2011-01-01 |
      | fifth  |  |
    When I am on the homepage
    And I choose "sort_by_last_read"
      And I press "Find"
    Then I should see "second" within "#position_1"
      And I should see "third" within "#position_2"
      And I should see "first" within "#position_3"
      And I should see "fourth" within "#position_4"
      And I should see "fifth" within "#position_5"
    When I choose "sort_by_first_read"
      And I press "Find"
    Then I should see "fourth" within "#position_1"
      And I should see "first" within "#position_2"
      And I should see "third" within "#position_3"
      And I should see "second" within "#position_4"
      And I should NOT see "fifth"

