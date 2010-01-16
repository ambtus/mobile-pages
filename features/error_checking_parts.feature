Feature: error checking with parts

  Scenario: can't add a page to an ambiguous parent
    Given the following pages
      | title     | urls |
      | Ambiguous | http://test.sidrasue.com/parts/1.html |
      | Another Ambiguous | http://test.sidrasue.com/parts/2.html |
    And the page
      | title  | url |
      | Single | http://test.sidrasue.com/test.html |
    When I am on the homepage
      And I fill in "search" with "Single"
      And I press "Search"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Ambiguous"
      And I press "Update"
    Then I should see "More than one page with that title"
      And I should not see "Another Ambiguous" in ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Another Ambiguous"
      And I press "Update"
    Then I should see "Another Ambiguous" in ".title"
      And I should see "Single" in "#position_2"

  Scenario: can't add a part to a page with content
    Given the following pages
      | title  | url |
      | Single | http://test.sidrasue.com/test.html |
      | Styled | http://test.sidrasue.com/styled.html |
    When I am on the homepage
    Then I should see "Single" in ".title"
    When I follow "Read"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Styled"
      And I press "Update"
    Then I should see "Parent with that title has content"
      And I should not see "Styled" in ".title"

  Scenario: ignore empty lines
    Given I have no pages
      And the following genre
        | name |
        | my genre |
      And I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with lines "##Child 1\n\nhttp://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html\n\nhttp://test.sidrasue.com/parts/3.html##Child 2\n\n"
     And I fill in "page_title" with "Parent"
     And I select "my genre"
     And I press "Store"
   Then I should see "Parent" in ".title"
     And I should see "Child 1" in "h1"
     And I should see "Child 2" in "h1"
     And I should not see "Part 3"
     And I should see "stuff for part 1"
     And I should see "stuff for part 2"
     And I should see "stuff for part 3"

  Scenario: add a part to a page with content (second way)
    Given the following pages
      | title  | url |
      | Single | http://test.sidrasue.com/test.html |
    When I am on the homepage
      And I follow "Read"
      And I follow "Manage Parts"
      And I fill in "url_list" with lines "http://test.sidrasue.com/test.html\nhttp://test.sidrasue.com/styled.html"
      And I press "Update"
    Then I should see "Single" in ".parent"
    When I am on the homepage
      And I follow "List Parts"
    Then I should see "Part 1" in "#position_1"
      And I should see "Part 2" in "#position_2"

  Scenario: single part stories shouldn't have parts link
    Given the following page
      | title  | url |
      | Single | http://test.sidrasue.com/test.html |
    When I am on the homepage
    Then I should not see "List Parts" in ".title"
    When I follow "Read"
    Then I should not see "List Parts" in ".title"
    
  Scenario: download part
    Given I have no pages
      And the following page
      | title | urls |
      | Parent | http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html |
    When I am on the homepage
      And I follow "List Parts"
      And I follow "Download" in "#position_1"
    Then I should see "stuff for part 1"
    And I should not see "stuff for part 2"
