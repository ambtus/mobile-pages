Feature: filter on parts

  Scenario: filter on unread part
    Given the following pages
     | title  | favorite | last_read  | add_genre_string | url |
     | Filler | false    | 2008-01-01 | one              | http://test.sidrasue.com/long.html |
     | Parent | true     | 2009-01-01 | two              | |
    When I am on the homepage
    Then I should see "Filler" within ".title"
      And I should not see "unread" within ".last_read"
      And I should see "long" within ".size"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "Child"
      And I select "one" from "Genre"
      And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should not see "unread" within ".last_read"
      And I should see "unread" within "#position_1"
      And I should see "short" within ".size"
      And I should not see "short" within "#position_1"
      And I should see "two" within ".genres"
      And I should see "one" within "#position_1"
    When I am on the homepage
    Then I should see "Filler" within ".title"
    When I select "unread" from "State"
      And I press "Find"
    Then I should see "Parent" within ".parent"
    When I fill in "page_url" with "http://test.sidrasue.com/long2.html"
      And I fill in "page_title" with "Child2"
      And I select "one" from "Genre"
      And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should see "long" within ".size"
      And I should not see "long" within "#position_2"
      And I should see "short" within "#position_1"
      And I should not see "two" within "#position_2"
      And I should see "one" within "#position_2"
    When I am on the homepage
      And I select "one" from "Genre"
      And I press "Find"
    Then I should see "Filler"
      And I should not see "Parent"
