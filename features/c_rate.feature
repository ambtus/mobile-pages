Feature: ratings

Scenario: new rating page
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
  Then I should see "Stars"

Scenario: error if don't select stars before rating
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I press "Rate"
  Then I should see "You must select stars"

Scenario: rate a book 5 stars (good)
  Given a page exists
  When I rate it 5 stars
  Then I should see "5 stars"
    And the read after date should be 1 year from now

Scenario: stars propagate
  Given a page exists
  When I rate it 5 stars
    And I am on the page's page
    And I follow "Rate"
  Then "stars_5" should be checked

Scenario: rate a book 4 stars (okay)
  Given a page exists
  When I rate it 4 stars
  Then I should see "4 stars"
    And the read after date should be 2 years from now

Scenario: rate a book 3 stars (bad)
  Given a page exists
  When I rate it 3 stars
  Then I should see "3 stars"
    And the read after date should be 3 years from now
    And last read should be today

Scenario: rate a book without changing the date
  Given a page exists with stars: 2 AND last_read: "2009-01-01"
  When I am on the page's page
    And I follow "Rate"
    And I click on "3"
  And I click on "today_No"
    And I press "Rate"
  Then last read should be "2009-01-01"
    And the read after date should be "2012-01-01"

Scenario: rate a book without changing the date when it didn’t have a last_read
  Given a page exists with stars: 9 AND updated_at: "2009-01-01"
  When I am on the page's page
    And I follow "Rate"
    And I click on "3"
  And I click on "today_No"
    And I press "Rate"
  Then last read should be "2009-01-01"
    And the read after date should be "2012-01-01"

