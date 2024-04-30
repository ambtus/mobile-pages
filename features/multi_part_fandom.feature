Feature: parts can differ in fandom and authors from siblings

Scenario: add parts with different fandoms
  Given the following pages
    | title  | url                                 | fandoms | type | authors |
    | Parent |                                     |     | Series | |
    | Child1 | http://test.sidrasue.com/long1.html | one | Single | First |
    | Child2 | http://test.sidrasue.com/long2.html | two | Single | Second |
  When I am on the page with title "Child1"
    And I add a parent with title "Parent"
    And I am on the page with title "Child2"
    And I add a parent with title "Parent"
  Then I should see "Parent" within ".title"
    And I should see "one" within ".fandoms"
    And I should see "two" within ".fandoms"
    And I should see "First" within ".authors"
    And I should see "Second" within ".authors"
    And I should see "one" within "#position_1"
    And I should see "two" within "#position_2"
    And I should see "First" within "#position_1"
    And I should see "Second" within "#position_2"
    But I should NOT see "one" within "#position_2"
    And I should NOT see "two" within "#position_1"
    But I should NOT see "First" within "#position_2"
    And I should NOT see "Second" within "#position_1"

Scenario: find a part by fandom or authors
  Given the following pages
    | title  | url                                 | fandoms | type | authors |
    | Parent |                                     |     | Series | |
    | Child1 | http://test.sidrasue.com/long1.html | one | Single | First |
    | Child2 | http://test.sidrasue.com/long2.html | two | Single | Second |
    And I am on the page with title "Child1"
    And I add a parent with title "Parent"
    And I am on the page with title "Child2"
    And I add a parent with title "Parent"
  When I am on the filter page
    And I select "one" from "fandom"
    And I press "Find"
  Then I should see "Child1 of Parent"
    And the page should NOT contain css "#position_2"
  When I am on the filter page
    And I select "Second" from "author"
    And I press "Find"
  Then I should see "Child2 of Parent"
    And the page should NOT contain css "#position_2"
