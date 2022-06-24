Feature: rate unfinished

Scenario: rate unfinished
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I click on "Yes" within ".stars"
    And I press "Rate"
    And I should see "unfinished"
    And I should NOT see "5 stars"
    And the read after date should be 5 years from now

Scenario: rate unfinished propagates unfinished
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I click on "Yes" within ".stars"
    And I press "Rate"
    And I am on the page's page
    And I follow "Rate"
  Then "stars_9" should be checked

Scenario: check before rate unfinished
  Given 2 pages exist
  When I am on the homepage
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 2" within "#position_2"

Scenario: rate unfinished changes read after order
  Given 2 pages exist
    And I am on the homepage
  When I follow "Page 1" within "#position_1"
    And I follow "Rate"
    And I click on "Yes" within ".stars"
    And I press "Rate"
    And I am on the homepage
  Then I should see "Page 2" within "#position_1"
    And I should see "Page 1" within "#position_2"

Scenario: check before rate previously rated as unfinished
  Given a page exists with last_read: "2009-01-01" AND stars: "4"
  When I am on the page's page
    And I follow "Rate"
    Then "stars_4" should be checked
    And the read after date should be "2010-01-01"

Scenario: rate previously rated as unfinished
  Given a page exists with last_read: "2009-01-01" AND stars: "4"
  When I am on the page's page
    And I follow "Rate"
    And I click on "Yes" within ".stars"
    And I press "Rate"
  Then I should see "unfinished"
    And I should NOT see "4 stars"
    And the read after date should be 5 years from now
