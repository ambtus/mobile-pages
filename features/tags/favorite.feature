Feature: favorite toggle

Scenario: favorite off by default
  Given a page exists
  When I am on the page's page
  Then I should NOT see "favorite" within ".stars"

Scenario: favorite off by default when rating
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
  Then "favorite_No" should be checked
    And "favorite_Yes" should NOT be checked

Scenario: turn favorite on while rating
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I click on "4"
    And I click on "favorite_Yes"
    And I press "Rate"
  Then I should see "4 stars Favorite"

Scenario: favorite pre-selected when existing
  Given a page exists with favorite: true
  When I am on the page's page
    And I follow "Rate"
  Then "favorite_Yes" should be checked
    And "favorite_No" should NOT be checked

Scenario: turn favorite off while rating
  Given a page exists with favorite: true
  When I am on the page's page
    And I follow "Rate"
    And I click on "4"
    And I click on "favorite_No"
    And I press "Rate"
  Then I should NOT see "4 stars Favorite"

Scenario: favorite tag on part
  Given Uneven exists
  When I am on the page with title "Uneven"
    And I follow "Rate" within "#position_5"
    And I click on "5"
    And I click on "favorite_Yes"
    And I press "Rate"
    And I am on the page with title "Uneven"
  Then I should NOT see "Favorite" within ".stars"
    But I should see "Favorite" within "#position_5"

Scenario: favorite only added to parent when rating parent
  Given Uneven exists
  When I am on the page's page
    And I follow "Rate"
    And I click on "4"
    And I click on "favorite_Yes"
    And I click on "all_All"
    And I press "Rate"
    And I am on the page's page
  Then I should see "Favorite" within ".stars"
    But I should NOT see "Favorite" within "#position_5"
