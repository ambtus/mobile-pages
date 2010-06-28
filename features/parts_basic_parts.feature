Feature: basic parts
  What: create a page with multiple urls
  Why: some pages belong together and should be considered one page
  Result: be able to treat a collection of pages as one page

  Scenario: create and read a page from base url plus pattern
    Given a genre exists with name: "genre"
      And I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_base_url" with "http://test.sidrasue.com/parts/*.html"
     And I fill in "page_url_substitutions" with "1 3"
     And I fill in "page_title" with "Multiple pages from base"
     And I select "genre"
     And I press "Store"
   Then I should see "Multiple pages from base"
     And I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should not see "stuff for part 2"
     And I should not see "Part 3"
     And I should see "stuff for part 3"

  Scenario: create and read a page from base url plus pattern
    Given a genre exists with name: "genre"
      And I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_base_url" with "http://test.sidrasue.com/parts/*.html"
     And I fill in "page_url_substitutions" with "1-3"
     And I fill in "page_title" with "Multiple pages from base"
     And I select "genre"
     And I press "Store"
   Then I should see "Multiple pages from base"
     And I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"
     And I should see "Part 3"
     And I should see "stuff for part 3"

  Scenario: create and read a page from a list of urls
    Given a genre exists with name: "genre"
      And I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html
        http://test.sidrasue.com/parts/2.html
        """
     And I fill in "page_title" with "Multiple pages from urls"
     And I select "genre"
     And I press "Store"
   Then I should see "Multiple pages from urls"
     And I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"

  Scenario: children should not show up on front page by themselves
    Given a page exists with title: "Parent", urls: "http://test.sidrasue.com/parts/1.html\nhttp://test.sidrasue.com/parts/2.html"
    When I am on the homepage
    Then I should see "Parent" in ".title"
    Then I should not see "Part 1"

  Scenario: create a page from a list of urls with author and notes
    Given a genre exists with name: "mygenre"
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
     And I select "mygenre"
     And I select "myauthor"
     And I press "Store"
   Then I should see "Multiple pages from urls"
     And I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"
     And I should see "mygenre" in ".genres"
     And I should see "some notes" in ".notes"
     And I should see "myauthor" in ".authors"

