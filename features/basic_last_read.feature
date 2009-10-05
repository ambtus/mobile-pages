Feature: basic last read date
  What: store and display a last read date
  Why: because i want to know :)
  Result: after rating a page, it will display a last read date

  Scenario: after rate an unread page, display it's last read date
        Given the following pages
      | title                            | url                                 |
      | Grimm's Fairy Tales              | http://sidrasue.com/tests/gft.html  |
    When I am on the homepage
    Then I should see "Grimm's Fairy Tales"
      And I should not see ".last_read"
    When I follow "Rate"
      And I press "5"
    # note - this will change every year - test will need updating
    Then I should see "2009" in ".last_read"

  Scenario: after rate a read page, change it's last read date
    Given the following pages
      | title                            | url                                 | last_read  |
      | Grimm's Fairy Tales              | http://sidrasue.com/tests/gft.html  | 2008-01-01 |
    When I am on the homepage
    Then I should see "Grimm's Fairy Tales"
      And I should see "2008-01-01" in ".last_read"
    When I follow "Rate"
      And I press "5"
    Then I should not see "2008-01-01" in ".last_read"
    # note - this will change every year - test will need updating
      And I should see "2009" in ".last_read"

