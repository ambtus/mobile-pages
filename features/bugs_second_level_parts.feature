Feature: bugs with second level parts

  Scenario: second layer heirarchy
    Given a page exists with title: "Grandparent", urls: "##Parent1\n##Parent2\nhttp://test.sidrasue.com/parts/3.html\n##Parent3"
    When I am on the homepage
      And I follow "Grandparent" within "#position_1"
      And I follow "Parent2" within "#position_2"
    Then I should see "Part 1" within "#position_1"
      And I should not see "Part 2" 
    When I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/3.html
        http://test.sidrasue.com/parts/4.html
        """
      And I press "Update"
    Then I should see "Parent2" within ".title"
      And I should not see "Could not find or create parent"
      And I should see "Part 1" within "#position_1"
      And I should see "Part 2" within "#position_2"
    When I follow "Grandparent" within ".parent"
    Then I should see "Parent1" within "#position_1"
      And I should see "Parent2" within "#position_2"
      And I should see "Parent3" within "#position_3"
    When I am on the homepage
      And I follow "Rate"
      And I press "1"
   When I am on the homepage
      And I follow "Grandparent" within "#position_1"
      And I follow "Parent2" within "#position_2"
   Then I should not see "unread"
   When I follow "Read" within "#position_2"
   Then I should not see "unread"
