Feature: reset read_after order

Scenario: Add a page and make it first
  Given a page exists
  When I am on the homepage
    And I fill in "page_title" with "Page 2"
    And I press "Store"
    And I press "Read Now"
  Then I should see "Set to Read Now"
    And I should see "Page 2" within "#position_1"
    And I should see "Page 1" within "#position_2"

Scenario: verify created date
  Given a page exists
  When I am on the homepage
    And I fill in "page_title" with "Page 2"
    And I press "Store"
    And I press "Read Now"
    And I choose "sort_by_first_created"
    And I press "Find"
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 2" within "#position_2"

Scenario: Read a page and make it first
  Given 2 pages exist
  When I am on the homepage
    And I follow "Page 2" within "#position_2"
    And I press "Read Now"
  Then I should see "Page 2" within "#position_1"
    And I should see "Page 1" within "#position_2"

Scenario: verify created date
  Given 2 pages exist
  When I am on the homepage
    And I follow "Page 2" within "#position_2"
    And I press "Read Now"
    And I choose "sort_by_first_created"
    And I press "Find"
  Then I should see "Page 1" within "#position_1"
    And I should see "Page 2" within "#position_2"

Scenario: check created date before read now test
  Given I have a single with read_after "2008-01-01"
    And I have a series with read_after "2009-01-02"
    And I have a book with read_after "2008-01-02"
  When I am on the homepage
    And I choose "sort_by_first_created"
    And I press "Find"
  Then I should see "Single" within "#position_1"
    And I should see "Grandparent" within "#position_2"
    And I should see "Parent" within "#position_3"

Scenario: check read after before read now test
  Given I have a single with read_after "2008-01-01"
    And I have a series with read_after "2009-01-02"
    And I have a book with read_after "2008-01-02"
  When I am on the homepage
  Then I should see "Single" within "#position_1"
    And I should see "Parent" within "#position_2"
    And I should see "Grandparent" within "#position_3"

Scenario: Find a part and make its parent first
  Given I have a single with read_after "2008-01-01"
    And I have a series with read_after "2009-01-02"
    And I have a book with read_after "2008-01-02"
  When I am on the page with title "Part 1"
    And I press "Read Now"
  Then I should see "Parent" within "#position_1"
    And I should see "Single" within "#position_2"
    And I should see "Grandparent" within "#position_3"

Scenario: Find a subpart and make its grandparent first
  Given I have a single with read_after "2008-01-01"
    And I have a series with read_after "2009-01-02"
    And I have a book with read_after "2008-01-02"
  When I am on the page with title "Subpart"
    And I press "Read Now"
  Then I should see "Grandparent" within "#position_1"
    And I should see "Single" within "#position_2"
    And I should see "Parent" within "#position_3"
