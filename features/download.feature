Feature: downloads

  Scenario: text
    Given a page exists
    When I am on the page's page
      And I follow "Text"
    Then the download directory should exist
    Then the download html file should exist
    Then the download epub file should NOT exist

  Scenario: html downloads
    Given a page exists
    When I am on the page's page
      And I view the content
    Then the download directory should exist
    Then the download html file should exist
    Then the download epub file should NOT exist

  Scenario: epub downloads
    Given a page exists
    When I am on the page's page
      And I download the epub
    Then the download directory should exist
    Then the download html file should exist
    Then the download epub file should exist

  Scenario: rebuilding downloads
    Given a page exists
    When I am on the page's page
      And I download the epub
    When I am on the page's page
      And I press "Remove Downloads"
    Then the download html file should NOT exist
    And the download epub file should NOT exist

  Scenario: Update notes removes old html
    Given I have no pages
    And a page exists with notes: "Lorem ipsum dolor"
    When I am on the page's page
     When I view the content
    Then I should see "Lorem ipsum dolor"
    When I am on the page's page
    When I follow "Notes"
      And I fill in "page_notes" with "On Assignment for Dumbledore"
      And I press "Update"
    When I am on the page's page
     When I view the content
    Then I should NOT see "Lorem ipsum dolor"
      And I should see "On Assignment for Dumbledore"

  Scenario: my notes do go in html (and epub)
    Given I have no pages
    And a page exists with my_notes: "Lorem ipsum dolor"
    When I am on the page's page
     When I view the content
    Then I should see "Lorem ipsum dolor"
    When I am on the page's page
    When I follow "My Notes"
      And I fill in "page_my_notes" with "On Assignment for Dumbledore"
      And I press "Update"
    When I am on the page's page
     When I view the content
    Then I should see "On Assignment for Dumbledore"

  Scenario: two and three levels (h3 & h4)
    Given I have no pages
    When I am on the homepage
      And I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        ##Child 1
        http://test.sidrasue.com/parts/3.html##Child 2
        """
      And I fill in "page_title" with "Parent"
      And I press "Store"
      And I follow "Child 1"
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/1.html##Boo
        ##Grandchild
        """
     And I press "Update"
     And I follow "Grandchild"
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/2.html##Hiss
        """
     And I press "Update"
   When I am on the page with title "Parent"
     And I view the content
     Then I should see "Child 1" within "h2"
     And I should see "Boo" within "h3"
     And I should see "Hiss" within "h4"

