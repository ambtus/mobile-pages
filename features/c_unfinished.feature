Feature: rate unfinished

  Scenario: Read a page and rate it unfinished
    Given I have no pages
    And 2 pages exist
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 2" within "#position_2"
    When I follow "Page 1" within "#position_1"
    When I follow "Rate"
      And I choose "5"
    And I press "Rate unfinished"
    When I am on the homepage
    Then I should see "Page 2" within "#position_1"
      And I should see "Page 1" within "#position_2"
    When I follow "Page 1" within "#position_2"
      Then I should see "unfinished" within ".stars"

