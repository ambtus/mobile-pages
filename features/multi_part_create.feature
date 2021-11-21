Feature: creating multi-part pages

  Scenario: children should NOT show up on front page by themselves
    Given I have no pages
    And a page exists with title: "Parent" AND urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
    When I am on the homepage
    Then I should see "Parent" within ".title"
    Then I should NOT see "Part 1"

  Scenario: holder page for parts is okay
    Given I am on the homepage
    When I fill in "page_title" with "Only entered Title"
      And I press "Store"
    Then I should see "Page created" within "#flash_notice"

  Scenario: create from a list of urls
    When I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/2.html
        """
     And I fill in "page_title" with "Multiple pages from urls"
     And I press "Store"
   When I am on the page with title "Multiple pages from urls"
   Then I should see "Multiple pages from urls" within ".title"
   When I view the content
   Then I should see "Part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"
     And I should see "stuff for part 1"

  Scenario: create a page from a list of urls with author and notes
    Given a tag exists with name: "mytag" AND type: "Fandom"
    Given an author exists with name: "myauthor"
      And I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/2.html
        """
     And I fill in "page_title" with "Multiple pages from urls"
     And I fill in "page_notes" with "some notes"
     And I select "mytag" from "fandom"
     And I select "myauthor" from "Author"
     And I press "Store"
   Then I should see "Multiple pages from urls"
     And I should see "mytag" within ".fandoms"
     And I should see "some notes" within ".notes"
     And I should see "myauthor" within ".authors"
     And I should see "Part 1" within "#position_1"
     And I should see "Part 2" within "#position_2"
   When I view the content
     Then I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"

  Scenario: create from a list of urls some of which have titles
    Given a tag exists with name: "tag" AND type: "Fandom"
    When I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_urls" with
      """
      http://test.sidrasue.com/parts/1.html

      http://test.sidrasue.com/parts/2.html##part title
      """
      And I fill in "page_title" with "my title"
      And I select "tag" from "fandom"
      And I press "Store"
    Then I should see "my title" within ".title"
    When I view the content
      And I should see "Part 1"
      And I should see "part title"
      And I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: create from base url plus range
    When I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_base_url" with "http://test.sidrasue.com/parts/*.html"
     And I fill in "page_url_substitutions" with "1-3"
     And I fill in "page_title" with "Multiple pages from base"
     And I press "Store"
   When I am on the page with title "Multiple pages from base"
   Then I should see "Multiple pages from base" within ".title"
   When I view the content
     And I should see "Part 1"
     And I should see "Part 2"
     And I should see "Part 3"
     And I should see "stuff for part 1"
     And I should see "stuff for part 2"
     And I should see "stuff for part 3"

  Scenario: create from base url plus substitutions
    When I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_base_url" with "http://test.sidrasue.com/parts/*.html"
     And I fill in "page_url_substitutions" with "1 3"
     And I fill in "page_title" with "Multiple pages from base"
     And I press "Store"
   When I am on the page with title "Multiple pages from base"
   Then I should see "Multiple pages from base" within ".title"
   When I view the content
     And I should see "Part 1"
     And I should see "Part 2"
     And I should NOT see "Part 3"
     And I should see "stuff for part 1"
     And I should NOT see "stuff for part 2"
     And I should see "stuff for part 3"

  Scenario: ignore empty lines in list or urls during create
    When I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with
        """

        ##Child 1

        http://test.sidrasue.com/parts/3.html##Child 2

        """
     And I fill in "page_title" with "Parent"
     And I press "Store"
   When I am on the page with title "Parent"
   Then I should see "Parent" within ".title"
   And I should see "Child 1" within "#position_1"
   And I should see "Child 2" within "#position_2"


  Scenario: should be able to edit html if it's a Single
    Given I have no pages
    And a page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
      Then I should see "Page 1 (Single)"
      And I should see "Edit Raw HTML"
      And I should see "Edit Scrubbed HTML"

  Scenario: should NOT be able to edit html if it's a Book
    Given a page exists with urls: "http://test.sidrasue.com/test.html"
    When I am on the page's page
    Then I should see "Page 1 (Book)"
      And I should NOT see "Edit Raw HTML"
      And I should NOT see "Edit Scrubbed HTML"
