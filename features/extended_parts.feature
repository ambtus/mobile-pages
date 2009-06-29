Feature: complex parts with titles from url list

  Scenario: create parts from a list of urls with titles
    Given I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_urls" with "#Parent\n##Child 1\nhttp://www.rawbw.com/~alice/parts/1.html\nhttp://www.rawbw.com/~alice/parts/2.html\nhttp://www.rawbw.com/~alice/parts/3.html ##Child 2\nhttp://www.rawbw.com/~alice/parts/4.html ##Child 3\n##Child 4\nhttp://www.rawbw.com/~alice/parts/5.html ###Grandchild 1\nhttp://www.rawbw.com/~alice/parts/6.html ###Grandchild 2"
     And I fill in "page_title" with "Pages from urls with titles"
     And I press "Store"
   Then I should see "Parent" in ".title"
     And I should see "Child 1" in "h1"
     And I should see "Part 1" in "h2"
     And I should see "stuff for part 1"
     And I should see "Part 2" in "h2"
     And I should see "stuff for part 2"
     And I should see "Child 2" in "h1"
     And I should see "stuff for part 3"
     And I should see "Child 3" in "h1"
     And I should see "stuff for part 4"
     And I should see "Child 4" in "h1"
     And I should see "Grandchild 1" in "h2"
     And I should see "stuff for part 5"
     And I should see "Grandchild 2" in "h2"
     And I should see "stuff for part 6"


  Scenario: add a part updates the parent's read_after
    Given I have no pages
      And the following pages
     | title | urls                                     |
     | Test1 | http://www.rawbw.com/~alice/parts/1.html |
     | Test2 | http://www.rawbw.com/~alice/parts/3.html |
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
      And I fill in "url_list" with "http://www.rawbw.com/~alice/parts/3.html\nhttp://www.rawbw.com/~alice/parts/4.html"
      And I press "Update"
    When I am on the homepage
    Then I should see "Test2" in ".title"
