Feature: rate unfinished

Scenario: rate unfinished with extraneous stars
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I choose "5"
    And I press "Rate unfinished"
  Then I should see "stars ignored"
    And I should see "unfinished"
    And I should NOT see "5 stars"
    And the read after date should be 5 years from now

Scenario: rate unfinished doesn't propagate extraneous stars
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I choose "5"
    And I press "Rate unfinished"
    And I am on the page's page
    And I follow "Rate"
  Then nothing should be checked

Scenario: rate unfinished
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I press "Rate unfinished"
  Then I should NOT see "stars ignored"
    But I should see "unfinished"
    And the read after date should be 5 years from now

Scenario: rate unfinished doesn't propogate unfinished
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I press "Rate unfinished"
    And I am on the page's page
    And I follow "Rate"
  Then nothing should be checked

Scenario: check before rate unfinished
  Given 2 pages exist
  When I am on the homepage
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 2" within "#position_2"

Scenario: rate unfinished changed read after order
  Given 2 pages exist
    And I am on the homepage
  When I follow "Page 1" within "#position_1"
    And I follow "Rate"
    And I press "Rate unfinished"
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
    And I press "Rate unfinished"
  Then I should see "stars ignored"
    And I should see "unfinished"
    And I should NOT see "4 stars"
    And the read after date should be 5 years from now
