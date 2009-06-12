Feature: unread genres

  Scenario: add unread part
    Given I have no pages
    And the following page
      | title | urls | read_after |
      | Multi | http://www.rawbw.com/~alice/parts/1.html | 2007-01-01 |
      | Test  | http://www.rawbw.com/~alice/parts/4.html | 2007-02-01 |
      And I am on the homepage
   Then I should see "Multi" in ".title"
   Then I should see "unread" in ".genres"
   When I follow "Manage Parts"
     And I fill in "url_list" with "http://www.rawbw.com/~alice/parts/1.html\nhttp://www.rawbw.com/~alice/parts/2.html"
     And I press "Update"
   When I am on the homepage
   Then I should see "Multi" in ".title"
   When I follow "Rate"
     And I press "1"
   Then I should see "Test" in ".title"
   When I follow "Rate"
     And I press "1"
   When I am on the homepage
   Then I should not see "unread" in ".genres"
   When I follow "Manage Parts"
     And I fill in "url_list" with "http://www.rawbw.com/~alice/parts/1.html\nhttp://www.rawbw.com/~alice/parts/2.html\nhttp://www.rawbw.com/~alice/parts/3.html"
     And I press "Update"
   Then I should not see "unread" in ".genres"
     And I follow "Read" in "#position_1"
   Then I should not see "unread" in ".genres"
   When I am on the homepage
     And I follow "Read" 
     And I follow "Read" in "#position_3"
   Then I should see "unread" in ".genres"
   When I am on the homepage
     And I select "status: unread"
     And I press "Filter"
   Then I should see "Multi" in ".parent"
