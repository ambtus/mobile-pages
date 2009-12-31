Feature: unread states

  Scenario: add unread part to read parent
    Given the following page
      | title | urls |
      | Multi | http://sidrasue.com/tests/parts/1.html |
      And I am on the homepage
   Then I should see "Multi" in ".title"
   Then I should see "unread" in ".states"
   When I follow "Rate"
     And I press "1"
   Then I should not see "unread" in ".states"
   When I follow "Read"
     And I follow "Manage Parts"
     And I fill in "url_list" with lines "http://sidrasue.com/tests/parts/1.html\nhttp://sidrasue.com/tests/parts/2.html"
     And I press "Update"
   When I am on the homepage
   Then I should see "Multi" in ".title"
     And I should see "unread" in ".states"
   When I am on the homepage
     And I follow "List Parts"
     And I follow "Read" in "#position_1"
   Then I should not see "unread" in ".states"
   When I am on the homepage
     And I follow "Parts"
     And I follow "Read" in "#position_2"
   Then I should see "unread" in ".states"

   Scenario: add parent to read part
    Given the following page
      | title | url | last_read |
      | Part | http://sidrasue.com/tests/parts/1.html | 2009-01-01 |
      And I am on the homepage
   Then I should not see "unread" in ".states"
   When I follow "Read"
     And I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" in ".title"
   Then I should not see "unread" in ".states"

   Scenario: add parent to unread part
    Given the following page
      | title | url |
      | Part | http://sidrasue.com/tests/parts/1.html |
      And I am on the homepage
   Then I should see "unread" in ".states"
   When I follow "Read"
     And I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" in ".title"
   Then I should see "unread" in ".states"

   Scenario: rate a part
    Given the following page
      | title | base_url | url_substitutions |
      | Read Separately | http://sidrasue.com/tests/parts/*.html | 1 2 |
      And I am on the homepage
   Then I should see "Read Separately" in ".title"
   Then I should see "unread" in ".states"
   When I follow "Parts"
     And I follow "Read" in "#position_1"
     And I follow "Rate"
     And I press "1"
   When I am on the homepage
   Then I should see "unread" in ".states"
   Then I should not see "favorite" in ".states"
   When I follow "Parts"
     And I follow "Read" in "#position_1"
     Then I should not see "unread" in ".states"
     And I should see "favorite" in ".states"
   When I am on the homepage
   When I follow "Parts"
     And I follow "Read" in "#position_2"
     Then I should see "unread" in ".states"
     And I should not see "favorite" in ".states"
   When I am on the homepage
     And I follow "Rate"
     And I press "1"
   When I am on the homepage
   Then I should not see "unread" in ".states"
   When I follow "Parts"
   And I follow "Read" in "#position_1"
     Then I should not see "unread" in ".states"
     And I should not see "favorite" in ".states"
   When I am on the homepage
   When I follow "Parts"
   And I follow "Read" in "#position_2"
     Then I should not see "unread" in ".states"
     And I should not see "favorite" in ".states"
