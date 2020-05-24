Feature: other mult-part tests

  Scenario: download part
    Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
    When I am on the page's page
      And I view the HTML
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"
    When I am on the homepage
    When I follow "Page 1"
      And I follow "Part 1"
      And I view the HTML
    Then I should see "stuff for part 1"
    And I should not see "stuff for part 2"

  Scenario: reorder the parts on an existing page with parts
    Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/2.html
        http://test.sidrasue.com/parts/1.html
        """
      And I press "Update"
      And I follow "HTML" within "#position_1"
    Then I should see "stuff for part 2"
    When I am on the homepage
      And I follow "Page 1" within "#position_1"
      And I follow "HTML" within "#position_2"
    Then I should see "stuff for part 1"

  Scenario: find a part
    Given the following pages
      | title   | base_url                              | url_substitutions |
      | Parent1 | http://test.sidrasue.com/parts/*.html | 1   |
      | Parent2 | http://test.sidrasue.com/parts/*.html | 2 3 |
     When I am on the homepage
     Then I should see "Parent1" within ".title"
      And I fill in "page_title" with "Part 2"
      And I press "Find"
     Then I should see "Part 2" within ".title"

  Scenario: new parent for an existing page should have the same last read date
    Given the following pages
      | title   | last_read |
      | Single  | 2008-01-01 |
    When I am on the homepage
    Then I should see "Single" within "#position_1"
    And I should see "2008-01-01" within "#position_1"
    When I follow "Single"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" within "#position_1"
    And I should see "2008-01-01" within "#position_1"
