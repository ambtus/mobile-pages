Feature: numbering parts with a parent

  Scenario: no numbers when ends in a number
    Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
    When I am on the page's page
      And I view the content
   Then I should see "Part 1"
     And I should see "Part 2"
     And I should see "stuff for part 1"
     And I should see "stuff for part 2"
   But I should not see "1. Part 1"
     And I should not see "2. Part 2"

  Scenario: yes numbers when does not end in a number
    Given I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html##One
        http://test.sidrasue.com/parts/2.html##Two
        """
     And I fill in "page_title" with "Multiple pages from urls"
     And I press "Store"
   When I am on the page with title "Multiple pages from urls"
      And I view the content
   Then I should see "stuff for part 1"
     And I should see "stuff for part 2"
     And I should see "1. One"
     And I should see "2. Two"

  Scenario: no numbers when already includes the same number
    Given I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html##Section 1
        http://test.sidrasue.com/parts/2.html##Epilogue
        """
     And I fill in "page_title" with "Multiple pages from urls"
     And I press "Store"
   When I am on the page with title "Multiple pages from urls"
      And I view the content
   Then I should see "stuff for part 1"
     And I should see "stuff for part 2"
   Then I should see "Section 1"
     And I should see "2. Epilogue"
   But I should not see "1. Section 1"

