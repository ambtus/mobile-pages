Feature: complex parts with titles from url list

  Scenario: create parts from a list of urls with titles
    Given a genre exists with name: "genre"
    When I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_urls" with
      """
      http://test.sidrasue.com/parts/1.html
      
      http://test.sidrasue.com/parts/2.html##part title
      """
      And I fill in "page_title" with "my title"
      And I select "genre" from "Genre"
      And I press "Store"
    Then I should see "my title" within ".title"
      And I should see "Part 1" within "h1"
      And I should see "part title" within "h1"
      And I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: create subparts from a list of urls with titles
    Given a genre exists with name: "genre"
    When I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_urls" with
      """
      ##Part the first
      http://test.sidrasue.com/parts/1.html###subpart title
      http://test.sidrasue.com/parts/2.html
      
      http://test.sidrasue.com/parts/3.html##Part 2
      
      ##Third Part
      http://test.sidrasue.com/parts/4.html
      http://test.sidrasue.com/parts/5.html
      """
      And I fill in "page_title" with "New Title"
      And I select "genre" from "Genre"
      And I press "Store"
    Then I should see "New Title" within ".title"
      And I should see "Part the first" within "h1"
      And I should see "subpart title" within "h2"
      And I should see "stuff for part 1"
      And I should see "Part 2" within "h2"
      And I should see "stuff for part 2"
      And I should see "Part 2" within "h1"
      And I should see "stuff for part 3"
      And I should see "Third Part" within "h1"
      And I should see "stuff for part 4"
      And I should see "stuff for part 5"

  Scenario: add a part updates the parent's read_after but add a parent doesn't
    Given a page exists with title: "page 1", url: "http://test.sidrasue.com/parts/1.html", read_after: "2100-01-01"
      And a page exists with title: "page 2", url: "http://test.sidrasue.com/parts/2.html", read_after: "2100-01-02"
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
      And I should see "page 2" within "#position_2"
    When I follow "Read" within "#position_2"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "New Parent"
      And I press "Update"
    When I am on the homepage
    Then I should see "page 1" within "#position_1"
      And I should see "New Parent" within "#position_2"
      And I should not see "page 2"
    When I follow "Read" within "#position_2"
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/3.html
        http://test.sidrasue.com/parts/4.html
        """
      And I press "Update"
    When I am on the homepage
    Then I should see "New Parent" within "#position_1"
      And I should see "page 1" within "#position_2"

  Scenario: non-matching last reads
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html", last_read: "2009-01-01"
    When I am on the page's page
      And I follow "Read" within "#position_2"
      And I follow "Rate"
      And I press "2"
   When I am on the page's page
# note - year will change every year
   Then I should see "2010-" within ".last_read"
     And I should see "unread" within "#position_1"
     And I should not see "2010-" within "#position_2"
     And I should not see "unread" within "#position_2"
