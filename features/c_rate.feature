Feature: composite rating made up of sweet and interesting.

  Scenario: new rating page
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
    Then I should see "very interesting"
      And I should see "interesting"
      And I should see "boring"
    Then I should see "very sweet"
      And I should see "sweet"
      And I should see "stressful"

  Scenario: error if don't select both before rating
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
    And I press "Rate"
    Then I should see "You must select both ratings"

  Scenario: rate unfinished
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "stressful"
      And I choose "boring"
    And I press "Rate unfinished"
    Then I should NOT see "set for reading again"
      And I should see "set to 'unfinished'"
    When I am on the page's page
    Then I should see "boring, stressful, unfinished"

  Scenario: rate a book 0 best
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 6 months"
    When I am on the page's page
    Then I should see "favorite, interesting, sweet"

  Scenario: rate a book 1 very sweet
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "interesting enough"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 1 years"
    When I am on the page's page
    Then I should see "favorite, sweet"

  Scenario: rate a book 1 very interesting
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "sweet enough"
    And I press "Rate"
    Then I should see "set for reading again in 1 years"
    When I am on the page's page
    Then I should see "favorite, interesting"

  Scenario: rate a book 2
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "sweet enough"
      And I choose "interesting enough"
    And I press "Rate"
    Then I should see "set for reading again in 2 years"
    When I am on the page's page
    Then I should see "good"

  Scenario: rate a book 2 stressful but very interesting
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "set for reading again in 2 years"
    When I am on the page's page
    Then I should see "good, interesting, stressful"

  Scenario: rate a book 2 boring but very sweet
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "boring"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 2 years"
    When I am on the page's page
    Then I should see "boring, good, sweet"

  Scenario: rate a book 3 boring
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "boring"
      And I choose "sweet enough"
    And I press "Rate"
    Then I should see "set for reading again in 3 years"
    When I am on the page's page
    Then I should see "boring"

  Scenario: rate a book 3 stressful
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "interesting enough"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "set for reading again in 3 years"
    Then I should see "stressful"

  Scenario: rate a book 4 worst
    Given a page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "boring"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "set for reading again in 4 years"
    When I am on the page's page
    Then I should see "boring, stressful"

  Scenario: rate part
    Given the following pages
      | title  | base_url                              | url_substitutions |
      | Parent | http://test.sidrasue.com/parts/*.html | 1 2 |
    When I am on the homepage
      And I follow "Parent"
      And I follow "Part 1"
      And I follow "Rate"
      And I choose "very interesting"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "Part 1 set for reading again in 6 months"
    When I follow "Parent"
      And I follow "Part 2"
      And I follow "Rate"
      And I choose "stressful"
      And I choose "boring"
    And I press "Rate"
    Then I should see "Part 2 set for reading again in 4 years"
