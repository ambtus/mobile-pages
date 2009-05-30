Feature: extended store

  Scenario: refetch original html
    Given I am on the homepage
    When I fill in "page_title" with "test refetch"
      And I fill in "page_url" with "http://www.rawbw.com/~alice/test.html"
      And I fill in "page_pasted" with "system down"
      And I press "Store"
    When I follow "Refetch"
    Then the field with id "url" should contain "http://www.rawbw.com/~alice/test.html"
    When I press "Refetch"
    Then I should see "Retrieved from the web"

  Scenario: refetch original html for parts
    Given I am on the homepage
      And I follow "Store Multiple"
    When I fill in "page_base_url" with "http://www.rawbw.com/~alice/parts/*.html"
      And I fill in "page_url_substitutions" with "1"
      And I fill in "page_title" with "Multiple pages from base"
      And I press "Store"
    When I follow "Refetch" in ".title"
    Then the field with id "url_list" should contain "http://www.rawbw.com/~alice/parts/1.html"
    When I fill in "url_list" with "http://www.rawbw.com/~alice/parts/2.html\nhttp://www.rawbw.com/~alice/parts/1.html"
      And I press "Refetch"
    Then I should see "stuff for part 2"

  Scenario: add utf8
    Given I have no pages
      And I am on the homepage
    When I fill in "page_title" with "test add utf8"
      And I fill in "page_url" with "http://www.rawbw.com/~alice/sbutf8.html"
      And I press "Store"
    Then I should see "â€œ"
    When I press "Make UTF8"
    Then I should see "“H"

  Scenario: add utf8 to parts
    Given I am on the homepage
      And I have no pages
      And I follow "Store Multiple"
    When I fill in "page_base_url" with "http://www.rawbw.com/~alice/*.html"
      And I fill in "page_url_substitutions" with "sbutf8"
      And I fill in "page_title" with "Multiple should be utf8 pages"
      And I press "Store"
    Then I should see "â€œ"
    When I press "Make UTF8"
    Then I should see "“H"
