Feature: numbering parts with a parent (visible, but not stored)

  Scenario: no numbers when ends in a number
    Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
    When I am on the page's page
      And I view the content
   Then I should see "Part 1"
     And I should see "Part 2"
   But I should NOT see "1. Part 1"
     And I should NOT see "2. Part 2"

  Scenario: yes numbers when does not end in a number
    Given I have no pages
    And I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html##One
        http://test.sidrasue.com/parts/2.html##Two
        """
     And I fill in "page_title" with "Page 1"
     And I press "Store"
   When I am on the page's page
      And I view the content
     And I should see "1. One"
     And I should see "2. Two"
     But the part titles should be stored as "One & Two"

  Scenario: no numbers when already includes the same number
    Given I have no pages
    And I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        http://test.sidrasue.com/parts/1.html##Section 1
        http://test.sidrasue.com/parts/2.html##Epilogue
        """
     And I fill in "page_title" with "Page 1"
     And I press "Store"
   When I am on the page's page
      And I view the content
   Then I should see "Section 1"
     And I should see "2. Epilogue"
   But I should NOT see "1. Section 1"
   And the part titles should be stored as "Section 1 & Epilogue"

