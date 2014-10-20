Feature: new composite rating made up of stressful and interesting.

  Scenario: new rating page
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
    Then I should see "very interesting"
      And I should see "good"
      And I should see "dull"
      And I should see "very boring"
    Then I should see "very stressful"
      And I should see "upsetting"
      And I should see "easy"
      And I should see "very sweet"
    And I should see "Rate"

  Scenario: error if don't select both before rating
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
    And I press "Rate"
    Then I should see "You must select both ratings"

  Scenario: rate as still reading
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very stressful"
      And I choose "dull"
    And I press "Rate reading"
    Then I should not see "set for reading again"
      And I should see "set to 'reading'"
    When I am on the page's page
    Then I should see "reading"
    And I should see "stressful"

  Scenario: rate a book best
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 6 months"
    When I am on the page's page
    Then I should see "favorite"

  Scenario: rate a book favorite nice
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "good"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 1 years"
    When I am on the page's page
    Then I should see "favorite"

  Scenario: rate a book favorite interesting
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "easy"
    And I press "Rate"
    Then I should see "set for reading again in 1 years"
    When I am on the page's page
    Then I should see "favorite"

  Scenario: rate a book good balanced
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "good"
      And I choose "easy"
    And I press "Rate"
    Then I should see "set for reading again in 2 years"
    When I am on the page's page
    Then I should see "good"

  Scenario: rate a book good interesting
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "upsetting"
    And I press "Rate"
    Then I should see "set for reading again in 2 years"
    When I am on the page's page
    Then I should see "good"

  Scenario: rate a book good easy
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "dull"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 2 years"
    When I am on the page's page
    Then I should see "good"

  Scenario: rate a book okay easy
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "dull"
      And I choose "easy"
    And I press "Rate"
    Then I should see "set for reading again in 3 years"
    When I am on the page's page
    Then I should see "okay"

  Scenario: rate a book okay good
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "good"
      And I choose "upsetting"
    And I press "Rate"
    Then I should see "set for reading again in 3 years"
    Then I should see "okay"

  Scenario: rate a book okay stressful
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very interesting"
      And I choose "very stressful"
    And I press "Rate"
    Then I should see "set for reading again in 3 years"
    When I am on the page's page
    Then I should see "stressful"

  Scenario: rate a book okay boring
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very boring"
      And I choose "very sweet"
    And I press "Rate"
    Then I should see "set for reading again in 3 years"
    When I am on the page's page
    Then I should see "boring"

  Scenario: rate a book not great
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "dull"
      And I choose "upsetting"
    And I press "Rate"
    Then I should see "set for reading again in 4 years"

  Scenario: rate a book very bad
    Given a titled page exists
    When I am on the page's page
    When I follow "Rate"
      And I choose "very boring"
      And I choose "very stressful"
    And I press "Rate"
    Then I should see "set for reading again in 6 years"
    When I am on the page's page
    Then I should see "boring"
      And I should see "stressful"

  Scenario: search for a favorite book
    Given pages with all possible ratings exist
      And I am on the homepage
    When I choose "favorite_yes"
      And I press "Find"
    Then I should see "page00"
      And I should see "page01"
    But I should not see "page02"
      And I should not see "page03"
    Then I should see "page10"
    But I should not see "page11"
      And I should not see "page12"
      And I should not see "page13"
      And I should not see "page2"
      And I should not see "page3"

  Scenario: search for a with low stress
    Given pages with all possible ratings exist
      And I am on the homepage
    When I choose "find_sweet"
      And I press "Find"
    Then I should see "page20"
      And I should see "page30"
    But I should not see "page02"
      And I should not see "page03"

  Scenario: search for interesting
    Given pages with all possible ratings exist
      And I am on the homepage
    When I choose "find_interesting"
      And I press "Find"
    Then I should see "page02"
      And I should see "page03"
    But I should not see "page20"
      And I should not see "page30"

  Scenario: search for a book with both low stress & high interest
    Given pages with all possible ratings exist
      And I am on the homepage
    When I choose "find_both"
      And I press "Find"
    Then I should see "page00" within "#position_1"
    But I should not see "page01"
      And I should not see "page10"
      And I should not see "page11"
      And I should not see "page33"
