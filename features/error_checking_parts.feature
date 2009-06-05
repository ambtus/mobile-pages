Feature: error checking with parts

  Scenario: can't add a page to an ambiguous parent
    Given I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
      And I fill in "page_url_substitutions" with "1"
      And I fill in "page_title" with "Ambiguous"
      And I press "Store"
      And I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
      And I fill in "page_url_substitutions" with "2"
      And I fill in "page_title" with "Another Ambiguous"
      And I press "Store"
    When I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/test.html"
    And I fill in "page_title" with "Single Part"
    And I press "Store"
      And I follow "Manage Parts"
      And I fill in "add_parent" with "Ambiguous"
      And I press "Update"
    Then I should see "Couldn't find or create parent"
      And I should not see "Another Ambiguous" in ".title"
     When I follow "Manage Parts"
      And I fill in "add_parent" with "Another Ambiguous"
      And I press "Update"
    Then I should not see "Couldn't find or create parent"
      And I should see "Another Ambiguous" in ".title"
      And I should see "Single Part" in "#position_2"

  Scenario: can't add a part to a page with content
    Given I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/test.html"
      And I fill in "page_title" with "Single Part"
      And I press "Store"
    When I am on the homepage
      And I fill in "page_url" with "http://www.rawbw.com/~alice/styled.html"
      And I fill in "page_title" with "Styled Part"
      And I press "Store"
     When I follow "Manage Parts"
      And I fill in "add_parent" with "Single Part"
      And I press "Update"
    Then I should see "Couldn't find or create parent"
      And I should not see "Single Part" in ".title"

  Scenario: ignore empty lines
    Given I have no pages
    And I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_urls" with "#Parent\n\n##Child 1\nhttp://www.rawbw.com/~alice/parts/1.html\nhttp://www.rawbw.com/~alice/parts/2.html\n\nhttp://www.rawbw.com/~alice/parts/3.html##Child 2\n\n"
     And I fill in "page_title" with "Pages from urls with empty lines"
     And I press "Store"
   Then I should see "Parent" in ".title"
     And I should see "Child 1" in "h1"
     And I should see "Child 2" in "h1"
     And I should not see "Part 3"
