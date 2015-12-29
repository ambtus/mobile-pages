Feature: composite rating made up of sweet and interesting.

  Scenario: new rating page
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
    Then I should see "very interesting"
      And I should see "interesting"
      And I should see "boring"
    Then I should see "very sweet"
      And I should see "sweet"
      And I should see "stressful"

  Scenario: error if don't select both before rating
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
    And I press "Rate"
    Then I should see "You must select both ratings"

  Scenario: rate unfinished
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "stressful"
      And I choose "boring"
    And I press "Rate unfinished"
    Then I should not see "set for reading again"
      And I should see "set to 'unfinished'"
    When I am on the page's page
    Then I should see "boring, stressful, unfinished"

  Scenario: rate a book 0 best
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 6 months"
    When I am on the page's page
    Then I should see "favorite, interesting, sweet"

  Scenario: rate a book 1 very sweet
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "interesting enough"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 1 years"
    When I am on the page's page
    Then I should see "favorite, sweet"

  Scenario: rate a book 1 very interesting
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "sweet enough"
    And I press "Rate"
    Then I should see "set for reading again in 1 years"
    When I am on the page's page
    Then I should see "favorite, interesting"

  Scenario: rate a book 2
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "sweet enough"
      And I choose "interesting enough"
    And I press "Rate"
    Then I should see "set for reading again in 2 years"
    When I am on the page's page
    Then I should see "good"

  Scenario: rate a book 2 stressful but very interesting
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "set for reading again in 2 years"
    When I am on the page's page
    Then I should see "good, interesting, stressful"

  Scenario: rate a book 2 boring but very sweet
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "boring"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 2 years"
    When I am on the page's page
    Then I should see "boring, good, sweet"

  Scenario: rate a book 3 boring
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "boring"
      And I choose "sweet enough"
    And I press "Rate"
    Then I should see "set for reading again in 3 years"
    When I am on the page's page
    Then I should see "boring"

  Scenario: rate a book 3 stressful
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "interesting enough"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "set for reading again in 3 years"
    Then I should see "stressful"

  Scenario: rate a book 4 worst
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "boring"
      And I choose "stressful"
    And I press "Rate"
    Then I should see "set for reading again in 4 years"
    When I am on the page's page
    Then I should see "boring, stressful"

  Scenario: search for a favorite book
    Given pages with all possible ratings exist
      And I am on the homepage
    When I choose "favorite_yes"
      And I press "Find"
    Then I should see "page00"
      And I should see "page01"
    But I should not see "page02"
      And I should not see "page03"
    Then I should see "page10"
    But I should not see "page11"
      And I should not see "page12"
      And I should not see "page13"
      And I should not see "page2"
      And I should not see "page3"

  Scenario: search for a with low stress
    Given pages with all possible ratings exist
      And I am on the homepage
    When I choose "find_sweet"
      And I press "Find"
    Then I should see "page20"
    But I should not see "page02"

  Scenario: search for interesting
    Given pages with all possible ratings exist
      And I am on the homepage
    When I choose "find_interesting"
      And I press "Find"
    Then I should see "page02"
    But I should not see "page20"

  Scenario: search for a book with both low stress & high interest
    Given pages with all possible ratings exist
      And I am on the homepage
    When I choose "find_both"
      And I press "Find"
    Then I should see "page00" within "#position_1"
    But I should not see "page01"
      And I should not see "page10"
      And I should not see "page11"
      And I should not see "page20"
      And I should not see "page22"

  Scenario: rate part only
    Given the following pages
      | title  | base_url                              | url_substitutions |
      | Parent | http://test.sidrasue.com/parts/*.html | 1 2 |
    When I am on the homepage
      And I follow "Parent"
      And I follow "Part 1"
      And I follow "Rate"
      And I choose "very interesting"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 6 months"
    When I follow "Parent"
      And I follow "Part 2"
      And I follow "Rate"
      And I choose "stressful"
      And I choose "boring"
    And I press "Rate part"
    Then I should see "Parent reading date unchanged"
    And I should see "favorite, interesting, sweet"
    When I follow "Parent"
      And I follow "Part 2"
      Then I should see "boring, stressful"

  Scenario: find either shouldn't get unread
    Given a page exists with title: "page 1", url: "http://test.sidrasue.com/parts/1.html"
      And a page exists with title: "page 2", url: "http://test.sidrasue.com/parts/2.html", last_read: "2002-01-02", favorite: 1
      And a page exists with title: "page 3", url: "http://test.sidrasue.com/parts/3.html", last_read: "2003-01-02", favorite: 2
    When I am on the homepage
      And I choose "favorite_either"
      And I press "Find"
    Then I should not see "page 1"
      And I should see "page 2"
      And I should see "page 3"

  Scenario: find neither shouldn't get favorite or good
    Given a page exists with title: "page 1", url: "http://test.sidrasue.com/parts/1.html", last_read: "2001-01-02", favorite: 0
      And a page exists with title: "page 2", url: "http://test.sidrasue.com/parts/2.html", last_read: "2002-01-02", favorite: 1
      And a page exists with title: "page 3", url: "http://test.sidrasue.com/parts/3.html", last_read: "2003-01-02", favorite: 2
      And a page exists with title: "page 4", url: "http://test.sidrasue.com/parts/4.html", last_read: "2004-01-02", favorite: 3
      And a page exists with title: "page 5", url: "http://test.sidrasue.com/parts/5.html", last_read: "2004-01-02", favorite: 9
      And a page exists with title: "page 6", url: "http://test.sidrasue.com/parts/6.html"
    When I am on the homepage
      And I choose "favorite_neither"
      And I press "Find"
    Then I should see "page 4"
      And I should not see "page 1"
      And I should not see "page 2"
      And I should not see "page 3"
      And I should see "page 5"
      And I should see "page 6"
