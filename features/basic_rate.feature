Feature: basic rate
  What: be able to say how long to wait before presenting a page again
  Why: some pages I like more and want to read more often than others
  Result: Order should reflect prefence

  Scenario: Changing read after orders
    Given I have no pages
      And the following pages
      | title                            | url                                   | read_after |
      | Grimm's Fairy Tales              | http://sidrasue.com/tests/gft.html  | 2009-01-01 |
      | Dracula                          | http://sidrasue.com/tests/drac.html | 2009-01-05 |
      | Alice's Adventures In Wonderland | http://sidrasue.com/tests/aa.html   | 2009-01-10 |
      | Pride and Prejudice              | http://sidrasue.com/tests/pp.html   | 2009-01-15 |
      | The Mysterious Affair at Styles  | http://sidrasue.com/tests/maas.html | 2009-01-20 |
      | The Call of the Wild             | http://sidrasue.com/tests/cotw.html | 2009-01-25 |
      | A Christmas Carol                | http://sidrasue.com/tests/cc.html   | 2009-01-30 |
    When I am on the homepage
    Then I should see "Grimm's Fairy Tales"
    When I press "Read Later"
    Then I should see "Dracula"
    When I follow "Rate"
    Then I should see "Please rate (converted to years for next suggested read date)"
      And I press "5"
    Then I should see "Dracula set for reading again on 2014"
      And I should see "Alice's Adventures In Wonderland"
    When I follow "Rate"
    And I press "3"
    Then I should see "Alice's Adventures In Wonderland set for reading again on 2012"
      And I should see "Pride and Prejudice"
    When I press "Read Later"
    Then I should see "The Mysterious Affair at Styles"
    When I follow "Rate"
    And I press "4"
    Then I should see "The Mysterious Affair at Styles set for reading again on 2013"
      And I should see "The Call of the Wild"
    When I press "Read Later"
    Then I should see "A Christmas Carol"
    When I follow "Rate"
      And I press "1"
    Then I should see "A Christmas Carol set for reading again on 2010"
      And I should see "Grimm's Fairy Tales"
    When I follow "Rate"
      And I press "5"
    Then I should see "Pride and Prejudice"
    When I follow "Rate"
      And I press "2"
    Then I should see "The Call of the Wild"
    When I follow "Rate"
      And I press "100"
    Then I should see "The Call of the Wild set for reading again on 2109"
