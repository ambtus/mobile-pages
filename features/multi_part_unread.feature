Feature: parts differ in unread status from parent

Scenario: add unread part(s) to parent with read parts makes parent unread
  Given a page exists with title: "Multi" AND urls: "http://test.sidrasue.com/parts/1.html" AND last_read: "2009-01-01"
  When I am on the homepage
    And I follow "Multi"
    And I follow "Manage Parts"
    And I fill in "url_list" with
    """
    http://test.sidrasue.com/parts/1.html
    http://test.sidrasue.com/parts/2.html
    http://test.sidrasue.com/parts/3.html
    """
    And I press "Update"
  Then I should see "2 unread parts (2009-01-01)" within ".last_read"
    And I should see "2009-01-01" within "#position_1"
    And I should see "unread" within "#position_2"
    And I should see "unread" within "#position_3"

Scenario: rating one leaves parent unread
  Given a page exists with title: "Multi" AND urls: "http://test.sidrasue.com/parts/1.html" AND last_read: "2009-01-01"
  When I am on the homepage
    And I follow "Multi"
    And I follow "Manage Parts"
    And I fill in "url_list" with
    """
    http://test.sidrasue.com/parts/1.html
    http://test.sidrasue.com/parts/2.html
    http://test.sidrasue.com/parts/3.html
    """
    And I press "Update"
    And I follow "Part 2"
    And I follow "Rate"
    And I choose "3"
    And I press "Rate"
    And I follow "Multi" within ".parent"
  Then I should see "1 unread part (2009-01-01)"
    And I should see "2009-01-01" within "#position_1"
    And I should see today within "#position_2"
    And I should see "unread" within "#position_3"

Scenario: rating both updates parent as read
  Given a page exists with title: "Multi" AND urls: "http://test.sidrasue.com/parts/1.html" AND last_read: "2009-01-01"
  When I am on the homepage
    And I follow "Multi"
    And I follow "Manage Parts"
    And I fill in "url_list" with
    """
    http://test.sidrasue.com/parts/1.html
    http://test.sidrasue.com/parts/2.html
    http://test.sidrasue.com/parts/3.html
    """
    And I press "Update"
    And I follow "Rate"
    And I choose "5"
    And I press "Rate all unrated parts"
    And I am on the page's page
  Then I should NOT see "unread"
    And I should see "2009-01-01" within ".last_read"
    And I should see "2009-01-01" within "#position_1"
    And I should see today within "#position_2"
    And I should see today within "#position_3"

