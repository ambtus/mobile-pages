Feature: download page with parts

  Scenario: create and read a page from base url plus pattern
    Given I am on the homepage
      And I have no pages
      And I follow "Store Multiple"
    When I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
     And I fill in "page_url_substitutions" with "1 2 3"
     And I fill in "page_title" with "Multiple pages from base"
     And I press "Store"
    When I follow "Download" in ".title"
    Then My document should contain "cruft in part 1\n\n# Part 2 #"
