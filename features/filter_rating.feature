Feature: stars

  Scenario: search for a favorite book
    Given pages with all possible ratings exist
      And I am on the homepage

    When I choose "stars_5"
      And I press "Find"
    Then I should see "page5"
    And "5" should be checked
    But I should NOT see "page4"
      And I should NOT see "page3"
      And I should NOT see "page2"
      And I should NOT see "page1"

    When I choose "stars_better"
      And I press "Find"
    Then I should see "page5"
      And I should see "page4"
    And "better" should be checked
    But I should NOT see "page3"
      And I should NOT see "page2"
      And I should NOT see "page1"

    When I choose "stars_3"
      And I press "Find"
    Then I should NOT see "page5"
      And I should NOT see "page4"
    And I should NOT see "page2"
      And I should NOT see "page1"
      But I should see "page3"

    When I choose "stars_worse"
      And I press "Find"
    Then I should NOT see "page5"
      And I should NOT see "page4"
      And I should NOT see "page3"
    But I should see "page2"
      And I should see "page1"

    When I am on the homepage
      And I select "interesting" from "rating"
      And I select "hateful" from "omitted"
      And I press "Find"
    Then I should NOT see "page3"
    And I should NOT see "page2"
    And I should NOT see "page1"
      But I should see "page5"
      And I should see "page4i"
      But I should NOT see "page4l"

    When I am on the homepage
      And I select "loving" from "rating"
      And I select "boring" from "omitted"
      And I press "Find"
    Then I should NOT see "page3"
     And I should NOT see "page2"
     And I should NOT see "page1"
      But I should see "page5"
      And I should see "page4l"
      But I should NOT see "page4i"
