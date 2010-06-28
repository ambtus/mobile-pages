Feature: basic last read date
  What: store and display a last read date
  Why: because i want to know :)
  Result: after rating a page, it will display a last read date

  Scenario: after rate an unread page, display it's last read date
    Given a titled page exists
    When I am on the page's page
    Then I should not see ".last_read"
    When I follow "Rate"
      And I press "5"
    # note - this will change every year - test will need updating
    Then I should see "2010" in ".last_read"

  Scenario: after rate a read page, change it's last read date
    Given a titled page exists with last_read: "2008-01-01"
    When I am on the page's page
    Then I should see "2008-01-01" in ".last_read"
    When I follow "Rate"
      And I press "5"
    Then I should not see "2008-01-01" in ".last_read"
    # note - this will change every year - test will need updating
      And I should see "2010" in ".last_read"
