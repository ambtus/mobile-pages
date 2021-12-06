Feature: parts differ in fandom and unread status from parent

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
   Then I should see "unread parts (2009-01-01)" within ".last_read"
     And I should see "2009-01-01" within "#position_1"
     And I should see "unread" within "#position_2"
     And I should see "unread" within "#position_3"

   When I am on the homepage
   And I choose "unread_yes"
      And I press "Find"
   Then I should see "unread parts (2009-01-01)" within "#position_1"
    And the page should NOT contain css "#position_2"

  When I follow "Multi"
   And I follow "Part 2"
      And I follow "Rate"
      And I choose "3"
    And I press "Rate"

    When I am on the homepage
   Then I should see "unread parts (2009-01-01)" within "#position_1"
    And I should NOT see today within "#position_1"

   When I follow "Multi" within "#position_1"
     Then I should see "unread parts (2009-01-01)" within ".last_read"
     And I should see "2009-01-01" within "#position_1"
     And I should NOT see "unread" within "#position_2"
     And I should see today within "#position_2"
     And I should see "unread" within "#position_3"

    When I follow "Part 3"
    Then I should see "unread" within ".last_read"
    When I follow "Rate"
      And I choose "5"
    And I press "Rate"
    When I am on the homepage
   Then I should NOT see "unread" within "#position_1"
    And I should see "2009-01-01" within "#position_1"

  Scenario: unread parts with different fandoms
    Given I have no pages
    Given the following pages
     | title  | last_read  | url   | fandoms |
     | Parent | 2009-01-01 |       | two |
     | Child1 |  | http://test.sidrasue.com/long1.html | two |
     | Child2 | 2010-01-01 | http://test.sidrasue.com/long2.html | one |
     | Child3 |  | http://test.sidrasue.com/long3.html | one |

    When I am on the homepage
      And I choose "unread_yes"
      And I press "Find"
    Then I should see "Child1" within "#position_1"
      And I should see "unread" within "#position_1"
    And I should see "Child3" within "#position_2"
      And I should see "unread" within "#position_2"
    And the page should NOT contain css "#position_3"

    # Add an unread part with same fandom to parent
    When I am on the page with title "Child1"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should NOT see "Parent with that title has content"
      And I should see "unread" within ".last_read"
      And I should NOT see "unread parts" within ".last_read"

    # find parent with unread part
    When I am on the homepage
    And I choose "unread_yes"
      And I press "Find"
    Then I should see "Parent" within "#position_1"
      And I should see "unread" within "#position_1"
    And I should see "Child3" within "#position_2"
    And the page should NOT contain css "#position_3"

    # Add a read part with different fandom to parent
    When I am on the page with title "Child2"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"

    # Add an unread part with different fandom to parent
    When I am on the page with title "Child3"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"

    Then I should see "Parent" within ".title"
      And I should see "unread parts (2010-01-01)" within ".last_read"
      And I should see "30,003 words" within ".size"
      And I should see "Child1 (unread, 10,001 words, two)" within "#position_1"
      And I should see "Child2 (2010-01-01, 10,001 words, one)" within "#position_2"
      And I should see "Child3 (unread, 10,001 words, one)" within "#position_3"

    # find a part with a parent with different fandom
    When I am on the homepage
     And I choose "unread_yes"
     And I select "one" from "fandom"
      And I press "Find"
    Then I should see "Child3 of Parent" within "#position_1"
      And the page should NOT contain css "#position_2"

    # find a part with a parent with same fandom
    When I am on the homepage
     And I choose "unread_yes"
     And I select "two" from "fandom"
      And I press "Find"
    Then I should see "Parent" within "#position_1"
      And I should see "unread parts" within "#position_1"
      And I should see "Child1 of Parent" within "#position_2"
      And the page should NOT contain css "#position_3"

    # read one of the parts
    When I am on the page with title "Child1"
      And I follow "Rate"
      And I choose "5"
    And I press "Rate"

    When I am on the homepage
    Then I should see "Parent" within "#position_1"
      And I should see "unread parts (2010-01-01)" within "#position_1"
      And I should NOT see today within "#position_1"
      And the page should NOT contain css "#position_2"

    When I follow "Parent"
      And I should see "Child1" within "#position_1"
      And I should see today within "#position_1"

    # read the last part
    When I am on the page with title "Child3"
      And I follow "Rate"
      And I choose "3"
    And I press "Rate"

    When I am on the homepage
    Then I should see "Parent" within "#position_1"
      And I should NOT see "unread" within "#position_1"
      And I should see "2010-01-01" within "#position_1"
      And the page should NOT contain css "#position_2"

    When I am on the page with title "Parent"
      Then I should see "2010-01-01" within ".last_read"
      And I should NOT see "unread" within ".last_read"
      And I should see "two" within ".fandoms"
      And I should see today within "#position_1"
      And I should see "two" within "#position_1"
      And I should see "2010-01-01" within "#position_2"
      And I should see "one" within "#position_2"
      And I should NOT see today within "#position_2"
      And I should see today within "#position_3"
      And I should see "one" within "#position_3"
