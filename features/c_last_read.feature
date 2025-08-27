Feature: last_read (also unread)

Scenario: an unread page
  Given a page exists
  When I am on the first page's page
  Then I should see "unread" within ".last_read"

Scenario: after rate an unread page, display it's last read date
  Given a page exists
  When I rate it 3 stars
  Then last read should be today

Scenario: a read page
  Given a page exists with last_read: "2008-01-01"
  When I am on the first page's page
  Then I should see "2008-01-01" within ".last_read"

Scenario: after rate a read page, change it's last read date
  Given a page exists with last_read: "2008-01-01"
  When I rate it 3 stars
  Then I should NOT see "2008-01-01"
    And last read should be today

Scenario: add unread part to read parent makes parent unread
  Given a page exists
    And a page exists with last_read: "2009-01-01" AND title: "Parent"
  When I am on the first page's page
    And I add a parent with title "Parent"
  Then I should see "Parent (Book)" within ".title"
    And I should see "unread" within ".last_read"
    And I should see "unread" within "#position_1"

Scenario: add read part to unread parent makes parent read
  Given a page exists with title: "Parent"
    And a page exists with last_read: "2008-01-01"
  When I am on the first page's page
    And I add a parent with title "Parent"
  Then I should see "Parent" within ".title"
    And I should NOT see "unread"
    And I should see "2008-01-01" within ".last_read"
    And I should see "2008-01-01" within "#position_1"

Scenario: add earlier read part to read parent (no other parts) changes last read date of parent
  Given a page exists with title: "Parent" and last_read: "2009-01-01"
    And a page exists with last_read: "2008-01-01"
  When I am on the first page's page
    And I add a parent with title "Parent"
  Then I should see "Parent" within ".title"
    And I should NOT see "unread"
    And I should see "2008-01-01" within ".last_read"
    And I should see "2008-01-01" within "#position_1"

Scenario: add read part to earlier read parent (no other parts) changes last read date of parent
  Given a page exists with title: "Parent" and last_read: "2008-01-01"
    And a page exists with last_read: "2009-01-01"
  When I am on the first page's page
    And I add a parent with title "Parent"
  Then I should see "Parent" within ".title"
    And I should NOT see "unread"
    And I should see "2009-01-01" within ".last_read"
    And I should see "2009-01-01" within "#position_1"

Scenario: rating a part updates the part
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND last_read: "2009-01-01" AND stars: "5"
  When I am on the first page's page
    And I follow "Part 1" within "#position_1"
    And I follow "Rate"
    And I click on "3"
    And I press "Rate"
  Then I should see today within ".last_read"
    And I should see "3 stars" within ".stars"

Scenario: rating a part updates the parent and the part but not the sibling
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND last_read: "2009-01-01" AND stars: "5"
  When I am on the first page's page
    And I follow "Part 1" within "#position_1"
    And I follow "Rate"
    And I click on "3"
    And I press "Rate"
    And I follow "Page 1" within ".parent"
    # parent gets earliest read of parts
  Then I should see "2009-01-01" within ".last_read"
    # parent gets average if there is no mode
    And I should see "4 stars" within ".stars"

Scenario: rating a part does not update the sibling
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html" AND last_read: "2009-01-01" AND stars: "5"
  When I am on the first page's page
    And I follow "Part 1" within "#position_1"
    And I follow "Rate"
    And I click on "3"
    And I press "Rate"
    And I follow "Page 1" within ".parent"
    And I follow "Part 2" within "#position_2"
  Then I should NOT see today within ".last_read"
    But I should see "2009-01-01" within ".last_read"
    And I should see "5 stars" within ".stars"
