Feature: get more

  Scenario: if there are no more pages
    Given I have no pages
    And 10 pages exist
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 10" within "#position_10"
    When I press "Next"
     Then I should see "No pages found"
      And I should NOT see "Page 1"

  Scenario: get two and then three sets of pages
    Given I have no pages
    And 31 pages exist
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 10" within "#position_10"
      And I should NOT see "Page 11"
      And I should NOT see "Page 30"
      And I should NOT see "Page 31"
    When I press "Next"
     Then I should see "Page 11" within "#position_1"
      And I should see "Page 20" within "#position_10"
      And I should NOT see "Page 4"
      And I should NOT see "Page 21"
      And I should NOT see "Page 31"
    When I press "Next"
     Then I should see "Page 21" within "#position_1"
      And I should see "Page 30" within "#position_10"
      And I should NOT see "Page 1"
      And I should NOT see "Page 16"
      And I should NOT see "Page 31"
    When I press "Next"
     Then I should see "Page 31" within "#position_1"
     And the page should NOT contain css "#position_2"
      And I should NOT see "Page 1"
      And I should NOT see "Page 16"
      And I should NOT see "Page 30"
