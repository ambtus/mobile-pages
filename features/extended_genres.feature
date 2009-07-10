Feature: unread genres

  Scenario: add unread part to read parent
    Given I have no pages
    And the following page
      | title | urls | 
      | Multi | http://www.rawbw.com/~alice/parts/1.html | 
      And I am on the homepage
   Then I should see "Multi" in ".title"
   Then I should see "unread" in ".genres"
   When I follow "Rate"
     And I press "1"
   Then I should not see "unread" in ".genres"
   When I follow "Manage Parts"
     And I fill in "url_list" with "http://www.rawbw.com/~alice/parts/1.html\nhttp://www.rawbw.com/~alice/parts/2.html"
     And I press "Update"
   When I am on the homepage
   Then I should see "Multi" in ".title"
     And I should see "unread" in ".genres"
   When I am on the homepage
     And I follow "Parts"
     And I follow "Read" in "#position_1"
   Then I should not see "unread" in ".genres"
   When I am on the homepage
     And I follow "Parts"
     And I follow "Read" in "#position_2"
   Then I should see "unread" in ".genres"

   Scenario: add parent to read part
    Given I have no pages
    And the following page
      | title | url | last_read |
      | Part | http://www.rawbw.com/~alice/parts/1.html | 2009-01-01 |
      And I am on the homepage
   Then I should not see "unread" in ".genres"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" in ".title"
   Then I should not see "unread" in ".genres"

   Scenario: add parent to unread part
    Given I have no pages
    And the following page
      | title | url | 
      | Part | http://www.rawbw.com/~alice/parts/1.html | 
      And I am on the homepage
   Then I should see "unread" in ".genres"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" in ".title"
   Then I should see "unread" in ".genres"

   Scenario: rate a part
    Given I have no pages
    And the following page
      | title | base_url | url_substitutions |
      | Read Separately | http://www.rawbw.com/~alice/parts/*.html | 1 2 |
      And I am on the homepage
   Then I should see "Read Separately" in ".title"
   Then I should see "unread" in ".genres"
   When I follow "Parts"
     And I follow "Read" in "#position_1"
     And I follow "Rate"
     And I press "1"
   When I am on the homepage
   Then I should see "unread" in ".genres"
   Then I should not see "favorite" in ".genres"
   When I follow "Parts"
     And I follow "Read" in "#position_1"
     Then I should not see "unread" in ".genres"
     And I should see "favorite" in ".genres"
   When I am on the homepage
   When I follow "Parts"
     And I follow "Read" in "#position_2"
     Then I should see "unread" in ".genres"
     And I should not see "favorite" in ".genres"
   When I am on the homepage
     And I follow "Rate"
     And I press "1"
   When I am on the homepage
   Then I should not see "unread" in ".genres"
   When I follow "Parts"
   And I follow "Read" in "#position_1"
     Then I should not see "unread" in ".genres"
     And I should not see "favorite" in ".genres"
   When I am on the homepage
   When I follow "Parts"
   And I follow "Read" in "#position_2"
     Then I should not see "unread" in ".genres"
     And I should not see "favorite" in ".genres"
