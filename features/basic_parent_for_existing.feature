Feature: give an existing page a parent
  What: given an existing part, create a new parent for it
  Why: if the page was a singleton, but a new page needs to be added as a sibling, then a parent page needs to be created to hold them
  Result: a new page with the original part as a child

  Scenario: create a new parent for an existing page
    Given I am on the homepage
    When I fill in "page_url" with "http://www.rawbw.com/~alice/test.html"
    And I fill in "page_title" with "Single Part"
    And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent Holder Page"
      And I press "Update"
    Then I should see "New Parent Holder Page" in ".title"
      And I should see "Single Part" in "#position_1"
    When I follow "Read" in "#position_1"
    Then I should see "Retrieved from the web"
    When I follow "New Parent Holder Page" in ".parent"
      And I follow "Read" in ".title"
    Then I should see "Retrieved from the web"


  Scenario: add an existing page to a page with parts
    Given I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
     And I fill in "page_url_substitutions" with "1 2"
     And I fill in "page_title" with "Existing Parts One and Two"
     And I press "Store"
    When I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/parts/3.html"
    And I fill in "page_title" with "Special Part Three"
    And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Existing Parts One and Two"
      And I press "Update"
      And I should see "Existing Parts One and Two"
      And I follow "Read"
    Then I should see "Part 1"
      And I should see "stuff for part 1"
      And I should see "Part 2"
      And I should see "stuff for part 2"
      And I should see "Special Part Three"
      And I should see "stuff for part 3"
