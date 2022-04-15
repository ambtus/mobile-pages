Feature: created order

Scenario: if no pages
  Given I am on the filter page
  When I choose "sort_by_last_created"
    And I press "Find"
  Then I should see "No pages"

Scenario: first created
  Given 2 pages exist
  When I am on the filter page
    And I choose "sort_by_first_created"
    And I press "Find"
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 2" within "#position_2"

Scenario: last created
  Given 2 pages exist
  When I am on the filter page
    And I choose "sort_by_last_created"
    And I press "Find"
  Then I should see "Page 2" within "#position_1"
    And I should see "Page 1" within "#position_2"

Scenario: last created new parent
  Given 2 pages exist
    And I wait 1 second
  When I am on the page with title "Page 2"
    And I follow "Manage Parts"
    And I fill in "add_parent" with "Parent"
    And I press "Update"
  When I am on the filter page
    And I choose "sort_by_last_created"
    And I press "Find"
  Then I should see "Parent" within "#position_1"
    And I should see "Page 2 of Parent" within "#position_2"
    And I should see "Page 1" within "#position_3"

Scenario: last created new part
  Given 2 pages exist
    And I wait 1 second
  When I am on the page with title "Page 2"
    And I follow "Manage Parts"
    And I fill in "url_list" with
    """"
    http://test.sidrasue.com/test1.html
    """"
    And I press "Update"
  When I am on the filter page
    And I choose "sort_by_last_created"
    And I press "Find"
  Then I should see "Part 1 of Page 2" within "#position_1"
    And I should see "Page 2" within "#position_2"
    And I should see "Page 1" within "#position_3"
