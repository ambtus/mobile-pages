Feature: bugs with parts

  Scenario: can't add a page to an ambiguous parent
    Given a page exists with title: "Ambiguous1"
      And a page exists with title: "Ambiguous2"
      And a page exists with title: "Single"
    When I am on the page's page
      Then I should see "Single" in ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Ambiguous"
      And I press "Update"
    Then I should see "More than one page with that title"
      And I should not see "Ambiguous" in ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Ambiguous1"
      And I press "Update"
    Then I should see "Ambiguous1" in ".title"
      And I should see "Single" in "#position_1"

  Scenario: can't add a part to a page with content
    Given a page exists with title: "Styled", url: "http://test.sidrasue.com/styled.html"
      And a page exists with title: "Single"
    When I am on the page's page
      Then I should see "Single" in ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Styled"
      And I press "Update"
    Then I should see "Parent with that title has content"
      And I should not see "Styled" in ".title"

  Scenario: ignore empty lines
    Given a genre exists with name: "genre"
    When I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with lines "##Child 1\n\nhttp://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html\n\nhttp://test.sidrasue.com/parts/3.html##Child 2\n\n"
     And I fill in "page_title" with "Parent"
     And I select "genre"
     And I press "Store"
   Then I should see "Parent" in ".title"
     And I should see "Child 1" in "h1"
     And I should see "Child 2" in "h1"
     And I should not see "Part 3"
     And I should see "stuff for part 1"
     And I should see "stuff for part 2"
     And I should see "stuff for part 3"

  Scenario: add a part to a page with content (second way)
    Given a page exists with title: "Single", url: "http://test.sidrasue.com/test.html" 
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with lines "http://test.sidrasue.com/test.html\nhttp://test.sidrasue.com/styled.html"
      And I press "Update"
    Then I should see "Single" in ".parent"
    When I am on the homepage
      And I follow "Single" in "#position_1"
    Then I should see "Part 1" in "#position_1"
      And I should see "Part 2" in "#position_2"

  Scenario: download part
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html"
    When I am on the page's page
      And I follow "Read"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"
    When I follow "page 1"
      And I follow "Text" in "#position_1"
    Then I should see "stuff for part 1"
    And I should not see "stuff for part 2"