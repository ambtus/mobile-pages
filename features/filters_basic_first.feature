Feature: basic first
  what: be presented with the page on the homepage
  why: if I've just added a page and want to show up first

  Scenario: Add a page and make it first
    Given a genre exists with name: "genre"
    Given a titled page exists
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
    When I fill in "page_title" with "page 2"
      And I select "genre" from "Genre"
      And I press "Store"
      And I press "Read First"
    When I am on the homepage
    Then I should see "page 2" within "#position_1"
      And I should see "page 1" within "#position_2"

  Scenario: Read a page and make it first
    Given 2 titled pages exist
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
      And I should see "page 2" within "#position_2"
    When I follow "Read" within "#position_2"
      And I press "Read First"
    When I am on the homepage
    Then I should see "page 2" within "#position_1"
      And I should see "page 1" within "#position_2"

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
      And I follow "Read" within "#position_1"
      And I press "Read First"
    When I am on the homepage
    And I should see "Parent" within "#position_1"
    Then I should see "Single" within "#position_2"
    And I should see "Grandparent" within "#position_3"
    When I follow "Grandparent" within "#position_3"
      And I follow "Parent2" within "#position_2"
      And I follow "Read" within "#position_1"
    When I press "Read First"
      And I am on the homepage
    Then I should see "Grandparent" within "#position_1"
      And I should see "Parent" within "#position_2"
      And I should see "Single" within "#position_3"
