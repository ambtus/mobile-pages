Feature: unread states

  Scenario: add unread part to read parent
    Given a page exists with title: "Multi", urls: "http://test.sidrasue.com/parts/1.html"
      And I am on the homepage
   Then I should see "Multi" within "#position_1"
   Then I should see "unread" within ".last_read"
   When I follow "Rate"
     And I press "1"
   Then I should not see "unread" within ".last_read"
   When I follow "Read"
     And I follow "Manage Parts"
     And I fill in "url_list" with
       """
       http://test.sidrasue.com/parts/1.html
       http://test.sidrasue.com/parts/2.html
       """
     And I press "Update"
   When I am on the homepage
   Then I should see "Multi" within "#position_1"
     And I should not see "unread" within ".last_read"
   When I follow "Multi" within "#position_1"
     And I follow "Read" within "#position_1"
   Then I should not see "unread" within ".last_read"
   When I follow "Multi" within ".parent"
     And I follow "Read" within "#position_2"
   Then I should see "unread" within ".last_read"

   Scenario: add parent to read part
    Given a page exists with title: "Part", last_read: "2009-01-01"
      And I am on the page's page
   Then I should not see "unread" within ".last_read"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" within "#position_1"
   Then I should not see "unread" within "#position_1"

   Scenario: add parent to unread part
    Given a titled page exists
      And I am on the page's page
   Then I should see "unread" within ".last_read"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" within "#position_1"
   Then I should see "unread" within "#position_1"

   Scenario: rate a part marks ancestor read but not siblings
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
   When I am on the page's page
   Then I should see "unread" within ".last_read"
     And I should not see "favorite" within ".favorite"
   When I follow "Read" within "#position_1"
     And I follow "Rate"
     And I press "1"
   When I am on the page's page
   Then I should not see "unread" within ".last_read"
     And I should not see "favorite" within ".favorite"
#note: changes every year
     And I should not see "2010-" within "#position_1"
     And I should see "favorite" within "#position_1"
     And I should not see "unread" within "#position_1"
#note: changes every year
     And I should not see "2010-" within "#position_2"
     And I should not see "favorite" within "#position_2"
     And I should see "unread" within "#position_2"
   When I am on the page's page
     And I follow "Rate"
     And I press "2"
   When I am on the page's page
   Then I should not see "unread" within ".last_read"
     And I should not see "favorite" within ".favorite"
     And I should not see "favorite" within "#position_1"
     And I should not see "unread" within "#position_1"
     And I should not see "2010-" within "#position_1"
     And I should not see "unread" within "#position_2"
     And I should not see "favorite" within "#position_2"
     And I should not see "2010-" within "#position_2"
