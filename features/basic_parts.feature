Feature: basic parts
  What: create a page with multiple urls
  Why: some pages belong together and should be considered one page
  Result: be able to treat a collection of pages as one page

  Scenario: create and read a page from base url plus pattern
    Given I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
     And I fill in "page_url_substitutions" with "1 2 3"
     And I fill in "page_title" with "Multiple pages from base"
     And I press "Store"
   Then I should see "Multiple pages from base"
     And I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"
     And I should see "Part 3"
     And I should see "stuff for part 3"

  Scenario: create and read a page from a list of urls
    Given I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_urls" with line1: "http://www.rawbw.com/~alice/parts/1.html" and line2: "http://www.rawbw.com/~alice/parts/2.html"
     And I fill in "page_title" with "Multiple pages from urls"
     And I press "Store"
   Then I should see "Multiple pages from urls"
     And I should see "Part 1"
     And I should see "stuff for part 1"
     And I should see "Part 2"
     And I should see "stuff for part 2"

  Scenario: children should not show up on front page by themselves
    Given I have no pages
      And I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_urls" with line1: "http://www.rawbw.com/~alice/parts/1.html" and line2: "http://www.rawbw.com/~alice/parts/2.html"
     And I fill in "page_title" with "Multiple pages from urls"
     And I press "Store"
     And I am on the homepage
     And I should see "Multiple pages from urls"
   When I press "Next"
   Then I should see "Multiple pages from urls"

