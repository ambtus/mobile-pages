Feature: page size

  Scenario: filter on a size
    Given the following pages
      | title  | url                                   |
      | Short  | http://test.sidrasue.com/short.html   |
      | Medium | http://test.sidrasue.com/medium.html  |
      | Long   | http://test.sidrasue.com/long.html    |
    And a page exists with title: "Long2" AND base_url: "http://test.sidrasue.com/medium*.html" AND url_substitutions: "1 2 3"
    And a page exists with title: "Novel" AND base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "1 2 3"
    And a page exists with title: "Epic" AND base_url: "http://test.sidrasue.com/long*.html" AND url_substitutions: "4 5 6 7 8 9"
    When I am on the homepage
    Then I should see "Short" within "#position_1"
      And I should see "Medium" within "#position_2"
      And I should see "Long" within "#position_3"
      And I should see "Long2" within "#position_4"
      And I should see "Novel" within "#position_5"
      And I should see "Epic" within "#position_6"
    When I choose "size_short"
      And I press "Find"
    Then I should see "Short" within "#position_1"
      And I should see "Medium" within "#position_2"
      And I should NOT see "Long"
      And I should NOT see "Novel"
      And I should NOT see "Epic"
      And I should NOT see "Part 1"
    When I choose "size_medium"
      And I press "Find"
    Then I should see "Long" within "#position_1"
      And I should see "Long2" within "#position_2"
      And I should NOT see "Short"
      And I should NOT see "Medium"
      And I should NOT see "Epic"
      And I should see "Part 1 | Part 2"
      And I should NOT see "More Parts"
      And I should NOT see "Part 4 | Part 5"
    When I choose "size_long"
      And I press "Find"
    Then I should see "Novel" within "#position_1"
      And I should see "Epic" within "#position_2"
      And I should NOT see "Short"
      And I should NOT see "Medium"
      And I should NOT see "Long"
      And I should see "Part 4 | Part 5 | More Parts"
    When I follow "More Parts"
      Then I should see "Epic"

