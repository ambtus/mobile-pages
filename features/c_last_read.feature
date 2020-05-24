Feature: last_read (also unread)

  Scenario: find recently read page if no pages
    When I am on the homepage
    When I choose "sort_by_recently_read"
      And I press "Find"
    Then I should see "No pages"

  Scenario: find recently read pages
    Given the following pages
      | title  | last_read  |
      | first  | 2014-01-01 |
      | second | 2014-02-01 |
      | third  | 2014-03-01 |
    When I am on the homepage
    Then I should see "first" within "#position_1"
    When I choose "sort_by_recently_read"
      And I press "Find"
    Then I should see "third" within "#position_1"
      And I should see "second" within "#position_2"
      And I should see "first" within "#position_3"

  Scenario: after rate an unread page, display it's last read date
    Given a page exists
    When I am on the page's page
    Then I should not see ".last_read"
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
    Then I should not see "2008-01-01"
    And last read should be today

  Scenario: unread part
    Given I have no pages
    Given the following pages
     | title  | last_read  | url   | tags |
     | Filler | 2008-01-01 | http://test.sidrasue.com/long.html | one |
     | Parent | 2009-01-01 |       | two |
    When I am on the homepage
    Then I should see "Filler" within "#position_1"
      And I should not see "unread"
      And I should see "medium"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "Child"
      And I select "one" from "tag"
      And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should not see "Parent with that title has content"
      And I should not see "unread" within ".last_read"
      And I should see "unread" within "#position_1"
      And I should see "short" within ".size"
      And I should not see "short" within "#position_1"
      And I should see "two" within ".tags"
      And I should see "one" within "#position_1"
    When I am on the homepage
    Then I should see "Filler"
    When I choose "unread_yes"
      And I press "Find"
      # no longer find unread parts...
    Then I should not see "Parent"
    When I fill in "page_url" with "http://test.sidrasue.com/long2.html"
      And I fill in "page_title" with "Child2"
      And I select "one" from "tag"
      And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should see "medium" within ".size"
      And I should not see "medium" within "#position_2"
      And I should see "short" within "#position_1"
      And I should not see "two" within "#position_2"
      And I should see "one" within "#position_2"
    When I am on the homepage
      And I select "one" from "tag"
      And I press "Find"
    Then I should see "Filler"
      And I should not see "Parent"

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
      And I should not see "2008-01-01" within "#position_1"

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
   Then I should not see "unread" within ".last_read"
     And I should not see "unread" within "#position_1"
     But I should see "unread" within "#position_2"
     And I should see "unread" within "#position_3"
  When I follow "Part 2" within "#position_2"
     And I follow "Rate"
      And I choose "very interesting"
      And I choose "sweet enough"
     And I press "Rate"
   When I am on the page's page
   Then I should not see "unread" within ".last_read"
     And I should not see "unread" within "#position_1"
     And I should not see "unread" within "#position_2"
     But I should see "unread" within "#position_3"
