Feature: basic edit of parts
  What: edit the parts of an existing page
  Why: to add, remove or rearrange the order of parts
  result: an updated page with the changed parts

  Scenario: add a new part to an existing page with parts
    Given I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
      And I fill in "page_url_substitutions" with "1"
      And I fill in "page_title" with "Parent Page"
      And I press "Store"
    When I follow "Manage Parts"
      And I fill in "url_list" with "http://www.rawbw.com/~alice/parts/1.html\nhttp://www.rawbw.com/~alice/parts/2.html"
      And I press "Update"
    Then I should see "Part 2"
      And I should see "Part 1"
    When I follow "Read"
    Then I should see "stuff for part 1"
      And I should see "stuff for part 2"

  Scenario: remove a part from an existing page with parts
    Given I am on the homepage
      And I have no pages
      And I follow "Store Multiple"
      And I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
     And I fill in "page_url_substitutions" with "1 2 3"
     And I fill in "page_title" with "Parent with too many parts"
     And I press "Store"
    When I am on the homepage
      And I follow "Manage Parts"
      And I fill in "url_list" with "http://www.rawbw.com/~alice/parts/2.html\nhttp://www.rawbw.com/~alice/parts/3.html"
      And I press "Update"
      And I should not see "Part 3"
      And I follow "Read"
    Then I should not see "stuff for part 1"
      And I should see "stuff for part 2"
      And I should see "stuff for part 3"

  Scenario: reorder the parts on an existing page with parts
    Given I am on the homepage
      And I have no pages
      And I follow "Store Multiple"
      And I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
     And I fill in "page_url_substitutions" with "1 2"
     And I fill in "page_title" with "Parent with part in wrong order"
     And I press "Store"
    When I am on the homepage
      And I follow "Manage Parts"
      And I fill in "url_list" with "http://www.rawbw.com/~alice/parts/2.html\nhttp://www.rawbw.com/~alice/parts/1.html"
      And I press "Update"
      And I follow "Read" in "#position_1"
    Then I should see "stuff for part 2"
