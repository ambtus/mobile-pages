Feature: rating parts of a parent

Scenario: check before rate part
  Given a page exists with title: "Parent" AND base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-2"
  Then the read after date should be 0 years from now

Scenario: rate one part leaves parent read after unchanged
  Given a page exists with title: "Parent" AND base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-2"
  When I am on the homepage
    And I follow "Parent"
    And I follow "Part 1"
    And I follow "Rate"
    And I click on "4"
    And I press "Rate"
  Then the read after date should be 0 years from now

Scenario: rate both parts changes parent read after date based on best part
  Given a page exists with title: "Parent" AND base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1-2"
  When I am on the homepage
    And I follow "Parent"
    And I follow "Part 1"
    And I follow "Rate"
    And I click on "4"
    And I press "Rate"
    And I follow "Parent"
    And I follow "Part 2"
    And I follow "Rate"
    And I click on "1"
    And I press "Rate"
  Then the read after date should be 1 years from now

Scenario: rating a single unread child sets parent AND grandparent to read
  Given a page exists with title: "Parent" AND urls: "http://test.sidrasue.com/parts/1.html" AND last_read: "2009-01-01"
  When I am on the page with title "Parent"
    And I add a parent with title "Grandparent"
    And I am on the page with title "Parent"
    And I follow "Add Part"
    And I fill in "add_url" with "http://test.sidrasue.com/parts/2.html"
    And I press "Add"
    And I am on the page with title "Part 2"
    And I follow "Rate"
    And I click on "3"
    And I press "Rate"
    And I am on the page with title "Grandparent"
  Then I should NOT see "unread"
    But I should see "2009-01-01"

Scenario: rating all unrated
  Given a series exists
  When I am on the page's page
    And I follow "Rate"
  Then "Unrated Parts" should be checked

Scenario: rating all unrated
  Given a series exists
  When I am on the page's page
    And I follow "Rate"
    And I click on "3"
    And I press "Rate"
  Then all pages should be rated 3

Scenario: rate all up to now
  Given a book exists
  When I am on the page with title "chapter 3"
    And I follow "Rate"
    And I click on "3"
    And I click on "all_previous"
    And I press "Rate"
    And I am on the page's page
  Then I should see "3 unread parts"
    And I should see "unread" within "#position_4"
    And I should see "unread" within "#position_5"
    And I should NOT see "unread" within "#position_1"
    And I should NOT see "unread" within "#position_2"
    And I should NOT see "unread" within "#position_3"

Scenario: rate all unrated up to now
  Given a partially read book exists
  When I am on the page with title "chapter 4"
    And I follow "Rate"
    And I click on "3"
    And I click on "all_previous"
    And I press "Rate"
    And I am on the page's page
  Then I should see "2 unread parts"
  Then show me the page
    And I should NOT see "unread" within "#position_1"
    But I should see "2009" within "#position_1"
    And I should NOT see "unread" within "#position_2"
    But I should see "2010" within "#position_2"
    And I should NOT see "unread" within "#position_3"
    And I should NOT see "unread" within "#position_4"
    And I should see "unread" within "#position_5"
