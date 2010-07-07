Feature: basic random

  Scenario: find a random page if no pages
    When I am on the homepage
    When I choose "sort_by_random"
      And I press "Find"
    Then I should see "No pages"

  Scenario: find a random page
    Given 2 titled pages exist
    When I am on the homepage
    When I choose "sort_by_random"
      And I press "Find"
    Then I should not see "No pages found"
