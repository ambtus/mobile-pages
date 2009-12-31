Feature: basic edit of parts
  What: edit the parts of an existing page
  Why: to add, remove or rearrange the order of parts
  result: an updated page with the changed parts

  Scenario: add a new part to an existing page with parts
    Given the following page
      | title  | base_url               | url_substitutions |
      | multi  | http://sidrasue.com/tests/parts/*.html | 1 |
    When I am on the homepage
      And I follow "Read"
      And I follow "Manage Parts"
      And I fill in "url_list" with lines "http://sidrasue.com/tests/parts/1.html\nhttp://sidrasue.com/tests/parts/2.html"
      And I press "Update"
    Then I should see "Part 2"
      And I should see "Part 1"
    When I follow "Read"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: remove a part from an existing page with parts
    Given the following page
      | title  | base_url               | url_substitutions |
      | multi  | http://sidrasue.com/tests/parts/*.html | 1 2 3 |
    When I am on the homepage
      And I follow "Read"
      And I follow "Manage Parts"
      And I fill in "url_list" with lines "http://sidrasue.com/tests/parts/2.html\nhttp://sidrasue.com/tests/parts/3.html"
      And I press "Update"
      And I should not see "Part 3"
      And I follow "Read"
    Then I should not see "stuff for part 1"
      But I should see "stuff for part 2"
      And I should see "stuff for part 3"

  Scenario: reorder the parts on an existing page with parts
    Given the following page
      | title  | base_url               | url_substitutions |
      | multi  | http://sidrasue.com/tests/parts/*.html | 1 2 |
    When I am on the homepage
      And I follow "Read"
      And I follow "Manage Parts"
      And I fill in "url_list" with lines "http://sidrasue.com/tests/parts/2.html\nhttp://sidrasue.com/tests/parts/1.html"
      And I press "Update"
      And I follow "Read" in "#position_1"
    Then I should see "stuff for part 2"
    When I am on the homepage
      And I follow "List Parts"
      And I follow "Read" in "#position_2"
    Then I should see "stuff for part 1"
