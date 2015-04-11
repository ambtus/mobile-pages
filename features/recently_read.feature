Feature: recently read

  Scenario: find recently read page if no pages
    When I am on the homepage
    When I choose "sort_by_recently_read"
      And I press "Find"
    Then I should see "No pages"

  Scenario: find recently read pages
    Given the following pages
      | title  | last_read  |
      | first  | 2014-01-01 |
      | second | 2014-02-01 |
      | third  | 2014-03-01 |
    When I am on the homepage
    Then I should see "first" within "#position_1"
    When I choose "sort_by_recently_read"
      And I press "Find"
    Then I should see "third" within "#position_1"
      And I should see "second" within "#position_2"
      And I should see "first" within "#position_3"

