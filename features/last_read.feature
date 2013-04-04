Feature: last_read (also unread)

  Scenario: after rate an unread page, display it's last read date
    Given a titled page exists
    When I am on the page's page
    Then I should not see ".last_read"
    When I follow "Rate"
      And I choose "dull"
      And I choose "upsetting"
    And I press "Rate"
    # FIXME - this will change every year - test will need updating
    Then I should see "2013" within ".last_read"

  Scenario: after rate a read page, change it's last read date
    Given a titled page exists with last_read: "2008-01-01"
    When I am on the page's page
    Then I should see "2008-01-01" within ".last_read"
    When I follow "Rate"
      And I choose "dull"
      And I choose "upsetting"
    And I press "Rate"
    Then I should not see "2008-01-01" within ".last_read"
    # FIXME - this will change every year - test will need updating
      And I should see "2013" within ".last_read"

  Scenario: add unread part to read parent
    Given a page exists with title: "Multi", urls: "http://test.sidrasue.com/parts/1.html"
      And I am on the homepage
   Then I should see "Multi" within "#position_1"
   Then I should see "unread" within ".last_read"
   When I follow "Rate"
      And I choose "very interesting"
      And I choose "easy"
    And I press "Rate"
   Then I should not see "unread" within ".last_read"
   When I follow "Multi"
     And I follow "Manage Parts"
     And I fill in "url_list" with
       """
       http://test.sidrasue.com/parts/1.html
       http://test.sidrasue.com/parts/2.html
       """
     And I press "Update"
   When I am on the homepage
   Then I should see "Multi" within "#position_1"
     And I should not see "unread" within ".last_read"
   When I follow "Multi" within "#position_1"
     And I follow "Part 1" within "#position_1"
   Then I should not see "unread" within ".last_read"
   When I am on the homepage
   When I follow "Multi"
     And I follow "Part 2" within "#position_2"
   Then I should see "unread" within ".last_read"

   Scenario: add parent to read part
    Given a page exists with title: "Part", last_read: "2009-01-01"
      And I am on the page's page
   Then I should not see "unread" within ".last_read"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" within "#position_1"
   Then I should not see "unread" within "#position_1"

   Scenario: add parent to unread part
    Given a titled page exists
      And I am on the page's page
   Then I should see "unread" within ".last_read"
   When I follow "Manage Parts"
     And I fill in "add_parent" with "Parent"
     And I press "Update"
   When I am on the homepage
   Then I should see "Parent" within "#position_1"
   Then I should see "unread" within "#position_1"

  Scenario: unread part
    Given I have no pages
    Given the following pages
     | title  | last_read  | url   | add_genres_from_string |
     | Filler | 2008-01-01 | http://test.sidrasue.com/long.html | one |
     | Parent | 2009-01-01 |       | two |
    When I am on the homepage
    Then I should see "Filler" within ".title"
      And I should not see "unread" within ".last_read"
      And I should see "medium" within ".size"
    When I fill in "page_url" with "http://test.sidrasue.com/test.html"
      And I fill in "page_title" with "Child"
      And I select "one" from "Genre"
      And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent"
      And I should not see "Parent with that title has content"
      And I should not see "unread" within ".last_read"
      And I should see "unread" within "#position_1"
      And I should see "short" within ".size"
      And I should not see "short" within "#position_1"
      And I should see "two" within ".genres"
      And I should see "one" within "#position_1"
    When I am on the homepage
    Then I should see "Filler" within ".title"
    When I choose "unread_yes"
      And I press "Find"
      # no longer find unread parts...
    Then I should not see "Parent"
    When I fill in "page_url" with "http://test.sidrasue.com/long2.html"
      And I fill in "page_title" with "Child2"
      And I select "one" from "Genre"
      And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should see "medium" within ".size"
      And I should not see "medium" within "#position_2"
      And I should see "short" within "#position_1"
      And I should not see "two" within "#position_2"
      And I should see "one" within "#position_2"
    When I am on the homepage
      And I select "one" from "Genre"
      And I press "Find"
    Then I should see "Filler"
      And I should not see "Parent"

  Scenario: new parent for an existing page should have last read date
    Given a page exists with title: "Single", last_read: "2008-01-01"
    When I am on the page's page
    Then I should see "2008-01-01" within ".last_read"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    Then I should see "New Parent" within ".title"
      And I should see "Single" within "#position_1"
      And I should see "2008-01-01" within ".last_read"

   Scenario: rate a part marks parent read but not siblings
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2 3"
   When I am on the page's page
   Then I should see "unread" within ".last_read"
   When I follow "Part 1" within "#position_1"
     And I follow "Rate"
      And I choose "very interesting"
      And I choose "very sweet"
     And I press "Rate"
   When I am on the page's page
   Then I should not see "unread" within ".last_read"
     And I should not see "unread" within "#position_1"
     But I should see "unread" within "#position_2"
     And I should see "unread" within "#position_3"
  When I follow "Part 2" within "#position_2"
     And I follow "Rate"
      And I choose "good"
      And I choose "easy"
     And I press "Rate"
   When I am on the page's page
   Then I should not see "unread" within ".last_read"
     And I should not see "unread" within "#position_1"
     And I should not see "unread" within "#position_2"
     But I should see "unread" within "#position_3"
