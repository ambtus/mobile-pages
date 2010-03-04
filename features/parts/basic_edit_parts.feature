Feature: basic edit of parts
  What: edit the parts of an existing page
  Why: to add, remove or rearrange the order of parts
  result: an updated page with the changed parts

  Scenario: add a new part to an existing page with parts
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with lines "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html"
      And I press "Update"
    Then I should see "Part 2"
      And I should see "Part 1"
    When I follow "Read"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: remove a part from an existing page with parts
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2 3"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with lines "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/3.html"
      And I press "Update"
      And I should not see "Part 3"
      And I follow "Read"
    Then I should see "stuff for part 1"
      But I should not see "stuff for part 2"
      And I should see "stuff for part 3"

  Scenario: reorder the parts on an existing page with parts
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with lines "http://test.sidrasue.com/parts/2.html\nhttp://test.sidrasue.com/parts/1.html"
      And I press "Update"
      And I follow "Read" in "#position_1"
    Then I should see "stuff for part 2"
    When I am on the homepage
      And I follow "page 1" in "#position_1"
      And I follow "Read" in "#position_2"
    Then I should see "stuff for part 1"