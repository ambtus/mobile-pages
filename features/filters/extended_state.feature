Feature: unread states

  Scenario: add unread part to read parent
    Given a page exists with title: "Multi", urls: "http://test.sidrasue.com/parts/1.html"
      And I am on the homepage
   Then I should see "Multi" in "#position_1"
   Then I should see "unread" in ".last_read"
   When I follow "Rate"
     And I press "1"
   Then I should not see "unread" in ".last_read"
   When I follow "Read"
     And I follow "Manage Parts"
     And I fill in "url_list" with lines "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html"
     And I press "Update"
   When I am on the homepage
   Then I should see "Multi" in "#position_1"
     And I should not see "unread" in ".last_read"
   When I follow "Multi" in "#position_1"
     And I follow "Read" in "#position_1"
   Then I should not see "unread" in ".last_read"
   When I follow "Multi" in ".parent"
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
   Then I should see "Parent" in "#position_1"
   Then I should not see "unread" in "#position_1"

   Scenario: add parent to unread part
    Given a titled page exists
      And I am on the page's page
   Then I should see "unread" in ".last_read"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" in "#position_1"
   Then I should see "unread" in "#position_1"

   Scenario: rate a part marks ancestor read but not siblings
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
   When I am on the page's page
   Then I should see "unread" in ".last_read"
     And I should not see "favorite" in ".favorite"
   When I follow "Read" in "#position_1"
     And I follow "Rate"
     And I press "1"
   When I am on the page's page
   Then I should not see "unread" in ".last_read"
     And I should not see "favorite" in ".favorite"
#note: changes every year
     And I should not see "2010-" in "#position_1"
     And I should see "favorite" in "#position_1"
     And I should not see "unread" in "#position_1"
#note: changes every year
     And I should not see "2010-" in "#position_2"
     And I should not see "favorite" in "#position_2"
     And I should see "unread" in "#position_2"
   When I am on the page's page
     And I follow "Rate"
     And I press "2"
   When I am on the page's page
   Then I should not see "unread" in ".last_read"
     And I should not see "favorite" in ".favorite"
     And I should not see "favorite" in "#position_1"
     And I should not see "unread" in "#position_1"
     And I should not see "2010-" in "#position_1"
     And I should not see "unread" in "#position_2"
     And I should not see "favorite" in "#position_2"
     And I should not see "2010-" in "#position_2"
