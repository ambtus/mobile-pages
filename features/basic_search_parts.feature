Feature: find a part
  what: given the title of a part
  why: if i only remember the part title
  result: be shown the parts page

  Scenario: find the parent of a part
    Given I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
      And I fill in "page_url_substitutions" with "1 2"
      And I fill in "page_title" with "Parent Doc"
      And I press "Create"
      And I am on the homepage
      And I fill in "search" with "Part 2"
      And I press "Search"
      And I should see "Part 2"
      And I should see "Parent Doc"
      And I should see "Part 1"
