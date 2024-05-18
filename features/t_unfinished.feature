Feature: unfinished toggle

Scenario: unfinished off by default
  Given a page exists
  When I am on the page's page
  Then I should NOT see "unfinished" within ".cons"

Scenario: unfinished off by default when rating
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
  Then "unfinished_No" should be checked
    And "unfinished_Yes" should NOT be checked

Scenario: turn unfinished on while rating
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I click on "4"
    And I click on "unfinished_Yes"
    And I press "Rate"
  Then I should see "Con: unfinished"
    And "unfinished" should be selected in "page_con_ids_"

Scenario: unfinished pre-selected when existing
  Given a page exists with cons: "unfinished"
  When I am on the page's page
    And I follow "Rate"
  Then "unfinished_Yes" should be checked
    And "unfinished_No" should NOT be checked

Scenario: turn unfinished off while rating
  Given a page exists with cons: "unfinished"
  When I am on the page's page
    And I follow "Rate"
    And I click on "4"
    And I click on "unfinished_No"
    And I press "Rate"
  Then "unfinished" should NOT be selected in "page_con_ids_"

Scenario: unfinished tag on part
  Given Uneven exists
  When I am on the page with title "Uneven"
    And I follow "Rate" within "#position_5"
    And I click on "3"
    And I click on "unfinished_Yes"
    And I press "Rate"
    And I am on the page with title "Uneven"
  Then I should NOT see "unread"
    And I should NOT see "unfinished" within ".stars"
    But I should see "unfinished" within "#position_5"
    And I should see "3 stars" within "#position_5"

Scenario: rate all unread as unfinished
  Given Uneven exists
  When I am on the page with title "Uneven"
    And I follow "Rate" within ".views"
    And I click on "3"
    And I click on "unfinished_Yes"
    And I press "Rate"
    And I am on the page with title "Uneven"
  Then I should NOT see "unread"
    But I should see "3 stars" within ".stars"
    And I should see "unfinished" within ".cons"
    But I should NOT see "unfinished" within "#position_5"
    And I should see "3 stars" within "#position_5"
    And I should see "old stars (1)" within "#position_1"
    And I should see "old stars (2)" within "#position_2"
    And I should see "3 stars" within "#position_3"
    And I should see "4 stars" within "#position_4"

Scenario: unfinished only added to parent when rating parent
  Given Uneven exists
  When I am on the page's page
    And I follow "Rate"
    And I click on "4"
    And I click on "unfinished_Yes"
    And I click on "all_All"
    And I press "Rate"
    And I am on the page's page
  Then I should see "unfinished" within ".cons"
    But I should NOT see "unfinished" within "#position_5"

Scenario: unfinished added to part when rating part
  Given Uneven exists
  When I am on the page with title "part 5"
    And I follow "Rate"
    And I click on "4"
    And I click on "unfinished_Yes"
    And I press "Rate"
    And I am on the page's page
  Then I should NOT see "unfinished" within ".cons"
    But I should see "unfinished" within "#position_5"

Scenario: unfinished removed from parent, not rated part
  Given Uneven exists
  When I am on the page with title "part 4"
    And I follow "Rate"
    And I click on "4"
    And I click on "unfinished_Yes"
    And I press "Rate"
    And I am on the page's page
    And I am on the page with title "part 5"
    And I follow "Rate"
    And I click on "5"
    And I press "Rate"
    And I am on the page's page
  Then I should NOT see "unfinished" within ".cons"
    And I should NOT see "unfinished" within "#position_5"
    But I should see "unfinished" within "#position_4"

Scenario: unfinished on parent defaults off when rating chapter
  Given Uneven exists
    And "Uneven" is unfinished
  When I am on the page with title "part 5"
    And I follow "Rate"
  Then "unfinished_Yes" should NOT be checked
    And "unfinished_No" should be checked

Scenario: unfinished only added to part, not parent or grandparent
  Given a series exists
  When I am on the page with title "Season2"
    And I follow "Rate"
    And I click on "4"
    And I click on "unfinished_Yes"
    And I press "Rate"
    And I am on the page's page
  Then I should NOT see "unfinished" within ".cons"
    And I should NOT see "unfinished" within "#position_1"
    But "Season2" should be conned
