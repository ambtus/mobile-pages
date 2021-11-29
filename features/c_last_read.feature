Feature: last_read (also unread)

  Scenario: after rate an unread page, display it's last read date
    Given a page exists
    When I am on the page's page
    Then I should see "unread" within ".last_read"
    When I follow "Rate"
      And I choose "1"
    And I press "Rate"
    Then last read should be today

  Scenario: after rate a read page, change it's last read date
    Given I have no pages
    And a page exists with last_read: "2008-01-01"
    When I am on the page's page
    Then I should see "2008-01-01" within ".last_read"
    When I follow "Rate"
      And I choose "1"
    And I press "Rate"
    Then I should NOT see "2008-01-01"
    And last read should be today

  Scenario: add unread part to read parent makes parent unread
    Given a page exists with url: "http://test.sidrasue.com/test.html"
    And a page exists with last_read: "2009-01-01" AND title: "Parent"
    When I am on the page's page
    Then I should see "unread" within ".last_read"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should see "unread" within ".last_read"
      And I should NOT see "unread" within "#position_1"
    When I am on the page's page
    Then I should see "unread" within ".last_read"

  Scenario: new parent for a read page should have last read date
    Given I have no pages
    And a page exists with last_read: "2008-01-01"
    When I am on the page's page
    Then I should see "2008-01-01" within ".last_read"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    Then I should see "New Parent" within ".title"
      And I should NOT see "unread"
      And I should see "2008-01-01" within ".last_read"
      And I should NOT see "2008-01-01" within "#position_1"

  Scenario: rating a part updates the parent and the part but not the sibling
    Given I have no pages
    And a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND last_read: "2009-01-01" AND stars: "5"
    When I am on the page's page
    Then I should see "2009-01-01" within ".last_read"
      And I should see "5 stars" within ".stars"
    When I follow "Part 2" within "#position_2"
    Then I should see "2009-01-01" within ".last_read"
    When I follow "Rate"
      And I choose "3"
    And I press "Rate"
      And I follow "Part 2"
      Then I should see today within ".last_read"
   When I am on the page's page
     Then I should see "2009-01-01" within ".last_read"
     But I should NOT see "2009-01-01" within "#position_1"
     And I should see today within "#position_2"
     And I should see "3 stars" within "#position_2"

   Scenario: add unread part(s) to parent with read parts makes parent unread, rating one leaves parent unread, rating both updates parent
    Given I have no pages
    And a page exists with title: "Multi" AND urls: "http://test.sidrasue.com/parts/1.html" AND last_read: "2009-01-01"
    When I am on the homepage
    Then I should NOT see "unread" within "#position_1"
    And I should see "2009-01-01" within "#position_1"
   When I follow "Multi"
     And I follow "Manage Parts"
     And I fill in "url_list" with
       """
       http://test.sidrasue.com/parts/1.html
       http://test.sidrasue.com/parts/2.html
       http://test.sidrasue.com/parts/3.html
       """
     And I press "Update"
   Then I should see "unread" within ".last_read"
     And I should see "2009-01-01" within "#position_1"
     And I should NOT see "2009-01-01" within "#position_2"
     And I should NOT see "unread" within "#position_2"
   When I am on the homepage
   Then I should see "unread" within "#position_1"
    And I should NOT see "2009-01-01" within "#position_1"
  When I follow "Multi"
   And I follow "Part 2"
      And I follow "Rate"
      And I choose "3"
    And I press "Rate"
    When I am on the homepage
   Then I should see "unread" within "#position_1"
    And I should NOT see "2009-01-01" within "#position_1"
   When I follow "Multi" within "#position_1"
     Then I should see "unread" within ".last_read"
     And I should see "2009-01-01" within "#position_1"
     And I should NOT see "unread" within "#position_2"
     And I should NOT see "2009-01-01" within "#position_2"
     And I should see today within "#position_2"
     And I should NOT see "unread" within "#position_3"
    When I follow "Part 3"
    Then I should see "unread" within ".last_read"
    When I follow "Rate"
      And I choose "5"
    And I press "Rate"
    When I am on the homepage
   Then I should NOT see "unread" within "#position_1"
    And I should see "2009-01-01" within "#position_1"
