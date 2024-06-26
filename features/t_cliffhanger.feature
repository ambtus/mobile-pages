Feature: cliffhanger toggle

Scenario: cliffhanger off by default
  Given a page exists
  When I am on the page's page
  Then I should NOT see "Cliffhanger" within ".cons"

Scenario: cliffhanger off be default when rating
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
  Then "cliff_No" should be checked
    And "cliff_Yes" should NOT be checked

Scenario: turn cliffhanger on while rating
  Given a page exists
  When I am on the page's page
    And I follow "Rate"
    And I click on "4"
    And I click on "cliff_Yes"
    And I press "Rate"
  Then I should see "Con: Cliffhanger"
    And "Cliffhanger" should be selected in "page_con_ids_"

Scenario: cliffhanger pre-selected when existing
  Given a page exists with cons: "Cliffhanger"
  When I am on the page's page
    And I follow "Rate"
  Then "cliff_Yes" should be checked
    And "cliff_No" should NOT be checked

Scenario: turn cliffhanger off while rating
  Given a page exists with cons: "Cliffhanger"
  When I am on the page's page
    And I follow "Rate"
    And I click on "4"
    And I click on "cliff_No"
    And I press "Rate"
  Then "cliffhanger" should NOT be selected in "page_con_ids_"

Scenario: cliffhanger only added to parent, not newly rated parts
  Given Uneven exists
  When I am on the page's page
    And I follow "Rate"
    And I click on "4"
    And I click on "cliff_Yes"
    And I click on "all_All"
    And I press "Rate"
    And I am on the page's page
  Then I should see "Cliffhanger" within ".cons"
    But I should NOT see "Cliffhanger" within "#position_5"

Scenario: cliffhanger added to parent, not rated part
  Given Uneven exists
  When I am on the page with title "part 5"
    And I follow "Rate"
    And I click on "4"
    And I click on "cliff_Yes"
    And I press "Rate"
    And I am on the page's page
  Then I should see "Cliffhanger" within ".cons"
    But I should NOT see "Cliffhanger" within "#position_5"

Scenario: cliffhanger removed from parent, not rated part
  Given Uneven exists
  When I am on the page with title "part 4"
    And I follow "Rate"
    And I click on "4"
    And I click on "cliff_Yes"
    And I press "Rate"
    And I am on the page's page
    And I am on the page with title "part 5"
    And I follow "Rate"
    And I click on "5"
    And I click on "cliff_No"
    And I press "Rate"
    And I am on the page's page
  Then I should NOT see "Cliffhanger" within ".cons"
    And I should NOT see "Cliffhanger" within "#position_4"

Scenario: cliffhanger on parent defaults on when rating chapter
  Given Uneven exists
    And "Uneven" is a cliffhanger
  When I am on the page with title "part 5"
    And I follow "Rate"
  Then "cliff_Yes" should be checked
    And "cliff_No" should NOT be checked

Scenario: cliffhanger only added to parent, not grandparent
  Given a series exists
  When I am on the page with title "Cliffhanger"
    And I follow "Rate"
    And I click on "4"
    And I click on "cliff_Yes"
    And I press "Rate"
    And I am on the page's page
  Then I should NOT see "Cliffhanger" within ".cons"
    But I should see "Cliffhanger" within "#position_1"
