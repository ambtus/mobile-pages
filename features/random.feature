Feature: random page

  Scenario: find a random page if no pages
    When I am on the homepage
    When I choose "sort_by_random"
      And I press "Find"
    Then I should see "No pages"

  Scenario: don’t find unread random pages
    Given a titled page exists
    When I am on the homepage
    When I choose "sort_by_random"
      And I press "Find"
    Then I should see "No pages found"

  Scenario: do find unread random pages if requested
    Given a titled page exists
    When I am on the homepage
    When I choose "sort_by_random"
      And I choose "unread_yes"
      And I press "Find"
    Then I should not see "No pages found"

  Scenario: find a random page
    Given a titled page exists with last_read: "2008-01-01"
    When I am on the homepage
    When I choose "sort_by_random"
      And I press "Find"
    Then I should not see "No pages found"
