Feature: basic rate
  What: be able to say how long to wait before presenting a page again
  Why: some pages I like more and want to read more often than others
  Result: Order should reflect prefence

  Scenario: Changing read after orders
    Given the following pages
      | title                            | read_after |
      | Grimm's Fairy Tales              | 2009-01-01 |
      | Dracula                          | 2009-01-05 |
      | Alice's Adventures In Wonderland | 2009-01-10 |
      | Pride and Prejudice              | 2009-01-15 |
      | The Mysterious Affair at Styles  | 2009-01-20 |
      | The Call of the Wild             | 2009-01-25 |
      | A Christmas Carol                | 2009-01-30 |
    When I am on the homepage
    Then I should see "Grimm's Fairy Tales"
    When I press "Read Later"
    Then I should see "Dracula"
    When I follow "Rate"
    Then I should see "Please rate (converted to years for next suggested read date)"
      And I press "5"
    # note - this will change every year - test will need updating
    Then I should see "Dracula set for reading again on 2015"
      And I should see "Alice's Adventures In Wonderland"
    When I follow "Rate"
    And I press "3"
    # note - this will change every year - test will need updating
    Then I should see "Alice's Adventures In Wonderland set for reading again on 2013"
      And I should see "Pride and Prejudice"
    When I press "Read Later"
    Then I should see "The Mysterious Affair at Styles"
    When I follow "Rate"
    And I press "4"
    # note - this will change every year - test will need updating
    Then I should see "The Mysterious Affair at Styles set for reading again on 2014"
      And I should see "The Call of the Wild"
    When I press "Read Later"
    Then I should see "A Christmas Carol"
    When I follow "Rate"
      And I press "1"
    # note - this will change every year - test will need updating
    Then I should see "A Christmas Carol set for reading again on 2011"
      And I should see "Grimm's Fairy Tales"
    When I follow "Rate"
      And I press "5"
    Then I should see "Pride and Prejudice"
    When I follow "Rate"
      And I press "2"
    Then I should see "The Call of the Wild"
    When I follow "Rate"
      And I press "100"
    # note - this will change every year - test will need updating
    Then I should see "The Call of the Wild set for reading again on 2110"
