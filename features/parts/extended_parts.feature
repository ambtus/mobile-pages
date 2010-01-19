Feature: complex parts with titles from url list

  Scenario: create parts from a list of urls with titles
    Given a genre exists with name: "genre"
    When I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_urls" with lines "http://test.sidrasue.com/parts/1.html\n\nhttp://test.sidrasue.com/parts/2.html##part title"
      And I fill in "page_title" with "my title"
      And I select "genre"
      And I press "Store"
    Then I should see "my title" in ".title"
      And I should see "Part 1" in "h1"
      And I should see "part title" in "h1"
      And I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: create subparts from a list of urls with titles
    Given a genre exists with name: "genre"
    When I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_urls" with lines "##Part the first\nhttp://test.sidrasue.com/parts/1.html###subpart title\nhttp://test.sidrasue.com/parts/2.html\n\nhttp://test.sidrasue.com/parts/3.html##Part 2\n\n##Third Part\nhttp://test.sidrasue.com/parts/4.html\nhttp://test.sidrasue.com/parts/5.html"
      And I fill in "page_title" with "Title"
      And I select "genre"
      And I press "Store"
    Then I should see "Title" in ".title"
      And I should see "Part the first" in "h1"
      And I should see "subpart title" in "h2"
      And I should see "stuff for part 1"
      And I should see "Part 2" in "h2"
      And I should see "stuff for part 2"
      And I should see "Part 2" in "h1"
      And I should see "stuff for part 3"
      And I should see "Third Part" in "h1"
      And I should see "stuff for part 4"
      And I should see "stuff for part 5"

  Scenario: add a part updates the parent's read_after
    Given the following pages
     | title | urls                                  |
     | Test1 | http://test.sidrasue.com/parts/1.html |
     | Test2 | http://test.sidrasue.com/parts/3.html |
    When I am on the homepage
    Then I should see "Test1" in ".title"
    When I press "Read Later"
    And I am on the homepage
    Then I should see "Test2" in ".title"
    When I press "Read Later"
    And I am on the homepage
    Then I should see "Test1" in ".title"
    When I fill in "search" with "Test2"
      And I press "Search"
    Then I should see "Test2" in ".title"
    When I follow "Manage Parts"
      And I fill in "url_list" with lines "http://test.sidrasue.com/parts/3.html\nhttp://test.sidrasue.com/parts/4.html"
      And I press "Update"
    When I am on the homepage
    Then I should see "Test2" in ".title"
