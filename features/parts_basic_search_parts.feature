Feature: basic search with parts
  what: given the title of a part
  why: if i only remember the part title
  result: be shown the parts page

  Scenario: find the parent of a part
    Given the following pages
      | title   | base_url                              | url_substitutions |
      | Parent1 | http://test.sidrasue.com/parts/*.html | 1   |
      | Parent2 | http://test.sidrasue.com/parts/*.html | 2 3 |
     When I am on the homepage
     Then I should see "Parent1" within ".title"
      And I fill in "page_title" with "Part 2"
      And I press "Find"
     Then I should see "Part 2" within ".title"
