Feature: third level hierarchy

  Scenario: create from a list of urls with some titles
    Given I have no pages
    And I am on the homepage
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
      And I fill in "page_title" with "Page 1"
      And I press "Store"
    When I am on the page's page
    Then I should see "Page 1" within ".title"
    And I should see "Part the first" within "#position_1"
      And I should see "Part 2" within "#position_2"
      And I should see "Third Part" within "#position_3"
    When I follow "Part the first"
      Then I should see "subpart title" within "#position_1"
      And I should see "Part 2" within "#position_2"
    When I follow "Part 2"
      Then "Original" should link to "http://test.sidrasue.com/parts/2.html"
    When I am on the page's page
    And I follow "Part 2"
      Then "Original" should link to "http://test.sidrasue.com/parts/3.html"
    When I am on the page's page
    And I follow "Third Part"
      Then I should see "Part 2" within "#position_2"
    When I follow "Part 2"
      Then "Original" should link to "http://test.sidrasue.com/parts/5.html"

  Scenario: create by adding parent to parent
    Given a page exists
    When I am on the page's page
    And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Grandparent"
      And I press "Update"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Great-Grandparent"
      And I press "Update"
      And I view the content
    Then I should see "Page 1" within "h4"

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
    When I view the content for part 1
      Then I should see "stuff for part 1"
    When I am on the page with title "Now I'm a Grandparent"
      And I follow "Parent2" within "#position_2"
    Then I should see "Part 1"
      And I should see "Part 2"
    When I view the content
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
      And I press "Update"
    Then I should see "Grandparent"
      And I should see "Parent" within "#position_1"
    When I am on the homepage
     And I follow "Single"
     When I follow "Manage Parts"
      And I fill in "add_parent" with "Grandparent"
      And I press "Update"
    Then I should see "Parent" within "#position_1"
      And I should see "Single" within "#position_2"
      And I should NOT see "Parent with that title has content"
      And I should NOT see "Original" within ".title"
      And I should NOT see "Original" within "#position_1"
      But I should see "Original" within "#position_2"
    When I follow "Parent"
    Then I should see "Grandparent" within ".parent"
    And I should NOT see "Original" within ".title"
      But I should see "Original" within "#position_1"
      And I should see "Original" within "#position_2"
    When I follow "Part 2"
      Then "Original" should link to "http://test.sidrasue.com/parts/3.html"

  Scenario: add another mid level
    Given a page exists
    When I am on the page's page
    When I follow "Manage Parts"
      And I fill in "url_list" with
        """
        ##Parent1
        ##Parent2
        http://test.sidrasue.com/parts/3.html
        ##Parent3
        """
      And I press "Update"
      And I follow "Parent2" within "#position_2"
    Then I should see "Part 1" within "#position_1"
      And I should NOT see "Part 2"
    When I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/3.html
        http://test.sidrasue.com/parts/4.html
        """
      And I press "Update"
    Then I should see "Parent2" within ".title"
      And I should NOT see "Could not find or create parent"
      And I should see "Part 1" within "#position_1"
      And I should see "Part 2" within "#position_2"
    When I follow "Page 1" within ".parent"
    Then I should see "Parent1" within "#position_1"
      And I should see "Parent2" within "#position_2"
      And I should see "Parent3" within "#position_3"
    When I follow "Parent2" within "#position_2"
    And I follow "Part 2" within "#position_2"
    Then "Original" should link to "http://test.sidrasue.com/parts/4.html"

   Scenario: rating a single unread child sets parent and grandparent to read
    Given I have no pages
    And a page exists with title: "Parent" AND urls: "http://test.sidrasue.com/parts/1.html" AND last_read: "2009-01-01"
   When I am on the homepage
   And I follow "Parent"
     And I follow "Manage Parts"
     And I fill in "add_parent" with "Grandparent"
     And I fill in "url_list" with
       """
       http://test.sidrasue.com/parts/1.html
       http://test.sidrasue.com/parts/2.html
       """
     And I press "Update"
   Then I should see "unread" within ".last_read"
    And I should NOT see "2009-01-01"
   When I follow "Parent"
   Then I should see "2009-01-01" within "#position_1"
   When I follow "Part 2"
      And I follow "Rate"
      And I choose "3"
    And I press "Rate"
    When I am on the homepage
   Then I should NOT see "unread" within "#position_1"
    And I should see "2009-01-01" within "#position_1"
