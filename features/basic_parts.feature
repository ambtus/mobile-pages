Feature: basic parts
  What: create a page with multiple urls
  Why: some pages belong together and should be considered one page
  Result: be able to treat a collection of pages as one page

  Scenario: create and read a page from base url plus pattern
    Given I have no pages
      And the following genre
        | name |
        | my genre |
      And I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_base_url" with "http://sidrasue.com/tests/parts/*.html"
     And I fill in "page_url_substitutions" with "1 2 3"
     And I fill in "page_title" with "Multiple pages from base"
     And I select "my genre"
     And I press "Store"
   Then I should see "Multiple pages from base"
     And I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"
     And I should see "Part 3"
     And I should see "stuff for part 3"

  Scenario: create and read a page from a list of urls
    Given I have no pages
      And the following genre
        | name |
        | my genre |
      And I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with lines "http://sidrasue.com/tests/parts/1.html\nhttp://sidrasue.com/tests/parts/2.html"
     And I fill in "page_title" with "Multiple pages from urls"
     And I select "my genre"
     And I press "Store"
   Then I should see "Multiple pages from urls"
     And I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"

  Scenario: children should not show up on front page by themselves
    Given the following page
      |title   | urls |
      | Parent | http://sidrasue.com/tests/parts/1.html\nhttp://sidrasue.com/tests/parts/2.html |
    When I am on the homepage
    Then I should see "Parent" in ".title"
    When I press "Read Later"
    Then I should see "Parent" in ".title"

