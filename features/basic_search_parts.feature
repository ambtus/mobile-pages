Feature: basic search with parts
  what: given the title of a part
  why: if i only remember the part title
  result: be shown the parts page

  Scenario: find the parent of a part
    Given the following pages
      |title    | base_url                 | url_substitutions |
      | Parent1 | http://sidrasue.com/tests/parts/*.html | 1   |
      | Parent2 | http://sidrasue.com/tests/parts/*.html | 2 3 |
     When I am on the homepage
     Then I should see "Parent1" in ".title"
      And I fill in "search" with "Part 2"
      And I press "Search"
     Then I should see "Parent2" in ".title"

  Scenario: find a page with parts
    Given the following pages
      |title    | base_url                 | url_substitutions |
      | Parent1 | http://sidrasue.com/tests/parts/*.html | 1   |
      | Parent2 | http://sidrasue.com/tests/parts/*.html | 2 3 |
     When I am on the homepage
      And I fill in "search" with "Parent2"
      And I press "Search"
     Then I should see "Part 2" in "#position_2"
