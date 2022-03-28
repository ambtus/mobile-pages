Feature: parts differ in stars from parent

   Scenario: select most commonly rated
     Given I have no pages
     And Uneven exists
     When I am on the page with title "Uneven"
     Then I should see "1 unread part (2010-01-01)" within ".last_read"
     And I should see "4 stars" within ".stars"
     When I follow "Rate" within "#position_5"
     And I choose "3"
     And I press "Rate"
     When I am on the page with title "Uneven"
     Then I should see "2010-01-01" within ".last_read"
       But I should NOT see "unread parts"
     And I should see "3 stars" within ".stars"
     And I should see "1 star" within "#position_1"
     And I should see "2 stars" within "#position_2"
     And I should see "3 stars" within "#position_3"
     And I should see "4 stars" within "#position_4"
     And I should see "3 stars" within "#position_5"

   Scenario: highest if no mode
     Given I have no pages
     And Uneven exists
     When I am on the page with title "Uneven"
     When I follow "Rate" within "#position_5"
     And I choose "5"
     And I press "Rate"
     When I am on the page with title "Uneven"
     Then I should see "2010-01-01" within ".last_read"
       But I should NOT see "unread parts"
     And I should see "5 stars" within ".stars"
     And I should see "1 star" within "#position_1"
     And I should see "2 stars" within "#position_2"
     And I should see "3 stars" within "#position_3"
     And I should see "4 stars" within "#position_4"
     And I should see "5 stars" within "#position_5"
     And I should NOT see "unread" within "#position_5"

   Scenario: unfinished is highest star
     Given I have no pages
     And Uneven exists
     When I am on the page with title "Uneven"
     When I follow "Rate" within "#position_5"
     And I press "Rate unfinished"
     When I am on the page with title "Uneven"
     Then I should see "1 unread part (2010-01-01)" within ".last_read"
     And I should see "unfinished" within ".stars"
     And I should see "1 star" within "#position_1"
     And I should see "2 stars" within "#position_2"
     And I should see "3 stars" within "#position_3"
     And I should see "4 stars" within "#position_4"
     And I should see "unfinished" within "#position_5"
     And I should NOT see "stars" within "#position_5"
     And I should NOT see "unread" within "#position_5"

   Scenario: rate all unread
     Given I have no pages
     And Uneven exists
     When I am on the page with title "Uneven"
     When I follow "Rate" within ".views"
     And I choose "5"
     And I press "Rate all unrated parts"
     When I am on the page with title "Uneven"
     Then I should see "2010-01-01" within ".last_read"
       But I should NOT see "unread parts"
     And I should see "5 stars" within ".stars"
     And I should see "1 star" within "#position_1"
     And I should see "2 stars" within "#position_2"
     And I should see "3 stars" within "#position_3"
     And I should see "4 stars" within "#position_4"
     And I should see "5 stars" within "#position_5"
     But I should NOT see "unread" within "#position_5"

   Scenario: all unread => unfinished
     Given I have no pages
     And Uneven exists
     When I am on the page with title "Uneven"
     When I follow "Rate" within ".views"
     And I choose "5"
     And I press "Rate unfinished"
     When I am on the page with title "Uneven"
     Then I should see "1 unread part (2010-01-01)" within ".last_read"
     And I should see "unfinished" within ".stars"
     And I should see "1 star" within "#position_1"
     And I should see "2 stars" within "#position_2"
     And I should see "3 stars" within "#position_3"
     And I should see "4 stars" within "#position_4"
     And I should see "unfinished" within "#position_5"
     But I should NOT see "unread" within "#position_5"

   Scenario: re-rate all
     Given I have no pages
     And Uneven exists
     When I am on the page with title "Uneven"
     When I follow "Rate" within ".views"
     And I choose "5"
     And I press "Rate"
     When I am on the page with title "Uneven"
     Then I should NOT see "2010-01-01"

