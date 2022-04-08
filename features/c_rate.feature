Feature: 5 star ratings

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
  When I am on the page's page
    And I follow "Rate"
    And I choose "5"
    And I press "Rate"
  Then I should see "5 stars"
    And the read after date should be 6 months from now

Scenario: stars propagate
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I choose "5"
    And I press "Rate"
    And I am on the page's page
    And I follow "Rate"
  Then "stars_5" should be checked

Scenario: rate a book 4 stars (better)
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I choose "4"
    And I press "Rate"
  Then I should see "4 stars"
    And the read after date should be 1 year from now

Scenario: rate a book 3 stars (good)
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I choose "3"
    And I press "Rate"
  Then I should see "3 stars"
    And the read after date should be 2 years from now

Scenario: rate a book 2 stars (bad)
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I choose "2"
    And I press "Rate"
  Then I should see "2 stars"
    And the read after date should be 3 years from now

 Scenario: rate a book 1 star (very bad)
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I choose "1"
    And I press "Rate"
  Then I should see "1 star"
    And I should NOT see "stars"
    And the read after date should be 4 years from now

Scenario: check before rate part
  Given a page exists with title: "Parent" AND base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-2"
  Then the read after date should be 0 years from now

Scenario: rate one part leaves parent read after unchanged
  Given a page exists with title: "Parent" AND base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-2"
  When I am on the homepage
    And I follow "Parent"
    And I follow "Part 1"
    And I follow "Rate"
    And I choose "4"
    And I press "Rate"
  Then the read after date should be 0 years from now

Scenario: rate both parts changes parent read after date based on best part
  Given a page exists with title: "Parent" AND base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-2"
  When I am on the homepage
    And I follow "Parent"
    And I follow "Part 1"
    And I follow "Rate"
    And I choose "4"
    And I press "Rate"
    And I follow "Parent"
    And I follow "Part 2"
    And I follow "Rate"
    And I choose "1"
    And I press "Rate"
  Then the read after date should be 1 years from now

