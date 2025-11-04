Feature: read_after order

Scenario: default read order by creation
  Given 4 pages exist
  When I am on the pages page
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 2" within "#position_2"
    And I should see "Page 3" within "#position_3"
    And I should see "Page 4" within "#position_4"

Scenario: rating a page makes its read after later
  Given 4 pages exist
  When I rate it 5 stars
  When I am on the pages page
    And I should see "Page 2" within "#position_1"
    And I should see "Page 3" within "#position_2"
    And I should see "Page 4" within "#position_3"
    And I should see "Page 1" within "#position_4"

Scenario: rating a page higher makes its read after sooner than a lower rating
  Given 4 pages exist
  When I rate it 3 stars
    And I am on the page with title "Page 2"
    And I follow "Rate"
    And I click on "4"
    And I press "Rate"
  When I am on the pages page
    Then I should see "Page 3" within "#position_1"
    And I should see "Page 4" within "#position_2"
    And I should see "Page 2" within "#position_3"
    And I should see "Page 1" within "#position_4"

 Scenario: rating a page midway makes its read after between others
  Given 4 pages exist
  When I rate it 3 stars
    And I am on the page with title "Page 2"
    And I follow "Rate"
    And I click on "5"
    And I press "Rate"
    And I am on the page with title "Page 3"
    And I follow "Rate"
    And I click on "4"
    And I press "Rate"
    And I am on the pages page
  Then I should see "Page 4" within "#position_1"
    And I should see "Page 2" within "#position_2"
    And I should see "Page 3" within "#position_3"
    And I should see "Page 1" within "#position_4"

Scenario: change the previous "read now" behavior
  Given 2 pages exist
    And the second had been made read first
  When I am on the pages page
    And I follow "Page 2" within "#position_1"
    And I click on "Soonest"
    And I press "Change"
    And I am on the pages page
  Then I should see "Page 2" within "#position_2"
