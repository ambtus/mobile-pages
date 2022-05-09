Feature: numbering parts with a parent (visible, but not stored)

Scenario: both numbers
  Given a page exists with urls: "http://test.sidrasue.com/parts/1.html,http://test.sidrasue.com/parts/2.html"
  When I read it online
  Then I should see "Part 1"
    And I should see "Part 2"
    But I should NOT see "1. Part 1"
    And I should NOT see "2. Part 2"
    And the part titles should be stored as "Part 1 & Part 2"

Scenario: neither numbers
  Given I am on the "Store Multiple" page
    And I fill in "page_urls" with
      """
      http://test.sidrasue.com/parts/1.html##One
      http://test.sidrasue.com/parts/2.html##Two
      """
     And I fill in "page_title" with "Page 1"
     And I press "Store"
  When I read it online
  Then I should see "1. One"
    And I should see "2. Two"
    And the part titles should be stored as "One & Two"

Scenario: some numbers
  Given I am on the "Store Multiple" page
    And I fill in "page_urls" with
      """
      http://test.sidrasue.com/parts/1.html##Section 1
      http://test.sidrasue.com/parts/2.html##Epilogue
      """
    And I fill in "page_title" with "Page 1"
    And I press "Store"
  When I read it online
  Then I should see "Section 1"
    But I should NOT see "1. Section 1"
    And I should see "2. Epilogue"
    And the part titles should be stored as "Section 1 & Epilogue"

