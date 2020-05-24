Feature: third level hierarchy

  Scenario: create from a list of urls with some titles
    Given a tag exists with name: "mytag"
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
      And I select "mytag" from "tag"
      And I press "Store"
    Then I should see "New Title" within ".title"
    When I view the HTML
    Then I should see "New Title" within "h1"
      And I should see "Part the first" within "h2"
      And I should see "subpart title" within "h3"
      And I should see "stuff for part 1"
      And I should see "Part 2"
      And I should see "stuff for part 2"
      And I should see "Part 2"
      And I should see "stuff for part 3"
      And I should see "Third Part"
      And I should see "stuff for part 4"
      And I should see "stuff for part 5"

  Scenario: create by adding parent to parent
    Given I have no pages
      And a tag exists with name: "mytag"
    When I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/parts/1.html"
      And I fill in "page_title" with "Grandchild"
      And I select "mytag" from "tag"
      And I press "Store"
    Then I should see "Grandchild" within ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Childer"
      And I press "Update"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Grandparent"
      And I press "Update"
    When I view the HTML
    Then I should see "Grandparent" within "h1"
      And I should see "Parent" within "h2"
      And I should see "Child" within "h3"
      And I should see "Grandchild" within "h4"
      And I should see "stuff for part 1"

  Scenario: create by adding subpart headings
    Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2 3"
      And I am on the page's page
    When I follow "Manage Parts"
      And I fill in "title" with "Now I'm a Grandparent"
      And I fill in "url_list" with
        """
        ##Parent1
        http://test.sidrasue.com/parts/1.html
        ##Parent2
        http://test.sidrasue.com/parts/2.html
        http://test.sidrasue.com/parts/3.html
        """
      And I press "Update"
    Then I should see "Now I'm a Grandparent" within ".title"
      And I should see "Parent1" within "#position_1"
      And I should see "Parent2" within "#position_2"
    When I follow "Parent1" within "#position_1"
      Then I should see "Part 1" within "#position_1"
    When I follow "HTML" within "#position_1"
      Then I should see "stuff for part 1"
    When I am on the page with title "Now I'm a Grandparent"
      And I follow "Parent2" within "#position_2"
    Then I should see "Part 1"
      And I should see "Part 2"
    When I view the HTML
    Then I should see "stuff for part 2"
      And I should see "stuff for part 3"

  Scenario: add a parent to a page with parts
    Given I have no pages
    Given a page exists with title: "Parent" AND urls: "http://test.sidrasue.com/parts/2.html,http://test.sidrasue.com/parts/3.html"
    And a page exists with title: "Single" AND url: "http://test.sidrasue.com/parts/1.html"
    When I am on the homepage
    When I follow "Parent"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Grandparent"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/2.html
        http://test.sidrasue.com/parts/3.html
        """
      And I press "Update"
    Then I should see "Grandparent"
      And I should see "Parent" within "#position_1"
    When I am on the homepage
      And I fill in "page_title" with "Single"
      And I press "Find"
      Then I should see "Single" within ".title"
     When I follow "Single" within "#position_1"
      Then I should see "Single" within ".title"
     When I follow "Manage Parts"
      And I fill in "add_parent" with "Grandparent"
      And I press "Update"
    Then I should see "Parent"
      And I should see "Single"
      And I should not see "Parent with that title has content"
    When I view the HTML
    Then I should see "Grandparent" within "h1"
      And I should see "Parent" within "h2"
      And I should see "Part 1" within "h3"
      And I should see "stuff for part 2" within ".content"
      And I should see "Part 2"
      And I should see "stuff for part 3"
      And I should see "Single"
      And I should see "stuff for part 1"
    When I am on the homepage
      And I follow "Grandparent"
    Then I should not see "Original" within ".title"
      And I should not see "Original" within "#position_1"
      And I should see "Original" within "#position_2"
    When I follow "Parent"
    Then I should not see "Original" within ".title"
      And I should see "Original" within "#position_1"

  Scenario: add another mid level
    Given a page exists
    When I am on the page's page
    When I follow "Manage Parts"
      And I fill in "url_list" with
        """
        ##Parent1
        ##Parent2
        http://test.sidrasue.com/parts/3.html\
        ##Parent3
        """
      And I press "Update"
      And I follow "Parent2" within "#position_2"
    Then I should see "Part 1" within "#position_1"
      And I should not see "Part 2"
    When I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/3.html
        http://test.sidrasue.com/parts/4.html
        """
      And I press "Update"
    Then I should see "Parent2" within ".title"
      And I should not see "Could not find or create parent"
      And I should see "Part 1" within "#position_1"
      And I should see "Part 2" within "#position_2"
    When I follow "Page 1" within ".parent"
    Then I should see "Parent1" within "#position_1"
      And I should see "Parent2" within "#position_2"
      And I should see "Parent3" within "#position_3"
    When I am on the homepage
      And I follow "Rate"
      And I choose "very interesting"
      And I choose "sweet enough"
    And I press "Rate"
   When I am on the homepage
      And I follow "Page 1" within "#position_1"
      And I follow "Parent2" within "#position_2"
   Then I should not see "unread"
   When I follow "HTML" within "#position_2"
   Then I should not see "unread"

