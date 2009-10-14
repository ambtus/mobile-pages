Feature: basic second level parts
  What: would like to be able to have a part of a part
  Why: a series of pages, grouped together as a single page, each of which has parts
  Result: 2nd level heirarchy

  Scenario: second layer heirarchy
    Given the following page
      | title  | urls |
      | Parent | http://sidrasue.com/tests/parts/2.html\nhttp://sidrasue.com/tests/parts/3.html |
    And the page
      | title   | url |
      | Single | http://sidrasue.com/tests/parts/1.html |
    When I am on the homepage
    Then I should see "Parent" in ".title"
    When I follow "Read"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Grandparent"
      And I fill in "url_list" with "http://sidrasue.com/tests/parts/2.html\nhttp://sidrasue.com/tests/parts/3.html"
      And I press "Update"
    Then I should see "Grandparent"
      And I should see "Parent" in "#position_1"
    When I am on the homepage
      And I fill in "search" with "Single"
      And I press "Search"
      Then I should see "Single" in ".title"
     When I follow "Manage Parts"
      And I fill in "add_parent" with "Grandparent"
      And I press "Update"
    Then I should see "Parent" in "#position_1"
      And I should see "Single" in "#position_2"
    When I follow "Download" in ".title"
    Then I should see "# Single #"
      And I should see "# Parent #"
      And I should see "## Part 1 ##"
      And I should see "## Part 2 ##"
      And I should see "stuff for part 1"
      And I should see "stuff for part 2"
      And I should see "stuff for part 3"



