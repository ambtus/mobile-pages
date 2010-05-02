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
      And I fill in "page_title" with "New Title"
      And I select "genre"
      And I press "Store"
    Then I should see "New Title" in ".title"
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

  Scenario: add a part updates the parent's read_after but add a parent doesn't
    Given a page exists with title: "page 1", url: "http://test.sidrasue.com/parts/1.html", read_after: "2100-01-01"
      And a page exists with title: "page 2", url: "http://test.sidrasue.com/parts/2.html", read_after: "2100-01-02"
    When I am on the homepage
    Then I should see "page 1" in "#position_1"
      And I should see "page 2" in "#position_2"
    When I follow "Read" in "#position_2"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "page 1" in "#position_1"
      And I should see "New Parent" in "#position_2"
      And I should not see "page 2"
    When I follow "Read" in "#position_2"
      And I follow "Manage Parts"
      And I fill in "url_list" with lines "http://test.sidrasue.com/parts/3.html\nhttp://test.sidrasue.com/parts/4.html"
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" in "#position_1"
      And I should see "page 1" in "#position_2"

  Scenario: non-matching last reads
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html", last_read: "2009-01-01"
    When I am on the page's page
      And I follow "Read" in "#position_2"
      And I follow "Rate"
      And I press "2"
   When I am on the page's page
# note - year will change every year
   Then I should see "2010-" in ".last_read"
     And I should see "unread" in "#position_1"
     And I should not see "2010-" in "#position_2"
     And I should not see "unread" in "#position_2"
