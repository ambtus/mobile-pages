Feature: filter by favorite

Scenario: check before filter (default)
  Given pages with all possible favorites exist
  When I am on the filter page
    And I press "Find"
  Then I should see "good single"
    And I should see "bad single"
    And I should see "bad parent of good child"
    And I should see "bad parent of bad child"
    And I should see "good parent of good child"
    And I press "Next"
  Then I should see "good parent of bad child"
    And the page should NOT contain css "#position_2"

Scenario: favorite
  Given pages with all possible favorites exist
  When I am on the filter page
    And I click on "favorite_Yes"
    And I press "Find"
  Then I should see "good single"
    And I should see "good parent of bad child"
    And I should see "good parent of good child"
    And the page should NOT contain css "#position_4"

Scenario: favorite (only chapters)
  Given pages with all possible favorites exist
  When I am on the filter page
    And I click on "favorite_Yes"
    And I click on "type_Chapter"
    And I press "Find"
  Then I should see "good child of bad parent"
    And I should see "good child of good parent"
    And the page should NOT contain css "#position_3"

Scenario: not favorite
  Given pages with all possible favorites exist
  When I am on the filter page
    And I click on "favorite_No"
    And I press "Find"
  Then I should see "bad single"
    And I should see "bad parent of good child"
    And I should see "bad parent of bad child"
    And the page should NOT contain css "#position_4"
