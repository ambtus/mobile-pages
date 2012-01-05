Feature: mark as favorite

  Scenario: unread and favorite states
    Given a titled page exists
    When I am on the page's page
    Then I should see "unread" within ".last_read"
    When I follow "Rate"
      And I press "1"
   Then I should see "favorite" within ".favorite"
     And I should not see "unread" within ".last_read"
    When I follow "Rate"
      And I press "2"
   Then I should not see "favorite" within ".favorite"
     And I should not see "unread" within ".last_read"
     And I should see "good" within ".favorite"

   Scenario: rate a part marks ancestor read but not siblings
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
   When I am on the page's page
   Then I should see "unread" within ".last_read"
     And I should not see "favorite" within ".favorite"
   When I follow "Part 1" within "#position_1"
     And I follow "Rate"
     And I press "1"
   When I am on the page's page
   Then I should not see "unread" within ".last_read"
     And I should not see "favorite" within ".favorite"
#FIXME: changes every year
     And I should not see "2012-" within "#position_1"
     And I should see "favorite" within "#position_1"
     And I should not see "unread" within "#position_1"
#FIXME: changes every year
     And I should not see "2012-" within "#position_2"
     And I should not see "favorite" within "#position_2"
     And I should see "unread" within "#position_2"
   When I am on the page's page
     And I follow "Rate"
     And I press "2"
   When I am on the page's page
   Then I should not see "unread" within ".last_read"
     And I should see "good" within ".favorite"
     And I should not see "favorite" within ".favorite"
     And I should not see "favorite" within "#position_1"
     And I should not see "good" within "#position_1"
     And I should not see "unread" within "#position_1"
#FIXME: changes every year
     And I should not see "2012-" within "#position_1"
     And I should not see "unread" within "#position_2"
     And I should not see "favorite" within "#position_2"
     And I should not see "good" within "#position_2"
#FIXME: changes every year
     And I should not see "2012-" within "#position_2"
