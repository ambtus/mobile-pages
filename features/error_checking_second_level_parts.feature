Feature: error checking second level parts

  Scenario: second layer heirarchy
    Given the following page
      | title | urls |
      | Grandparent | ##Parent1\nhttp://sidrasue.com/tests/parts/1.html\nhttp://sidrasue.com/tests/parts/2.html\n##Parent2\nhttp://sidrasue.com/tests/parts/3.html\nhttp://sidrasue.com/tests/parts/4.html\n##Parent3\nhttp://sidrasue.com/tests/parts/7.html |
    When I am on the homepage
      And I follow "List Parts"
      And I follow "List Parts" in "#position_2"
      And I follow "Manage Parts"
    When I fill in "url_list" with lines "http://sidrasue.com/tests/parts/3.html\nhttp://sidrasue.com/tests/parts/4.html2\nhttp://sidrasue.com/tests/parts/5.html"
      And I press "Update"
    Then I should see "Parent2" in ".title"
      When I follow "Grandparent"
    Then I should see "Parent1" in "#position_1"
      And I should see "Parent2" in "#position_2"
      And I should see "Parent3" in "#position_3"
