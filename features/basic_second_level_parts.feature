Feature: 2nd layer heirarchy
  What: would like to be able to have a part of a part
  Why: a series of pages, grouped together as a single page, each of which has parts
  Result: 2nd level heirarchy

  Scenario: second layer heirarchy
    Given I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_urls" with "http://www.rawbw.com/~alice/parts/1.html"
      And I fill in "page_title" with "Grandparent"
      And I press "Store"
      And I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_urls" with "http://www.rawbw.com/~alice/parts/2.html"
      And I fill in "page_title" with "Parent"
      And I press "Store"
    When I follow "Manage Parts"
      And I fill in "add_parent" with "Grandparent"
      And I press "Update"
    Then I should see "Grandparent"
      And I should see "Part 1" in "#position_1"
      And I should see "Parent" in "#position_2"
    When I follow "Read" in ".title"
    Then I should see "Part 1"
      And I should see "stuff for part 1"
      And I should see "Parent"
      And I should see "stuff for part 2"
    When I follow "Download" in ".title"
    Then My document should contain "stuff for part 2"
      And My document should contain "stuff for part 2"
      And My document should contain "#Parent#"

