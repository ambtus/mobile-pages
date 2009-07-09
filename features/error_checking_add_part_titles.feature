Feature: error checking add parts titles

  Scenario: add subpart headings
    Given I am on the homepage
      And I have no pages
      And I follow "Store Multiple"
      And I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
      And I fill in "page_url_substitutions" with "1 2 3"
      And I fill in "page_title" with "Will Add Part Headings"
      And I press "Store"
      And I am on the homepage
    When I follow "Manage Parts"
      And I fill in "url_list" with "#Added Part Headings\n##part1\nhttp://www.rawbw.com/~alice/parts/1.html\n##part2\nhttp://www.rawbw.com/~alice/parts/2.html\nhttp://www.rawbw.com/~alice/parts/3.html"
      And I press "Update"
    Then I should see "Added Part Headings" in ".title"
      And I should see "part1" in "#position_1"
      And I should see "part2" in "#position_2"
    When I follow "Read" in "#position_1"
      Then I should see "Part 1"
    When I follow "Read" in "#position_1"
      Then I should see "stuff for part 1"
    When I am on the homepage 
      And I follow "Parts"
      And I follow "Read" in "#position_2"
      Then I should see "Part 1"
      And I should see "Part 2"
    When I follow "Read" in ".title"
    Then I should see "stuff for part 2"
      And I should see "stuff for part 3"

