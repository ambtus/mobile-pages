Feature: bugs found on add parts titles

  Scenario: add subpart headings
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2 3"
      And I am on the page's page
    When I follow "Manage Parts"
      And I fill in "title" with "Added Part Headings"
      And I fill in "url_list" with lines "##part1\nhttp://test.sidrasue.com/parts/1.html\n##part2\nhttp://test.sidrasue.com/parts/2.html\nhttp://test.sidrasue.com/parts/3.html"
      And I press "Update"
    Then I should see "Added Part Headings" in ".title"
      And I should see "part1" in "#position_1"
      And I should see "part2" in "#position_2"
    When I follow "List Parts" in "#position_1"
      Then I should see "Part 1"
    When I follow "Read" in "#position_1"
      Then I should see "stuff for part 1"
    When I am on the page's page
      And I follow "List Parts" in ".title"
      And I follow "List Parts" in "#position_2"
    Then I should see "Part 1"
      And I should see "Part 2"
    When I follow "Read" in ".title"
    Then I should see "stuff for part 2"
      And I should see "stuff for part 3"
