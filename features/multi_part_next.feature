Feature: show only 5 parts at a time

Scenario: show parent only shows 5 parts
  Given a page exists with base_url: "https://www.fanfiction.net/s/7347955/*/Dreaming-of-Sunshine" AND url_substitutions: "1-21"
  When I am on the page's page
  Then I should see "Part 1"
    And I should see "Part 5"
    But I should NOT see "Part 6"

Scenario: first next
  Given a page exists with base_url: "https://www.fanfiction.net/s/7347955/*/Dreaming-of-Sunshine" AND url_substitutions: "1-21"
  When I am on the page's page
    And I press "Next Parts"
  Then I should see "Part 6"
    And I should see "Part 10"
    But I should NOT see "Part 11"
    And I should NOT see "Part 5"

Scenario: second next
  Given a page exists with base_url: "https://www.fanfiction.net/s/7347955/*/Dreaming-of-Sunshine" AND url_substitutions: "1-21"
  When I am on the page's page
    And I press "Next Parts"
    And I press "Next Parts"
  Then I should see "Part 11"
    And I should see "Part 15"
    But I should NOT see "Part 16"
    And I should NOT see "Part 10"

Scenario: last
  Given a page exists with base_url: "https://www.fanfiction.net/s/7347955/*/Dreaming-of-Sunshine" AND url_substitutions: "1-21"
  When I am on the page's page
    And I press "Last Parts"
  Then I should see "Part 21"
    And I should see "Part 17"
    But I should NOT see "Part 16"

Scenario: previous
  Given a page exists with base_url: "https://www.fanfiction.net/s/7347955/*/Dreaming-of-Sunshine" AND url_substitutions: "1-21"
  When I am on the page's page
    And I press "Last Parts"
    And I press "Previous Parts"
  Then I should see "Part 16"
    And I should see "Part 12"
    But I should NOT see "Part 11"
    And I should NOT see "Part 17"

Scenario: previous
  Given a page exists with base_url: "https://www.fanfiction.net/s/7347955/*/Dreaming-of-Sunshine" AND url_substitutions: "1-21"
  When I am on the page's page
    And I press "Middle Parts"
  Then I should see "Part 11"
    And I should see "Part 15"
    But I should NOT see "Part 10"
    And I should NOT see "Part 16"

Scenario: previous
  Given a long partially read page exists
  When I am on the page's page
    And I press "Next Unread Part"
  Then I should see "Part 11"
    And I should see "Part 15"
    But I should NOT see "Part 10"
    And I should NOT see "Part 16"

Scenario: refetch shows last
  Given a page exists with base_url: "https://www.fanfiction.net/s/7347955/*/Dreaming-of-Sunshine" AND url_substitutions: "1-21"
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
  Then I should see "Part 21"
    And I should see "Part 17"
    But I should NOT see "Part 16"

Scenario: first
  Given a page exists with base_url: "https://www.fanfiction.net/s/7347955/*/Dreaming-of-Sunshine" AND url_substitutions: "1-21"
  When I am on the page's page
    And I follow "Refetch"
    And I press "Refetch"
    And I press "First Parts"
  Then I should see "Part 1"
    And I should see "Part 5"
    But I should NOT see "Part 6"

