Feature: basic first
  what: be presented with the page on the homepage
  why: if I've just added a page and want to show up first

  Scenario: Add a page and make it first
    Given the following pages
        | title | url | read_after | add_genre_string |
        | One   | http://test.sidrasue.com/parts/1.html | 2009-01-01 | my genre |
      And I am on the homepage
    Then I should see "One" in ".title"
    When I fill in "page_url" with "http://test.sidrasue.com/parts/2.html"
      And I fill in "page_title" with "Two"
      And I select "my genre"
      And I press "Store"
      And I press "Read First"
    When I am on the homepage
    Then I should see "Two" in ".title"

  Scenario: Find a page and make it first
    Given I have no pages
      And the following pages
        | title | url | read_after |
        | One  | http://test.sidrasue.com/parts/1.html  | 2009-01-01 |
        | Four  | http://test.sidrasue.com/parts/4.html | 2009-01-02 |
      And I am on the homepage
    Then I should see "One" in ".title"
    When I fill in "search" with "Four"
      And I press "Search"
      And I press "Read First"
    When I am on the homepage
    Then I should see "Four" in ".title"

  Scenario: Find a part and make it first
    Given I have no pages
      And the following pages
        | title | urls | read_after |
        | Single  | http://test.sidrasue.com/test.html | 2001-01-01 |
        | Parent | http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html\nhttp://test.sidrasue.com/parts/3.html | 2009-01-02 |
        | Grandparent | #Grandparent\n##Parent1\nhttp://test.sidrasue.com/parts/4.html\n##Parent2\nhttp://test.sidrasue.com/parts/5.html###Subpart1\nhttp://test.sidrasue.com/parts/6.html###Subpart2 | 2009-01-03 |
      And I am on the homepage
    Then I should see "Single" in ".title"
    When I fill in "search" with "part 3"
      And I press "Search"
    Then I should see "Parent" in ".title"
    When I follow "Read" in "#position_3"
    Then I should see "stuff for part 3" in ".content"
    When I press "Read First"
      And I am on the homepage
    Then I should see "Parent" in ".title"
    When I fill in "search" with "Subpart2"
      And I press "Search"
    Then I should see "Grandparent" in ".title"
    When I follow "List Parts" in "#position_2"
      And I follow "Read" in "#position_2"
    Then I should see "stuff for part 6" in ".content"
    When I press "Read First"
      And I am on the homepage
    Then I should see "Grandparent" in ".title"
