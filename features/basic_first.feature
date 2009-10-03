Feature: basic first
  what: be presented with the page on the homepage
  why: if I've just added a page and want to show up first

  Scenario: Add a page and make it first
    Given I have no pages
      And the following page
        | title | urls | read_after |
        | Multi | http://sidrasue.com/tests/parts/1.html | 2007-01-01 |
        | Test  | http://sidrasue.com/tests/parts/4.html | 2007-02-01 |
      And I am on the homepage
    When I fill in "page_url" with "http://sidrasue.com/tests/parts/2.html"
      And I fill in "page_title" with "new page"
      And I press "Store"
      And I press "Read First"
    When I am on the homepage
    Then I should see "new page" in ".title"

  Scenario: Find a page and make it first
    Given I have no pages
      And the following pages
        | title | urls | read_after |
        | Multi | http://sidrasue.com/tests/parts/1.html\nhttp://sidrasue.com/tests/parts/2.html | 2009-01-01 |
        | Test  | http://sidrasue.com/tests/parts/4.html | 2007-02-01 |
      And I am on the homepage
    When I fill in "search" with "Multi"
      And I press "Search"
      And I press "Read First"
    When I am on the homepage
    Then I should see "Multi" in ".title"

  Scenario: Find a part and make it first
    Given I have no pages
      And the following pages
        | title | urls | read_after |
        | Test  | http://sidrasue.com/tests/parts/4.html | 2007-02-01 |
        | Multi | http://sidrasue.com/tests/parts/1.html\nhttp://sidrasue.com/tests/parts/2.html\nhttp://sidrasue.com/tests/parts/3.html | 2009-01-01 |
        | MultiLevel | #Added Part Grandparent\n##Parent1\nhttp://sidrasue.com/tests/parts/4.html\n##Parent2\nhttp://sidrasue.com/tests/parts/5.html###Subpart1\nhttp://sidrasue.com/tests/parts/6.html###Subpart2 | 2009-01-01 |
      And I am on the homepage
    Then I should see "Test" in ".title"
    When I fill in "search" with "part 3"
      And I press "Search"
    Then I should see "Multi" in ".title"
    When I follow "Read" in "#position_3"
      And I press "Read First"
    When I am on the homepage
    Then I should see "Multi" in ".title"
    When I fill in "search" with "Subpart2"
      And I press "Search"
    Then I should see "Grandparent" in ".title"
    When I follow "Read" in "#position_2"
      And I follow "Read" in "#position_2"
      And I press "Read First"
    When I am on the homepage
    Then I should see "Grandparent" in ".title"
