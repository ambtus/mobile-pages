Feature: basic rate
  What: be able to say how long to wait before presenting a page again
  Why: some pages I like more and want to read more often than others
  Result: Order should reflect prefence

  Scenario: Changing read after orders
    Given 5 titled pages exist
    When I am on the homepage
    Then I should see "page 1" in "#position_1"
      And I should see "page 2" in "#position_2"
      And I should see "page 3" in "#position_3"
      And I should see "page 4" in "#position_4"
      And I should see "page 5" in "#position_5"
    When I follow "Read" in "#position_1"
      And I follow "Rate"
    Then I should see "Please rate (converted to years for next suggested read date)"
    When I press "5"
# note - year will change every year
    Then I should see "page 1 set for reading again on 2015-"
      And I should see "page 2" in "#position_1"
      And I should see "page 3" in "#position_2"
      And I should see "page 4" in "#position_3"
      And I should see "page 5" in "#position_4"
      And I should see "page 1" in "#position_5"
    When I follow "Read" in "#position_1"
      And I follow "Rate"
      And I press "3"
# note - year will change every year
    Then I should see "page 2 set for reading again on 2013-"
      And I should see "page 3" in "#position_1"
      And I should see "page 4" in "#position_2"
      And I should see "page 5" in "#position_3"
      And I should see "page 2" in "#position_4"
      And I should see "page 1" in "#position_5"
    When I follow "Read" in "#position_1"
      And I follow "Rate"
      And I press "4"
# note - year will change every year
    Then I should see "page 3 set for reading again on 2014-"
      And I should see "page 4" in "#position_1"
      And I should see "page 5" in "#position_2"
      And I should see "page 2" in "#position_3"
      And I should see "page 3" in "#position_4"
      And I should see "page 1" in "#position_5"
    When I follow "Read" in "#position_1"
      And I follow "Rate"
      And I press "1"
# note - year will change every year
    Then I should see "page 4 set for reading again on 2011-"
      And I should see "page 5" in "#position_1"
      And I should see "page 4" in "#position_2"
      And I should see "page 2" in "#position_3"
      And I should see "page 3" in "#position_4"
      And I should see "page 1" in "#position_5"
    When I follow "Read" in "#position_1"
      And I follow "Rate"
      And I press "100"
# note - year will change every year
    Then I should see "page 5 set for reading again on 2110"
      And I should see "page 4" in "#position_1"
      And I should see "page 2" in "#position_2"
      And I should see "page 3" in "#position_3"
      And I should see "page 1" in "#position_4"
      And I should see "page 5" in "#position_5"
