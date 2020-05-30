Feature: last_read (also unread)

  Scenario: after rate an unread page, display it's last read date
    Given a page exists
    When I am on the page's page
    Then I should NOT see ".last_read"
    When I follow "Rate"
      And I choose "boring"
      And I choose "stressful"
    And I press "Rate"
    Then last read should be today

  Scenario: after rate a read page, change it's last read date
    Given a page exists with last_read: "2008-01-01"
    When I am on the page's page
    Then I should see "2008-01-01" within ".last_read"
    When I follow "Rate"
      And I choose "boring"
      And I choose "stressful"
    And I press "Rate"
    Then I should NOT see "2008-01-01"
    And last read should be today

  Scenario: add unread part to read parent
    Given a page exists with last_read: "2009-01-01" AND title: "Parent"
    And a page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should NOT see "unread" within ".last_read"
      And I should see "unread" within "#position_1"

  Scenario: new parent for an existing page should have last read date
    Given a page exists with last_read: "2008-01-01"
    When I am on the page's page
    Then I should see "2008-01-01" within ".last_read"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    Then I should see "New Parent" within ".title"
      And I should see "2008-01-01" within ".last_read"
      And I should see "Page 1" within "#position_1"
      And I should NOT see "2008-01-01" within "#position_1"

   Scenario: rate a part marks parent read but not siblings
    Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2 3"
   When I am on the page's page
   Then I should see "unread" within ".last_read"
   When I follow "Part 1" within "#position_1"
     And I follow "Rate"
      And I choose "very interesting"
      And I choose "very sweet"
     And I press "Rate"
   When I am on the page's page
   Then I should NOT see "unread" within ".last_read"
     And I should NOT see "unread" within "#position_1"
     But I should see "unread" within "#position_2"
     And I should see "unread" within "#position_3"
  When I follow "Part 2" within "#position_2"
     And I follow "Rate"
      And I choose "very interesting"
      And I choose "sweet enough"
     And I press "Rate"
   When I am on the page's page
   Then I should NOT see "unread" within ".last_read"
     And I should NOT see "unread" within "#position_1"
     And I should NOT see "unread" within "#position_2"
     But I should see "unread" within "#position_3"
