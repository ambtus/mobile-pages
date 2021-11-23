Feature: read_after order (also checking first_created)

  Scenario: Add a page and make it first
    Given a page exists
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
    When I fill in "page_title" with "Page 2"
      And I press "Store"
    When I am on the page with title "Page 2"
      And I press "Read Now"
      Then I should see "Set to Read Now"
      And I should see "Page 2" within "#position_1"
      And I should see "Page 1" within "#position_2"
    When I choose "sort_by_first_created"
      And I press "Find"
    Then I should see "Page 1" within "#position_1"

  Scenario: Read a page and make it first
    Given I have no pages
    And 2 pages exist
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 2" within "#position_2"
    When I follow "Page 2" within "#position_2"
      And I press "Read Now"
    When I am on the homepage
    Then I should see "Page 2" within "#position_1"
      And I should see "Page 1" within "#position_2"
    When I choose "sort_by_first_created"
      And I press "Find"
    Then I should see "Page 1" within "#position_1"

  Scenario: Find a part or subpart and make it first
    Given I have no pages
      And I have a series with read_after "2009-01-03"
      And the following pages
        | title  | urls | read_after |
        | Single |      | 2009-01-01 |
        | Parent | http://test.sidrasue.com/parts/1.html | 2009-01-02 |
    When I am on the homepage
    Then I should see "Single" within "#position_1"
      And I should see "Parent" within "#position_2"
      And I should see "Grandparent" within "#position_3"
    When I follow "Parent" within "#position_2"
      And I follow "Part 1" within "#position_1"
      And I press "Read Now"
    When I am on the homepage
    And I should see "Parent" within "#position_1"
    Then I should see "Single" within "#position_2"
    And I should see "Grandparent" within "#position_3"
    When I follow "Grandparent" within "#position_3"
      And I follow "Parent2" within "#position_2"
      And I follow "Subpart" within "#position_1"
    When I press "Read Now"
      And I am on the homepage
    Then I should see "Grandparent" within "#position_1"
      And I should see "Parent" within "#position_2"
      And I should see "Single" within "#position_3"
    When I choose "sort_by_first_created"
      And I press "Find"
    Then I should see "Grandparent" within "#position_1"

