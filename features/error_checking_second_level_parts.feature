Feature: error checking second level parts

  Scenario: second layer heirarchy
    Given the following page
      | title | urls |
      | grandparent | #Grandparent\n##Parent1\nhttp://sidrasue.com/tests/parts/1.html\n##Parent2\nhttp://sidrasue.com/tests/parts/2.html###Subpart1\nhttp://sidrasue.com/tests/parts/3.html###Subpart2 |
    When I am on the homepage
      And I follow "List Parts"
      And I follow "List Parts" in "#position_2"
      And I follow "Manage Parts"
    When I fill in "url_list" with lines "http://sidrasue.com/tests/parts/2.html##Subpart1\nhttp://sidrasue.com/tests/parts/3.html##Subpart2\nhttp://sidrasue.com/tests/parts/4.html##Subpart3"
      And I press "Update"
    Then I should see "Parent2" in ".title"


