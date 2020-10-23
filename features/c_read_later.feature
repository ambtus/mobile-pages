Feature: read_after order

  Scenario: Add a page and make it last
    Given I have no pages
    And a page exists
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
    When I fill in "page_title" with "Page 2"
      And I press "Store"
    When I am on the page with title "Page 1"
      And I press "Read Later"
      Then I should see "Set to Read Later"
      And I should see "Page 2" within "#position_1"
      And I should see "Page 1" within "#position_2"

  Scenario: Read a page and make it last
    Given I have no pages
    And 2 pages exist
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 2" within "#position_2"
    When I follow "Page 1" within "#position_1"
      And I press "Read Later"
    When I am on the homepage
    Then I should see "Page 2" within "#position_1"
      And I should see "Page 1" within "#position_2"

  Scenario: Find a part or subpart and make it last
    Given I have no pages
      And the following pages
        | title  | urls | read_after |
        | Single |      | 2009-01-03 |
        | Parent | http://test.sidrasue.com/parts/1.html | 2009-01-01 |
        | Grandparent | ##Parent1,##Parent2,http://test.sidrasue.com/parts/5.html###Subpart | 2009-01-02 |
    When I am on the homepage
    Then I should see "Single" within "#position_3"
      And I should see "Parent" within "#position_1"
      And I should see "Grandparent" within "#position_2"
    When I follow "Parent" within "#position_1"
      And I follow "Part 1" within "#position_1"
      And I press "Read Later"
    When I am on the homepage
    And I should see "Parent" within "#position_3"
    Then I should see "Single" within "#position_2"
    And I should see "Grandparent" within "#position_1"
    When I follow "Grandparent" within "#position_1"
      And I follow "Parent2" within "#position_2"
      And I follow "Subpart" within "#position_1"
    When I press "Read Later"
      And I am on the homepage
    Then I should see "Grandparent" within "#position_3"
      And I should see "Parent" within "#position_2"
      And I should see "Single" within "#position_1"

