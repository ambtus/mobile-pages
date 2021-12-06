Feature: last created

  Scenario: find last created page if no pages
    Given I have no pages
    When I am on the homepage
    When I choose "sort_by_last_created"
      And I press "Find"
    Then I should see "No pages"

  Scenario: find first and last created pages
    When I am on the homepage
      And I fill in "page_title" with "Page 1"
      And I press "Store"
      And I wait 1 second
    When I am on the homepage
      And I fill in "page_title" with "Page 2"
      And I press "Store"
      And I wait 1 second
    When I am on the homepage
      And I fill in "page_url" with "http://test.sidrasue.com/test1.html"
      And I fill in "page_title" with "New Title"
      And I press "Store"

    When I am on the homepage
      And I choose "sort_by_first_created"
      And I press "Find"
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 2" within "#position_2"
      And I should see "New Title" within "#position_3"

    When I choose "sort_by_last_created"
      And I press "Find"
    Then I should see "New Title" within "#position_1"
      And I should see "Page 2" within "#position_2"
      And I should see "Page 1" within "#position_3"

    When I follow "New Title"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    When I am on the homepage
      And I choose "sort_by_last_created"
      And I press "Find"
    Then I should see "Parent" within "#position_1"

    When I follow "Parent"
      And I wait 1 second
      And I follow "Manage Parts"
      And I fill in "url_list" with
      """"
      http://test.sidrasue.com/test1.html
      http://test.sidrasue.com/test2.html
      """"
      And I press "Update"
    When I am on the homepage
      And I choose "sort_by_last_created"
      And I press "Find"
    Then I should see "Part 2 of Parent" within "#position_1"
      And I should see "Page 1" within "#position_5"
