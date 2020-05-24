Feature: read_after order

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

  Scenario: Add a page and make it last
    Given a page exists
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
    When I fill in "page_title" with "Page 2"
      And I press "Store"
    When I am on the page with title "Page 1"
      And I press "Read Later"
      Then I should see "Set to Read Later"
      And I should see "Page 2" within "#position_1"
      And I should see "Page 1" within "#position_2"

  Scenario: Read a page and make it first
    Given 2 pages exist
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 2" within "#position_2"
    When I follow "Page 2" within "#position_2"
      And I press "Read Now"
    When I am on the homepage
    Then I should see "Page 2" within "#position_1"
      And I should see "Page 1" within "#position_2"

  Scenario: Read a page and make it last
    Given 2 pages exist
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 2" within "#position_2"
    When I follow "Page 1" within "#position_1"
      And I press "Read Later"
    When I am on the homepage
    Then I should see "Page 2" within "#position_1"
      And I should see "Page 1" within "#position_2"

  Scenario: Read a page and rate it unfinished
    Given 2 pages exist
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 2" within "#position_2"
    When I follow "Page 1" within "#position_1"
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "very sweet"
    And I press "Rate unfinished"
    When I am on the homepage
    Then I should see "Page 2" within "#position_1"
      And I should see "Page 1" within "#position_2"
    When I follow "Page 1" within "#position_2"
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

  Scenario: Find a part or subpart and make it last
    Given I have no pages
      And the following pages
        | title  | urls | read_after |
        | Single |      | 2009-01-03 |
        | Parent | http://test.sidrasue.com/parts/1.html | 2009-01-01 |
        | Grandparent | ##Parent1\n##Parent2\nhttp://test.sidrasue.com/parts/5.html###Subpart | 2009-01-02 |
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

  Scenario: Changing read after orders
    Given 5 pages exist
    When I am on the homepage
    Then I should see "Page 1" within "#position_1"
      And I should see "Page 2" within "#position_2"
      And I should see "Page 3" within "#position_3"
      And I should see "Page 4" within "#position_4"
      And I should see "Page 5" within "#position_5"
    When I follow "Page 1" within "#position_1"
      And I follow "Rate"
    Then I should see "Please rate (converted to years for next suggested read date)"
    When I choose "boring"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "Page 1 set for reading again in 4 years"
      And I should see "Page 2" within "#position_1"
      And I should see "Page 3" within "#position_2"
      And I should see "Page 4" within "#position_3"
      And I should see "Page 5" within "#position_4"
      And I should see "Page 1" within "#position_5"
    When I follow "Page 2" within "#position_1"
      And I follow "Rate"
      And I choose "interesting enough"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "Page 2 set for reading again in 3 years"
      And I should see "Page 3" within "#position_1"
      And I should see "Page 4" within "#position_2"
      And I should see "Page 5" within "#position_3"
      And I should see "Page 2" within "#position_4"
      And I should see "Page 1" within "#position_5"
    When I follow "Page 3" within "#position_1"
      And I follow "Rate"
      And I choose "sweet enough"
      And I choose "boring"
    And I press "Rate"
    Then I should see "Page 3 set for reading again in 3 years"
      And I should see "Page 4" within "#position_1"
      And I should see "Page 5" within "#position_2"
      And I should see "Page 2" within "#position_3"
      And I should see "Page 3" within "#position_4"
      And I should see "Page 1" within "#position_5"
    When I follow "Page 4" within "#position_1"
      And I follow "Rate"
      And I choose "very interesting"
      And I choose "sweet enough"
    And I press "Rate"
    Then I should see "Page 4 set for reading again in 1 years"
      And I should see "Page 5" within "#position_1"
      And I should see "Page 4" within "#position_2"
      And I should see "Page 2" within "#position_3"
      And I should see "Page 3" within "#position_4"
      And I should see "Page 1" within "#position_5"
    When I follow "Page 5" within "#position_1"
      And I follow "Rate"
      And I choose "boring"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "Page 5 set for reading again in 4 years"
      And I should see "Page 4" within "#position_1"
      And I should see "Page 2" within "#position_2"
      And I should see "Page 3" within "#position_3"
      And I should see "Page 1" within "#position_4"
      And I should see "Page 5" within "#position_5"
