Feature: filter on parts

  Scenario: filter on unread part
    Given the following pages
     | title  | favorite | last_read  | add_genre_string | url |
     | Filler | false    | 2008-01-01 | one              | http://test.sidrasue.com/long.html |
     | Parent | true     | 2009-01-01 | two              | |
    When I am on the homepage
    Then I should see "Filler" in ".title"
      And I should not see "unread" in ".last_read"
      And I should see "long" in ".size"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "Child"
      And I select "one" from "genre"
      And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" in ".title"
      And I should not see "unread" in ".last_read"
      And I should see "unread" in "#position_1"
      And I should see "short" in ".size"
      And I should not see "short" in "#position_1"
      And I should see "two" in ".genres"
      And I should see "one" in "#position_1"
    When I am on the homepage
    Then I should see "Filler" in ".title"
    When I check "unread"
      And I press "Filter"
    Then I should see "Parent" in ".title"
    When I fill in "page_url" with "http://test.sidrasue.com/long.html"
      And I fill in "page_title" with "Child2"
      And I select "one" from "genre"
      And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" in ".title"
      And I should see "long" in ".size"
      And I should not see "long" in "#position_2"
      And I should see "short" in "#position_1"
      And I should not see "two" in "#position_2"
