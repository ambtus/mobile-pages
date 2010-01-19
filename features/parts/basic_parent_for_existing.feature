Feature: basic parent for existing pages
  What: given an existing part, create a new parent for it
  Why: if the page was a singleton, but a new page needs to be added as a sibling, then a parent page needs to be created to hold them
  Result: a new page with the original part as a child

  Scenario: create a new parent for an existing page
    Given a page exists with title: "Single", url: "http://test.sidrasue.com/test.html" 
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" in ".title"
      And I should see "Single" in "#position_1"
    When I follow "Read" in "#position_1"
    Then I should see "Retrieved from the web"
    Then I follow "Parent" in ".parent"

  Scenario: add an existing page to an existing page with parts
    Given a page exists with title: "Single", url: "http://test.sidrasue.com/parts/3.html"
    And a page exists with title: "Multi", base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
    When I am on the homepage
    Then I should see "Single" in ".title"
    When I follow "Read"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Multi"
      And I press "Update"
    Then I should see "Multi" in ".title"
    And I should see "Part 1" in "#position_1"
      And I should see "Part 2" in "#position_2"
      And I should see "Single" in "#position_3"
    When I follow "Read"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"
      And I should see "stuff for part 3"
