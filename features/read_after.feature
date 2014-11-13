Feature: read_after order

  Scenario: Add a page and make it first
    Given a titled page exists
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
    When I fill in "page_title" with "page 2"
      And I press "Store"
    When I go to the page with title "page 2"
      And I press "Read First"
    When I am on the homepage
    Then I should see "page 2" within "#position_1"
      And I should see "page 1" within "#position_2"

  Scenario: Read a page and make it first
    Given 2 titled pages exist
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
      And I should see "page 2" within "#position_2"
    When I follow "page 2" within "#position_2"
      And I press "Read First"
    When I am on the homepage
    Then I should see "page 2" within "#position_1"
      And I should see "page 1" within "#position_2"

  Scenario: Read a page and make it last
    Given 2 titled pages exist
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
      And I should see "page 2" within "#position_2"
    When I follow "page 1" within "#position_1"
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "very sweet"
    And I press "Rate unfinished"
    When I am on the homepage
    Then I should see "page 2" within "#position_1"
      And I should see "page 1" within "#position_2"
    When I follow "page 1" within "#position_2"
      Then I should see "unfinished" within ".favorite"

  Scenario: Find a part or subpart and make it first
    Given I have no pages
      And the following pages
        | title  | urls | read_after |
        | Single |      | 2009-01-01 |
        | Parent | http://test.sidrasue.com/parts/1.html | 2009-01-02 |
        | Grandparent | ##Parent1\n##Parent2\nhttp://test.sidrasue.com/parts/5.html###Subpart | 2009-01-03 |
    When I am on the homepage
    Then I should see "Single" within "#position_1"
      And I should see "Parent" within "#position_2"
      And I should see "Grandparent" within "#position_3"
    When I follow "Parent" within "#position_2"
      And I follow "Part 1" within "#position_1"
      And I press "Read First"
    When I am on the homepage
    And I should see "Parent" within "#position_1"
    Then I should see "Single" within "#position_2"
    And I should see "Grandparent" within "#position_3"
    When I follow "Grandparent" within "#position_3"
      And I follow "Parent2" within "#position_2"
      And I follow "Subpart" within "#position_1"
    When I press "Read First"
      And I am on the homepage
    Then I should see "Grandparent" within "#position_1"
      And I should see "Parent" within "#position_2"
      And I should see "Single" within "#position_3"

  Scenario: Changing read after orders
    Given 5 titled pages exist
    When I am on the homepage
    Then I should see "page 1 title" within "#position_1"
      And I should see "page 2 title" within "#position_2"
      And I should see "page 3 title" within "#position_3"
      And I should see "page 4 title" within "#position_4"
      And I should see "page 5 title" within "#position_5"
    When I follow "page 1 title" within "#position_1"
      And I follow "Rate"
    Then I should see "Please rate (converted to years for next suggested read date)"
    When I choose "boring"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "page 1 title set for reading again in 4 years"
      And I should see "page 2" within "#position_1"
      And I should see "page 3" within "#position_2"
      And I should see "page 4" within "#position_3"
      And I should see "page 5" within "#position_4"
      And I should see "page 1" within "#position_5"
    When I follow "page 2 title" within "#position_1"
      And I follow "Rate"
      And I choose "interesting enough"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "page 2 title set for reading again in 3 years"
      And I should see "page 3" within "#position_1"
      And I should see "page 4" within "#position_2"
      And I should see "page 5" within "#position_3"
      And I should see "page 2" within "#position_4"
      And I should see "page 1" within "#position_5"
    When I follow "page 3 title" within "#position_1"
      And I follow "Rate"
      And I choose "sweet enough"
      And I choose "boring"
    And I press "Rate"
    Then I should see "page 3 title set for reading again in 3 years"
      And I should see "page 4" within "#position_1"
      And I should see "page 5" within "#position_2"
      And I should see "page 2" within "#position_3"
      And I should see "page 3" within "#position_4"
      And I should see "page 1" within "#position_5"
    When I follow "page 4 title" within "#position_1"
      And I follow "Rate"
      And I choose "very interesting"
      And I choose "sweet enough"
    And I press "Rate"
    Then I should see "page 4 title set for reading again in 1 years"
      And I should see "page 5" within "#position_1"
      And I should see "page 4" within "#position_2"
      And I should see "page 2" within "#position_3"
      And I should see "page 3" within "#position_4"
      And I should see "page 1" within "#position_5"
    When I follow "page 5 title" within "#position_1"
      And I follow "Rate"
      And I choose "boring"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "page 5 title set for reading again in 4 years"
      And I should see "page 4" within "#position_1"
      And I should see "page 2" within "#position_2"
      And I should see "page 3" within "#position_3"
      And I should see "page 1" within "#position_4"
      And I should see "page 5" within "#position_5"

  Scenario: new parent for an existing page should have read after date
    Given the following pages
      | title   | read_after |
      | Single  | 2008-01-01 |
      | Another | 2008-02-01 |
    When I am on the homepage
    Then I should see "Single" within ".title"
    When I follow "Single"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" within ".title"

