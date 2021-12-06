Feature: 5 star ratings (plus unfinished which uses 9)

  Scenario: new rating page
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
    Then I should see "Stars"

  Scenario: error if don't select stars before rating
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
    And I press "Rate"
    Then I should see "You must select stars"

  Scenario: rate unfinished
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
    And I press "Rate unfinished"
    Then I should NOT see "stars ignored"
    And I follow "Page 1"
    Then I should see "unfinished"
    And the read after date should be 5 years from now
    When I follow "Rate"
    Then nothing should be checked

  Scenario: rate unfinished with extraneous stars
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
    And I choose "5"
    And I press "Rate unfinished"
    Then I should see "stars ignored"
    And I follow "Page 1"
    Then I should see "unfinished"
    And I should NOT see "5 stars"
    And the read after date should be 5 years from now
    When I follow "Rate"
    Then nothing should be checked

  Scenario: rate a book 5 stars (best)
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "5"
    And I press "Rate"
    And I follow "Page 1"
    Then I should see "5 stars"
    When I follow "Rate"
      Then "stars_5" should be checked

  Scenario: rate a book 4 stars (better)
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "4"
    And I press "Rate"
    And I follow "Page 1"
    Then I should see "4 stars"
    And the read after date should be 1 years from now
    When I follow "Rate"
      Then "stars_4" should be checked

  Scenario: rate a book 3 stars (good)
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "3"
    And I press "Rate"
    And I follow "Page 1"
    Then I should see "3 stars"
    And the read after date should be 2 years from now

  Scenario: rate a book 2 stars (bad)
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "2"
    And I press "Rate"
    And I follow "Page 1"
    Then I should see "2 stars"
    And the read after date should be 3 years from now

   Scenario: rate a book 1 star (very bad)
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "1"
    And I press "Rate"
    And I follow "Page 1"
    Then I should see "1 stars"
    And the read after date should be 4 years from now

  Scenario: rate part
    Given the following pages
      | title  | base_url                              | url_substitutions |
      | Parent | http://test.sidrasue.com/parts/*.html | 1 2 |
    Then the read after date should be 0 years from now
    When I am on the homepage
      And I follow "Parent"
      And I follow "Part 1"
      And I follow "Rate"
      And I choose "4"
    And I press "Rate"
    Then the read after date should be 0 years from now
    When I fill in "tags" with "cute, interesting"
      And I press "Add Rating Tags"
    When I follow "Parent"
      And I follow "Part 2"
      And I follow "Rate"
      And I choose "1"
    And I press "Rate"
    Then the read after date should be 1 years from now
    And I follow "Part 2"
