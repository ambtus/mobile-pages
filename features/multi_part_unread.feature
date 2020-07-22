Feature: one part unread

  Scenario: unread part
    Given I have no pages
    Given the following pages
     | title  | last_read  | url   | fandoms |
     | Filler | 2008-01-01 | http://test.sidrasue.com/long.html | one |
     | Parent | 2009-01-01 |       | two |
    When I am on the homepage
    Then I should see "Filler" within "#position_1"
      And I should NOT see "unread" within "#position_1"
      And I should see "2008-01-01" within "#position_1"
    And I should see "Parent" within "#position_2"
      And I should NOT see "unread" within "#position_2"
      And I should see "2009-01-01" within "#position_2"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "Child"
      And I select "one" from "fandom"
      And I press "Store"
    Then I should see "unread" within ".last_read"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should NOT see "Parent with that title has content"
      And I should see "unread" within ".last_read"
      And I should NOT see "unread" within "#position_1"
      And I should see "short" within ".size"
      And I should NOT see "short" within "#position_1"
      And I should see "two" within ".fandoms"
      And I should see "one" within "#position_1"
    When I am on the homepage
    Then I should see "Filler"
    When I choose "unread_yes"
      And I press "Find"
      # now find unread parts (actually, unread parts make the parent unread)
    Then I should see "Parent"
    When I fill in "page_url" with "http://test.sidrasue.com/long2.html"
      And I fill in "page_title" with "Child2"
      And I select "one" from "fandom"
      And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should see "medium" within ".size"
      And I should NOT see "two" within "#position_2"
      And I should see "one" within "#position_2"
    When I am on the homepage
      And I select "one" from "fandom"
      And I press "Find"
    Then I should see "Filler"
      And I should NOT see "Parent"

