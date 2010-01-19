Feature: basic first
  what: be presented with the page on the homepage
  why: if I've just added a page and want to show up first

  Scenario: Add a page and make it first
    Given a genre exists with name: "genre"
    Given a titled page exists
    When I am on the homepage
    Then I should see "1" in ".title"
    When I fill in "page_title" with "2"
      And I select "genre"
      And I press "Store"
      And I press "Read First"
    When I am on the homepage
    Then I should see "2" in ".title"

  Scenario: Find a page and make it first
    Given 2 titled pages exist
    When I am on the homepage
    Then I should see "1" in ".title"
    When I fill in "search" with "2"
      And I press "Search"
      And I press "Read First"
    When I am on the homepage
    Then I should see "2" in ".title"

  Scenario: Find a part and make it first
    Given I have no pages
      And the following pages
        | title  | urls | read_after |
        | Single |      | 2001-01-01 |
        | Parent | http://test.sidrasue.com/parts/1.html | 2009-01-02 |
        | Grandparent | ##Parent1\n##Parent2\nhttp://test.sidrasue.com/parts/5.html###Subpart | 2009-01-03 |
    When I am on the homepage
    Then I should see "Single" in ".title"
    When I fill in "search" with "Parent"
      And I press "Search"
      And I follow "List Parts" in ".title"
      And I follow "Read" in "#position_1"
      And I press "Read First"
    When I am on the homepage
    Then I should see "Parent" in ".title"
    When I fill in "search" with "Grandparent"
      And I press "Search"
      And I follow "List Parts" in "#position_2"
      And I follow "Read" in "#position_1"
    When I press "Read First"
      And I am on the homepage
    Then I should see "Grandparent" in ".title"
