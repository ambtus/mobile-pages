Feature: composite rating made up of sweet and interesting.

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

  Scenario: find either shouldn't get unread
    Given a page exists with title: "Page 1" AND url: "http://test.sidrasue.com/parts/1.html"
      And a page exists with title: "Page 2" AND url: "http://test.sidrasue.com/parts/2.html" AND last_read: "2002-01-02" AND favorite: "1"
      And a page exists with title: "Page 3" AND url: "http://test.sidrasue.com/parts/3.html" AND last_read: "2003-01-02" AND favorite: "2"
    When I am on the homepage
      And I choose "favorite_either"
      And I press "Find"
    Then I should not see "Page 1"
      And I should see "Page 2"
      And I should see "Page 3"

  Scenario: find neither shouldn't get favorite or good
    Given a page exists with url: "http://test.sidrasue.com/parts/1.html" AND last_read: "2001-01-02" AND favorite: 0
      And a page exists with title: "Page 2" AND url: "http://test.sidrasue.com/parts/2.html" AND last_read: "2002-01-02" AND favorite: "1"
      And a page exists with title: "Page 3" AND url: "http://test.sidrasue.com/parts/3.html" AND last_read: "2003-01-02" AND favorite: "2"
      And a page exists with title: "Page 4" AND url: "http://test.sidrasue.com/parts/4.html" AND last_read: "2004-01-02" AND favorite: "3"
      And a page exists with title: "Page 5" AND url: "http://test.sidrasue.com/parts/5.html" AND last_read: "2004-01-02" AND favorite: "9"
      And a page exists with title: "Page 6" AND url: "http://test.sidrasue.com/parts/6.html"
    When I am on the homepage
      And I choose "favorite_neither"
      And I press "Find"
    Then I should see "Page 4"
      And I should not see "Page 1"
      And I should not see "Page 2"
      And I should not see "Page 3"
      And I should see "Page 5"
      And I should see "Page 6"
