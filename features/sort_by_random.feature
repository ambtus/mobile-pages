Feature: random page

  Scenario: can't find a random page if no pages
    When I am on the homepage
    When I choose "sort_by_random"
      And I press "Find"
    Then I should see "No pages"

  Scenario: find a random page
    Given a page exists
    When I am on the homepage
    When I choose "sort_by_random"
      And I press "Find"
    Then I should NOT see "No pages found"

  Scenario: don’t find unread random pages
    Given a page exists
    When I am on the homepage
    And I choose "unread_none"
    When I choose "sort_by_random"
      And I press "Find"
    Then I should see "No pages found"

  Scenario: do find unread random pages if requested
    Given a page exists
    When I am on the homepage
    When I choose "sort_by_random"
      And I choose "unread_all"
      And I press "Find"
    Then I should NOT see "No pages found"

  Scenario: don’t find unfinished random pages
    Given a page exists with stars: "9"
    When I am on the homepage
    When I choose "sort_by_random"
    And I choose "stars_better"
      And I press "Find"
    Then I should see "No pages found"

  Scenario: do find unfinished random pages if requested
    Given a page exists with stars: "9"
    When I am on the homepage
    When I choose "sort_by_random"
      And I choose "stars_unfinished"
      And I press "Find"
    Then I should NOT see "No pages found"
