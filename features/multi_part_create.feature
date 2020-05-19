Feature: creating multi-part pages

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
   When I go to the page with title "Multiple pages from urls"
   Then I should see "Multiple pages from urls" within ".title"
   When I follow "HTML" within ".title"
   Then I should see "Part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"
     And I should see "stuff for part 1"

  Scenario: create a page from a list of urls with author and notes
    Given a tag exists with name: "mytag"
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
     And I select "mytag" from "tag"
     And I select "myauthor" from "Author"
     And I press "Store"
   Then I should see "Multiple pages from urls"
     And I should see "mytag" within ".tags"
     And I should see "some notes" within ".notes"
     And I should see "myauthor" within ".authors"
     And I should see "Part 1" within "#position_1"
     And I should see "Part 2" within "#position_2"
   When I follow "HTML" within ".title"
     Then I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"

  Scenario: create from a list of urls some of which have titles
    Given a tag exists with name: "tag"
    When I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_urls" with
      """
      http://test.sidrasue.com/parts/1.html

      http://test.sidrasue.com/parts/2.html##part title
      """
      And I fill in "page_title" with "my title"
      And I select "tag" from "tag"
      And I press "Store"
    Then I should see "my title" within ".title"
    When I follow "HTML" within ".title"
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
   When I go to the page with title "Multiple pages from base"
   Then I should see "Multiple pages from base" within ".title"
   When I follow "HTML" within ".title"
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
   When I go to the page with title "Multiple pages from base"
   Then I should see "Multiple pages from base" within ".title"
   When I follow "HTML" within ".title"
     And I should see "Part 1"
     And I should see "Part 2"
     And I should not see "Part 3"
     And I should see "stuff for part 1"
     And I should not see "stuff for part 2"
     And I should see "stuff for part 3"

  Scenario: ignore empty lines in list or urls during create
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
     And I should see "Child 1" within "h2"
     And I should see "Boo" within "h3"
     And I should see "Part 2"
     And I should see "Child 2"
     And I should not see "Part 3"
     And I should see "stuff for part 1"
     And I should see "stuff for part 2"
     And I should see "stuff for part 3"


  Scenario: should not be able to store using a pasted html file
    Given a titled page exists with url: "http://test.sidrasue.com/test.html"
    When I am on the page's page
     Then I should see "Edit Raw HTML"
     And I should see "Edit Scrubbed HTML"
    Given a titled page exists with urls: "http://test.sidrasue.com/test.html"
    When I am on the page's page
     Then I should not see "Edit Raw HTML"
     And I should not see "Edit Scrubbed HTML"
