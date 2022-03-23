Feature: show only 15 of multi-parts (and bugs)

  Scenario: show parent only shows 15 parts and refetching shows the last
     Given I have no pages
    Given a page exists with base_url: "https://www.fanfiction.net/s/7347955/*/Dreaming-of-Sunshine" AND url_substitutions: "1-151"
    When I am on the page's page
    Then I should see "Part 1"
    But I should NOT see "Part 16"
    When I press "Next Parts"
    Then I should see "Part 16"
    But I should NOT see "Part 31"
    When I press "Next Parts"
    Then I should see "Part 31"
    But I should NOT see "Part 46"
    When I press "Last Parts"
    Then I should see "Part 137"
    And I should see "Part 151"
    But I should NOT see "Part 136"
    When I follow "Refetch"
    And I press "Refetch"
    Then I should see "Part 137"
    And I should see "Part 151"
    But I should NOT see "Part 136"

  Scenario: show parent shows parts by position, not created order
    Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/2.html
        http://test.sidrasue.com/parts/1.html
        """
      And I press "Update"
    Then "Part 2" should come before "Part 1"

  Scenario: find by url shows parts
    Given I have no pages
      And Time Was exists
      And I am on the homepage
    When I fill in "page_url" with "https://archiveofourown.org/works/692/"
    And I press "Find"
      Then I should see "1. Where am I?" within "#position_1"
      And I should see "2. Hogwarts" within "#position_2"
