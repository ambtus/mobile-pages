Feature: basic random

  Scenario: find a random page if no pages
    When I am on the homepage
    When I follow "Random"
    Then I should see "No pages"

  Scenario: find a random page
    Given 2 titled pages exist
    When I am on the homepage
    When I follow "Random"
    Then I should not see "No pages found"
    Then I should see "" within ".parts"
    When I follow "Random"
