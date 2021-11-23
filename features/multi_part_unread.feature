Feature: one part unread

  Scenario: start with two pages
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

    # Add an unread part with same fandom to parent
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "Child1"
      And I select "two" from "fandom"
      And I press "Store"
    Then I should see "unread" within ".last_read"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should NOT see "Parent with that title has content"
      And I should see "unread" within ".last_read"
      And I should NOT see "unread" within "#position_1"
      And I should see "drabble" within ".size"
      And I should NOT see "drabble" within "#position_1"
      And I should see "two" within ".fandoms"
      And I should NOT see "two" within "#position_1"

    # find parent with unread part
    When I am on the homepage
    And I choose "unread_yes"
      And I press "Find"
    Then I should see "Parent"

    # Add an unread part with different fandom to parent
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

    # find an unread part with a parent with different fandom
    When I am on the homepage
      And I select "one" from "fandom"
      And I press "Find"
    Then I should see "Filler" within "#position_1"
      And I should see "Child2 of Parent" within "#position_2"
      And I should NOT see "Child1"
