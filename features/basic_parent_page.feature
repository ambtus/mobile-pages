Feature: basic parent page
  What: when I "read" a parent page (show it), by default I only want links to read or download the parts
  Why: for some parents, the page is too huge to display or download all at once
  Result: if a page is a parent, the show (initial read) page should have the option to read or download it en mass, or to read or download each individual page

  Scenario: parent read page
    Given I have no pages
      And I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_base_url" with "http://sidrasue.com/tests/parts/*.html"
     And I fill in "page_url_substitutions" with "1 2"
     And I fill in "page_title" with "Parent Page"
     And I press "Store"
   When I am on the homepage
     And I follow "Parts"
   Then I should see "Download" in "#position_1"
     And I should see "Read" in "#position_1"
     And I should see "Download" in "#position_2"
     And I should see "Read" in "#position_2"
     And I should not see "stuff for part 1"
     And I should not see "stuff for part 2"
   When I follow "Read" in "#position_1"
   Then I should see "stuff for part 1"
     And I should not see "stuff for part 2"
   When I follow "Parent Page"
     And I follow "Read"
   Then I should see "stuff for part 1"
     And I should see "stuff for part 2"
