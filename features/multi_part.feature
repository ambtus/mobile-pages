Feature: multi-part pages

  Scenario: refetch original html for parts
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html"
    When I am on the page's page
    When I follow "Refetch" within ".title"
    Then the "url_list" field should contain "http://test.sidrasue.com/parts/1.html"
    When I fill in "url_list" with
      """
      http://test.sidrasue.com/parts/2.html
      http://test.sidrasue.com/parts/1.html
      """
      And I press "Refetch"
    When I follow "HTML" within ".title"
    Then I should see "stuff for part 2"
    And I should see "stuff for part 1"

  Scenario: create and read a page from a list of urls
    When I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/2.html
        """
     And I fill in "page_title" with "Multiple pages from urls"
     And I press "Store"
   When I go to the page with title "Multiple pages from urls"
   Then I should see "Multiple pages from urls" within ".title"
   When I follow "HTML" within ".title"
   Then I should see "Part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"
     And I should see "stuff for part 1"

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
      And I select "genre" from "genre"
      And I press "Store"
    Then I should see "my title" within ".title"
    When I follow "HTML" within ".title"
      And I should see "Part 1"
      # FIXME within bug
      And I should see "part title"
      And I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: create and read a page from base url plus range
    When I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_base_url" with "http://test.sidrasue.com/parts/*.html"
     And I fill in "page_url_substitutions" with "1-3"
     And I fill in "page_title" with "Multiple pages from base"
     And I press "Store"
   When I go to the page with title "Multiple pages from base"
   Then I should see "Multiple pages from base" within ".title"
   When I follow "HTML" within ".title"
     And I should see "Part 1"
     And I should see "Part 2"
     And I should see "Part 3"
     And I should see "stuff for part 1"
     And I should see "stuff for part 2"
     And I should see "stuff for part 3"

  Scenario: base url plus substitutions
    When I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_base_url" with "http://test.sidrasue.com/parts/*.html"
     And I fill in "page_url_substitutions" with "1 3"
     And I fill in "page_title" with "Multiple pages from base"
     And I press "Store"
   When I go to the page with title "Multiple pages from base"
   Then I should see "Multiple pages from base" within ".title"
   When I follow "HTML" within ".title"
     And I should see "Part 1"
     And I should see "Part 2"
     And I should not see "Part 3"
     And I should see "stuff for part 1"
     And I should not see "stuff for part 2"
     And I should see "stuff for part 3"

  Scenario: second layer heirarchy
    Given I have no pages
    Given a page exists with title: "Parent", urls: "http://test.sidrasue.com/parts/2.html\nhttp://test.sidrasue.com/parts/3.html"
    And a page exists with title: "Single", url: "http://test.sidrasue.com/parts/1.html"
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
    When I follow "HTML" within ".title"
      # FIXME within bugs
    Then I should see "Grandparent"
      And I should see "Single"
      And I should see "Parent"
      And I should see "Part 1"
      And I should see "Part 2"
      And I should see "stuff for part 1"
      And I should see "stuff for part 2"
      And I should see "stuff for part 3"
    When I am on the homepage
      And I follow "Grandparent"
    Then I should not see "Original" within ".title"
      And I should not see "Original" within "#position_1"
      And I should see "Original" within "#position_2"
    When I follow "Parent"
    Then I should not see "Original" within ".title"
      And I should see "Original" within "#position_1"

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
      And I select "genre" from "genre"
      And I press "Store"
    Then I should see "New Title" within ".title"
    When I follow "HTML" within ".title"
    Then I should see "New Title" within "h1"
      # FIXME someday to be within h2
      And I should see "Part the first"
      # FIXME someday to be within h3
      And I should see "subpart title"
      And I should see "stuff for part 1"
      # FIXME someday to be within h3
      And I should see "Part 2"
      And I should see "stuff for part 2"
      # FIXME someday to be within h2
      And I should see "Part 2"
      And I should see "stuff for part 3"
      # FIXME someday to be within h2
      And I should see "Third Part"
      And I should see "stuff for part 4"
      And I should see "stuff for part 5"

  Scenario: third layer heirarchy
    Given I have no pages
      And a genre exists with name: "genre"
    When I am on the homepage
    When I fill in "page_url" with "http://test.sidrasue.com/parts/1.html"
      And I fill in "page_title" with "Grandchild"
      And I select "genre" from "genre"
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
    When I follow "HTML" within ".title"
    Then I should see "Grandparent" within "h1"
      And I should see "Parent" within "h2"
      And I should see "Child" within "h3"
      And I should see "Grandchild" within "h4"
      And I should see "stuff for part 1"

  Scenario: ignore empty lines in list or urls
    When I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        ##Child 1
        http://test.sidrasue.com/parts/1.html###Boo
        http://test.sidrasue.com/parts/2.html
        http://test.sidrasue.com/parts/3.html##Child 2

        """
     And I fill in "page_title" with "Parent"
     And I press "Store"
   When I go to the page with title "Parent"
   Then I should see "Parent" within ".title"
   When I follow "HTML" within ".title"
    Then I should see "Parent" within "h1"
     # FIXME to be within h2 someday
     And I should see "Child 1"
     # FIXME to be within h3 someday
     And I should see "Boo"
     And I should see "Part 2"
     # FIXME to be within h2 someday
     And I should see "Child 2"
     And I should not see "Part 3"
     And I should see "stuff for part 1"
     And I should see "stuff for part 2"
     And I should see "stuff for part 3"

  Scenario: children should not show up on front page by themselves
    Given a page exists with title: "Parent", urls: "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html"
    When I am on the homepage
    Then I should see "Parent" within ".title"
    But I should not see "Part 1"

  Scenario: create a new parent for an existing page
    Given a page exists with title: "Single", url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Parent"
      And I press "Update"
    Then I should see "Parent" within ".title"
      And I should see "Single" within "#position_1"
    When I follow "Single" within "#position_1"
    Then I follow "Parent" within ".parent"

  Scenario: can't add a page to an ambiguous parent
    Given I have no pages
    Given a page exists with title: "Ambiguous1"
      And a page exists with title: "Ambiguous2"
      And a page exists with title: "Single"
    When I am on the page's page
      Then I should see "Single" within ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Ambiguous"
      And I press "Update"
    Then I should see "More than one page with that title"
      And I should not see "Ambiguous" within ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Ambiguous1"
      And I press "Update"
    Then I should not see "Parent with that title has content"
      And I should see "Page added to this parent"

  Scenario: can't add a part to a page with content
    Given a page exists with title: "Styled", url: "http://test.sidrasue.com/styled.html"
      And a page exists with title: "Single"
    When I am on the page's page
      Then I should see "Single" within ".title"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Styled"
      And I press "Update"
    Then I should see "Parent with that title has content"
      And I should not see "Styled" within ".title"

  Scenario: add an existing page to an existing page with parts
    Given I have no pages
    Given a page exists with title: "Single", url: "http://test.sidrasue.com/parts/3.html"
    And a page exists with title: "Multi", base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
    When I am on the homepage
    Then I should see "Single"
    And I should see "Multi"
    When I follow "Single"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Multi"
      And I press "Update"
    Then I should see "Page added to this parent"
      And I should see "Part 1"
      And I should see "Part 2"
      And I should see "Single"
    When I am on the homepage
    Then I should see "Multi" within ".title"
    But I should not see "Single"
    When I follow "HTML" within ".title"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"
      And I should see "stuff for part 3"

  Scenario: add a part to a page with content
    Given a page exists with title: "Single", url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/test.html
        http://test.sidrasue.com/styled.html
        """
      And I press "Update"
    Then I should see "Single" within ".parent"
    When I am on the homepage
      And I follow "Single" within "#position_1"
    Then I should see "Part 1" within "#position_1"
      And I should see "Part 2" within "#position_2"

  Scenario: download part
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html"
    When I am on the page's page
      And I follow "HTML" within ".title"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"
    When I am on the homepage
    When I follow "page 1"
      And I follow "Part 1"
      And I follow "HTML" within ".title"
    Then I should see "stuff for part 1"
    And I should not see "stuff for part 2"

  Scenario: add subpart headings
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2 3"
      And I am on the page's page
    When I follow "Manage Parts"
      And I fill in "title" with "Added Part Headings"
      And I fill in "url_list" with
        """
        ##part1
        http://test.sidrasue.com/parts/1.html
        ##part2
        http://test.sidrasue.com/parts/2.html
        http://test.sidrasue.com/parts/3.html
        """
      And I press "Update"
    Then I should see "Added Part Headings" within ".title"
      And I should see "part1" within "#position_1"
      And I should see "part2" within "#position_2"
    When I follow "part1" within "#position_1"
      Then I should see "Part 1" within "#position_1"
    When I follow "HTML" within "#position_1"
      Then I should see "stuff for part 1"
    When I am on the page's page
      And I follow "part2" within "#position_2"
    Then I should see "Part 1"
      And I should see "Part 2"
    When I follow "HTML" within ".title"
    Then I should see "stuff for part 2"
      And I should see "stuff for part 3"

  Scenario: second layer heirarchy
    Given a page exists with title: "Grandparent", urls: "##Parent1\n##Parent2\nhttp://test.sidrasue.com/parts/3.html\n##Parent3"
    When I am on the homepage
      And I follow "Grandparent" within "#position_1"
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
    When I follow "Grandparent" within ".parent"
    Then I should see "Parent1" within "#position_1"
      And I should see "Parent2" within "#position_2"
      And I should see "Parent3" within "#position_3"
    When I am on the homepage
      And I follow "Rate"
      And I choose "very interesting"
      And I choose "sweet enough"
    And I press "Rate"
   When I am on the homepage
      And I follow "Grandparent" within "#position_1"
      And I follow "Parent2" within "#position_2"
   Then I should not see "unread"
   When I follow "HTML" within "#position_2"
   Then I should not see "unread"

  Scenario: add a new part to an existing page with parts
    Given a titled page exists with urls: "http://test.sidrasue.com/parts/1.html"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/2.html
        """
      And I press "Update"
    Then I should see "Part 2"
      And I should see "Part 1"
    When I follow "HTML" within ".title"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: remove a part from an existing page with parts
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2 3"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/3.html
        """
      And I press "Update"
      And I should not see "Part 3"
      And I follow "HTML" within ".title"
    Then I should see "stuff for part 1"
      But I should not see "stuff for part 2"
      And I should see "stuff for part 3"

  Scenario: reorder the parts on an existing page with parts
    Given a titled page exists with base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
    When I am on the page's page
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/2.html
        http://test.sidrasue.com/parts/1.html
        """
      And I press "Update"
      And I follow "HTML" within "#position_1"
    Then I should see "stuff for part 2"
    When I am on the homepage
      And I follow "page 1" within "#position_1"
      And I follow "HTML" within "#position_2"
    Then I should see "stuff for part 1"

  Scenario: find the parent of a part
    Given the following pages
      | title   | base_url                              | url_substitutions |
      | Parent1 | http://test.sidrasue.com/parts/*.html | 1   |
      | Parent2 | http://test.sidrasue.com/parts/*.html | 2 3 |
     When I am on the homepage
     # FIXME to be within title someday
     Then I should see "Parent1"
      And I fill in "page_title" with "Part 2"
      And I press "Find"
     Then I should see "Part 2" within ".title"
