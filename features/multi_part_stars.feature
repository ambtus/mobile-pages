Feature: parts can differ in stars from parent

Scenario: average if no mode
  Given Uneven exists
  When I am on the page with title "Uneven"
  Then I should see "1 unread part (2010-01-01)" within ".last_read"
    And I should see "2 stars" within ".stars"
    And I should see "1 star" within "#position_1"
    And I should see "2 stars" within "#position_2"
    And I should see "3 stars" within "#position_3"
    And I should see "4 stars" within "#position_4"
    And I should see "unread" within "#position_5"

Scenario: stars as mode (most common)
  Given Uneven exists
  When I am on the page with title "Uneven"
    And I follow "Rate" within "#position_5"
    And I click on "3"
    And I press "Rate"
    And I am on the page with title "Uneven"
  Then I should see "2010-01-01" within ".last_read"
    But I should NOT see "unread parts"
    And I should see "3 stars" within ".stars"
    And I should see "3 stars" within "#position_5"
    And I should NOT see "unread"

Scenario: changed highest (still no mode)
  Given Uneven exists
  When I am on the page with title "Uneven"
    And I follow "Rate" within "#position_5"
    And I click on "5"
    And I press "Rate"
    And I am on the page with title "Uneven"
  Then I should see "2010-01-01" within ".last_read"
    But I should NOT see "unread parts"
    And I should see "3 stars" within ".stars"
    And I should see "5 stars" within "#position_5"
    And I should NOT see "unread"

Scenario: rate all unread with stars
  Given Uneven exists
  When I am on the page with title "Uneven"
    And I follow "Rate" within ".views"
    And I click on "5"
    And I press "Rate"
  When I am on the page with title "Uneven"
    Then I should see "2010-01-01" within ".last_read"
    But I should NOT see "unread parts"
    And I should see "3 stars" within ".stars"
    And I should see "1 star" within "#position_1"
    And I should see "2 stars" within "#position_2"
    And I should see "3 stars" within "#position_3"
    And I should see "4 stars" within "#position_4"
    And I should see "5 stars" within "#position_5"
    But I should NOT see "unread" within "#position_5"

Scenario: rate all with stars rates all
  Given Uneven exists
  When I am on the page with title "Uneven"
    And I follow "Rate" within ".views"
    And I click on "5"
  And I click on "All Parts"
    And I press "Rate"
  When I am on the page with title "Uneven"
  Then I should NOT see "2010-01-01"
    And I should see "5 stars" within ".stars"
    And last read should be today
    ## FIXME - shouldn't show stars if they're *all* the same
    #But I should NOT see "stars" within ".parts"
    And I should see "5 stars" within "#position_1"
    And I should see "5 stars" within "#position_2"
    And I should see "5 stars" within "#position_3"
    And I should see "5 stars" within "#position_4"
    And I should see "5 stars" within "#position_5"

