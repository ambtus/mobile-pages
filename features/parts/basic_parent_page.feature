Feature: basic parent page
  What: when I "read" a parent page (show it), by default I only want links to read or download the parts
  Why: for some parents, the page is too huge to display or download all at once
  Result: if a page is a parent, the show (initial read) page should have the option to read or download it en mass, or to read or download each individual page

  Scenario: parent read page
    Given a page exists with title: "Multi", base_url: "http://test.sidrasue.com/parts/*.html", url_substitutions: "1 2"
   When I am on the page's page
   Then I should see "Text" in "#position_1"
     And I should see "Read" in "#position_1"
     And I should see "Text" in "#position_2"
     And I should see "Read" in "#position_2"
     And I should not see "stuff for part 1"
     And I should not see "stuff for part 2"
   When I follow "Read" in "#position_1"
   Then I should see "stuff for part 1"
     And I should not see "stuff for part 2"
   When I follow "Notes"
     And I fill in "page_notes" with "This is a note"
     And I press "Update"
   When I follow "Multi"
   Then I should see "This is a note" in "#position_1"
   When I follow "Read"
   Then I should see "stuff for part 1"
     And I should see "stuff for part 2"
