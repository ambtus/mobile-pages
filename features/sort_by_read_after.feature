Feature: read_after order

Scenario: default read order
  Given 4 pages exist
  When I am on the homepage
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 2" within "#position_2"
    And I should see "Page 3" within "#position_3"
    And I should see "Page 4" within "#position_4"

Scenario: rating a page makes its read after later
  Given 4 pages exist
  When I am on the page with title "Page 1"
    And I follow "Rate"
    And I choose "2"
    And I press "Rate"
  When I am on the homepage
    And I should see "Page 2" within "#position_1"
    And I should see "Page 3" within "#position_2"
    And I should see "Page 4" within "#position_3"
    And I should see "Page 1" within "#position_4"

Scenario: rating a page higher makes its read after sooner than a lower rating
  Given 4 pages exist
  When I am on the page with title "Page 1"
    And I follow "Rate"
    And I choose "2"
    And I press "Rate"
    And I am on the page with title "Page 2"
    And I follow "Rate"
    And I choose "4"
    And I press "Rate"
  When I am on the homepage
    Then I should see "Page 3" within "#position_1"
    And I should see "Page 4" within "#position_2"
    And I should see "Page 2" within "#position_3"
    And I should see "Page 1" within "#position_4"

 Scenario: rating a page midway makes its read after between others
  Given 4 pages exist
  When I am on the page with title "Page 1"
    And I follow "Rate"
    And I choose "2"
    And I press "Rate"
    And I am on the page with title "Page 2"
    And I follow "Rate"
    And I choose "4"
    And I press "Rate"
    And I am on the page with title "Page 3"
    And I follow "Rate"
    And I choose "3"
    And I press "Rate"
    And I am on the homepage
  Then I should see "Page 4" within "#position_1"
    And I should see "Page 2" within "#position_2"
    And I should see "Page 3" within "#position_3"
    And I should see "Page 1" within "#position_4"

