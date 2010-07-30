Feature: basic rate
  What: be able to say how long to wait before presenting a page again
  Why: some pages I like more and want to read more often than others
  Result: Order should reflect prefence

  Scenario: Changing read after orders
    Given 5 titled pages exist
    When I am on the homepage
    Then I should see "page 1 title" within "#position_1"
      And I should see "page 2 title" within "#position_2"
      And I should see "page 3 title" within "#position_3"
      And I should see "page 4 title" within "#position_4"
      And I should see "page 5 title" within "#position_5"
    When I follow "Read" within "#position_1"
      And I follow "Rate"
    Then I should see "Please rate (converted to years for next suggested read date)"
    When I press "5"
# note - year will change every year
    Then I should see "page 1 title set for reading again on 2015-"
      And I should see "page 2" within "#position_1"
      And I should see "page 3" within "#position_2"
      And I should see "page 4" within "#position_3"
      And I should see "page 5" within "#position_4"
      And I should see "page 1" within "#position_5"
    When I follow "Read" within "#position_1"
      And I follow "Rate"
      And I press "3"
# note - year will change every year
    Then I should see "page 2 title set for reading again on 2013-"
      And I should see "page 3" within "#position_1"
      And I should see "page 4" within "#position_2"
      And I should see "page 5" within "#position_3"
      And I should see "page 2" within "#position_4"
      And I should see "page 1" within "#position_5"
    When I follow "Read" within "#position_1"
      And I follow "Rate"
      And I press "4"
# note - year will change every year
    Then I should see "page 3 title set for reading again on 2014-"
      And I should see "page 4" within "#position_1"
      And I should see "page 5" within "#position_2"
      And I should see "page 2" within "#position_3"
      And I should see "page 3" within "#position_4"
      And I should see "page 1" within "#position_5"
    When I follow "Read" within "#position_1"
      And I follow "Rate"
      And I press "1"
# note - year will change every year
    Then I should see "page 4 title set for reading again on 2011-"
      And I should see "page 5" within "#position_1"
      And I should see "page 4" within "#position_2"
      And I should see "page 2" within "#position_3"
      And I should see "page 3" within "#position_4"
      And I should see "page 1" within "#position_5"
    When I follow "Read" within "#position_1"
      And I follow "Rate"
      And I press "20"
# note - year will change every year
    Then I should see "page 5 title set for reading again on 2030"
      And I should see "page 4" within "#position_1"
      And I should see "page 2" within "#position_2"
      And I should see "page 3" within "#position_3"
      And I should see "page 1" within "#position_4"
      And I should see "page 5" within "#position_5"
