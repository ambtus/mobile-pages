Feature: get more

  Scenario: get another set of pages
    Given 30 titled pages exist
    When I am on the homepage
    Then I should see "page 1 title" within "#position_1"
      And I should see "page 15 title" within "#position_15"
      And I should not see "page 16 title"
      And I should not see "page 30 title"
    When I press "Next"
     Then I should see "page 16 title" within "#position_1"
      And I should see "page 30 title" within "#position_15"
      And I should not see "page 1 title"
      And I should not see "page 15 title"

  Scenario: if there are no more pages
    Given 10 titled pages exist
    When I am on the homepage
    Then I should see "page 1 title" within "#position_1"
      And I should see "page 10 title" within "#position_10"
    When I press "Next"
     Then I should see "No pages found"
      And I should not see "page 1 title"

  Scenario: get a third set of pages
    Given 31 titled pages exist
    When I am on the homepage
    Then I should see "page 1 title" within "#position_1"
      And I should not see "page 16 title"
      And I should not see "page 31 title"
    When I press "Next"
     Then I should see "page 16 title" within "#position_1"
      And I should not see "page 1 title"
      And I should not see "page 31 title"
    When I press "Next"
     Then I should see "page 31 title" within "#position_1"
      And I should not see "page 1 title"
      And I should not see "page 16 title"

