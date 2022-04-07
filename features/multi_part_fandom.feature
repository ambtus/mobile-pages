Feature: parts differ in fandom from parent

Scenario: add part with same fandoms
  Given the following pages
    | title  | url                                 | fandoms |
    | Parent |                                     | two |
    | Child1 | http://test.sidrasue.com/long1.html | two |
    | Child2 | http://test.sidrasue.com/long2.html | one |
  When I am on the page with title "Child1"
    And I follow "Manage Parts"
    And I fill in "add_parent" with "Parent"
    And I press "Update"
  Then I should see "Parent" within ".title"
    And I should see "two" within ".fandoms"
    ##FIXME - remove duplicate tags when adding parent
    #But I should NOT see "two" within "#position_1"

Scenario: add part with different fandoms
  Given the following pages
    | title  | url                                 | fandoms |
    | Parent |                                     | two |
    | Child1 | http://test.sidrasue.com/long1.html | two |
    | Child2 | http://test.sidrasue.com/long2.html | one |
  When I am on the page with title "Child2"
    And I follow "Manage Parts"
    And I fill in "add_parent" with "Parent"
    And I press "Update"
  Then I should see "Parent" within ".title"
    And I should see "two" within ".fandoms"
    And I should see "one" within "#position_1"

Scenario: find a part with a parent with different fandom
  Given the following pages
    | title  | url                                 | fandoms |
    | Parent |                                     | two |
    | Child1 | http://test.sidrasue.com/long1.html | two |
    | Child2 | http://test.sidrasue.com/long2.html | one |
  When I am on the page with title "Child2"
    And I follow "Manage Parts"
    And I fill in "add_parent" with "Parent"
    And I press "Update"
    And I am on the homepage
    And I choose "unread_any"
    And I select "one" from "fandom"
    And I press "Find"
  Then I should see "Child2 of Parent" within "#position_1"
    And the page should NOT contain css "#position_2"

Scenario: find a part with a parent with same fandom
  Given the following pages
    | title  | url                                 | fandoms |
    | Parent |                                     | two |
    | Child1 | http://test.sidrasue.com/long1.html | two |
    | Child2 | http://test.sidrasue.com/long2.html | one |
  When I am on the page with title "Child1"
    And I follow "Manage Parts"
    And I fill in "add_parent" with "Parent"
    And I press "Update"
    And I am on the homepage
    And I choose "unread_any"
    And I select "two" from "fandom"
    And I press "Find"
  Then I should see "Parent" within "#position_1"
    And I should see "Child1 of Parent" within "#position_2"
    And the page should NOT contain css "#position_3"
