Feature: reset read_after order

Scenario: default read after
  Given pages with all possible stars exist
  When I am on the homepage
  Then I should see "page0" within "#position_1"
    And I should see "page5" within "#position_2"
    And I should see "page4" within "#position_3"
    And I should see "page3" within "#position_4"
    And I should see "page2" within "#position_5"
    And I should see "page1" within "#position_6"
    And I should see "page9" within "#position_7"

Scenario: make a page read now (manually)
  Given pages with all possible stars exist
  When I am on the page with title "page1"
    And I press "Read Now"
  Then I should see "page1" within "#position_1"
    And I should see "page0" within "#position_2"
    And I should see "page2" within "#position_6"

Scenario: make a page read now (epub)
  Given pages with all possible stars exist
  When I am on the page with title "page3"
    And I follow "ePub"
    And I am on the homepage
  Then I should see "page3" within "#position_1"
    And I should see "page0" within "#position_2"
    And I should see "page4" within "#position_4"

Scenario: make a page read now and then reset it to original
  Given pages with all possible stars exist
  When I am on the page with title "page1"
    And I press "Read Now"
    And I am on the page with title "page1"
    And I press "Read Later"
  Then I should see "Reset read after date"
    And I should see "page0" within "#position_1"
    And I should see "page1" within "#position_6"

Scenario: check before resetting part or subpart
  Given I have a single with read_after "2009-01-01"
    And I have a series with read_after "2009-01-02"
    And I have a book with read_after "2009-01-03"
  When I am on the homepage
  Then I should see "Single" within "#position_1"
    And I should see "Grandparent" within "#position_2"
    And I should see "Parent" within "#position_3"

Scenario: resetting part read after date resets parent read after date
  Given I have a single with read_after "2009-01-01"
    And I have a series with read_after "2009-01-02"
    And I have a book with read_after "2009-01-03"
  When I am on the page with title "Parent"
    And I press "Read Now"
    And I am on the homepage
    And I follow "Parent" within "#position_1"
    And I follow "Part 1" within "#position_1"
    And I press "Read Later"
    And I am on the homepage
  Then I should see "Single" within "#position_1"
    And I should see "Parent" within "#position_3"
