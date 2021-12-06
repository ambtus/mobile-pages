Feature: reset read_after order

  Scenario: make a page read now (manually or epub) and then reset it to original
    Given I have no pages
      And pages with all possible stars exist
    When I am on the homepage
      Then I should see "page0" within "#position_1"
      And I should see "page5" within "#position_2"
      And I should see "page4" within "#position_3"
      And I should see "page3" within "#position_4"
      And I should see "page2" within "#position_5"
      And I should see "page1" within "#position_6"
      And I should see "page9" within "#position_7"
    When I follow "page1"
      And I press "Read Now"
    Then I should see "page1" within "#position_1"
      And I should see "page0" within "#position_2"
    When I follow "ePub" within "#position_5"
    When I am on the homepage
    Then I should see "page3" within "#position_1"
    When I follow "page1" within "#position_2"
      And I press "Read Later"
    Then I should see "Reset read after date"
      And I should see "page1" within "#position_6"
    When I follow "page3" within "#position_1"
      And I press "Read Later"
    Then I should see "page0" within "#position_1"
      And I should see "page3" within "#position_4"
      And I should see "page1" within "#position_6"


  Scenario: resetting part or subpart read after date resets parent read after date
    Given I have no pages
      And I have a single with read_after "2009-01-01"
      And I have a series with read_after "2009-01-02"
      And I have a book with read_after "2009-01-03"
    When I am on the homepage
      Then I should see "Single" within "#position_1"
      And I should see "Grandparent" within "#position_2"
      And I should see "Parent" within "#position_3"

    When I follow "Grandparent"
      And I press "Read Now"
    When I am on the homepage
      Then I should see "Grandparent" within "#position_1"
      And I should see "Single" within "#position_2"
    When I follow "Parent"
      And I press "Read Now"
    When I am on the homepage
      Then I should see "Parent" within "#position_1"
      And I should see "Grandparent" within "#position_2"
      And I should see "Single" within "#position_3"

    When I follow "Parent" within "#position_1"
      And I follow "Part 1" within "#position_1"
      And I press "Read Later"

    Then I should see "Grandparent" within "#position_1"
      And I should see "Single" within "#position_2"
      And I should see "Parent" within "#position_3"

    When I follow "Grandparent" within "#position_1"
      And I follow "Parent2" within "#position_2"
      And I follow "Subpart" within "#position_1"
      And I press "Read Later"

    When I am on the homepage
    Then I should see "Single" within "#position_1"
      And I should see "Grandparent" within "#position_2"
      And I should see "Parent" within "#position_3"

