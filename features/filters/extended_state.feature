Feature: unread states

  Scenario: add unread part to read parent
    Given a page exists with title: "Multi", urls: "http://test.sidrasue.com/parts/1.html"
      And I am on the homepage
   Then I should see "Multi" in ".title"
   Then I should see "unread" in ".last_read"
   When I follow "Rate"
     And I press "1"
   Then I should not see "unread" in ".last_read"
   When I follow "Read"
     And I follow "Manage Parts"
     And I fill in "url_list" with lines "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html"
     And I press "Update"
   When I am on the homepage
   Then I should see "Multi" in ".title"
     And I should not see "unread" in ".last_read"
   When I am on the homepage
     And I follow "List Parts"
     And I follow "Read" in "#position_1"
   Then I should not see "unread" in ".last_read"
   When I am on the homepage
     And I follow "Parts"
     And I follow "Read" in "#position_2"
   Then I should see "unread" in ".last_read"

   Scenario: add parent to read part
    Given a page exists with title: "Part", last_read: "2009-01-01"
      And I am on the page's page
   Then I should not see "unread" in ".last_read"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" in ".title"
   Then I should not see "unread" in ".last_read"

   Scenario: add parent to unread part
    Given a titled page exists
      And I am on the page's page
   Then I should see "unread" in ".last_read"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" in ".title"
   Then I should see "unread" in ".last_read"

   Scenario: rate a part makes the parent read, but not siblings
    Given the following page
      | title           | base_url                              | url_substitutions |
      | Read Separately | http://test.sidrasue.com/parts/*.html | 1 2               |
      And I am on the homepage
   Then I should see "Read Separately" in ".title"
   Then I should see "unread" in ".last_read"
   When I follow "Parts"
     And I follow "Read" in "#position_1"
     And I follow "Rate"
     And I press "1"
   When I am on the homepage
   Then I should not see "unread" in ".last_read"
   Then I should not see "favorite" in ".favorite"
   When I follow "Parts"
     Then I should not see "unread" in "#position_1"
     And I should see "favorite" in "#position_1"
     And I should see "unread" in "#position_2"
     And I should not see "favorite" in "#position_2"
   When I am on the homepage
     And I follow "Rate"
     And I press "1"
   When I am on the homepage
   Then I should not see "unread" in ".last_read"
     And I should see "favorite" in ".favorite"
   When I follow "Parts"
     Then I should not see "unread" in "#position_1"
     And I should not see "favorite" in "#position_1"
     And I should not see "unread" in "#position_2"
     And I should not see "favorite" in "#position_2"
