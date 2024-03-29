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

Scenario: rate a book 5 stars (best)
  Given a page exists
  When I rate it 5 stars
  Then I should see "5 stars"
    And the read after date should be 6 months from now

Scenario: stars propagate
  Given a page exists
  When I rate it 5 stars
    And I am on the page's page
    And I follow "Rate"
  Then "stars_5" should be checked

Scenario: rate a book 4 stars (better)
  Given a page exists
  When I rate it 4 stars
  Then I should see "4 stars"
    And the read after date should be 1 year from now

Scenario: rate a book 3 stars (good)
  Given a page exists
  When I rate it 3 stars
  Then I should see "3 stars"
    And the read after date should be 2 years from now

Scenario: rate a book 2 stars (bad)
  Given a page exists
  When I rate it 2 stars
  Then I should see "2 stars"
    And the read after date should be 3 years from now

 Scenario: rate a book 1 star (very bad)
  Given a page exists
  When I rate it 1 stars
  Then I should see "1 star"
    And I should NOT see "stars"
    And the read after date should be 4 years from now

