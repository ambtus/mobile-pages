Feature: uncollect a work which is really just a collection of shorts

  Scenario: start with a collection
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
   Then I should see "Page 1 (Book)"
   When I view the content
     Then I should see "1. One"
     And I should see "2. Two"
   When I am on the page's page
     And I follow "One"
     Then I should see "One (Chapter)"
   When I am on the page's page
     And I press "Uncollect"
   Then I should see "Uncollected"
     And I should see "One"
     And I should see "Two"
     And I should NOT see "Page 1"
     When I follow "One"
       Then I should see "One (Single)"
