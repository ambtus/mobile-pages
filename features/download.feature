Feature: downloads

  Scenario: text
    Given a page exists
    When I am on the page's page
      And I follow "Text"
    Then the download directory should exist
    Then the download html file should exist
    Then the download epub file should not exist

  Scenario: html downloads
    Given a page exists
    When I am on the page's page
      And I view the content
    Then the download directory should exist
    Then the download html file should exist
    Then the download epub file should not exist

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
    Then the download directory should not exist

  Scenario: Update notes removes old html
    Given a page exists with notes: "Lorem ipsum dolor"
    When I am on the page's page
     When I view the content
    Then I should see "Lorem ipsum dolor"
    When I am on the page's page
    When I follow "Notes"
      And I fill in "page_notes" with "On Assignment for Dumbledore"
      And I press "Update"
    When I am on the page's page
     When I view the content
    Then I should not see "Lorem ipsum dolor"
      And I should see "On Assignment for Dumbledore"

  Scenario: my notes do go in html (and epub)
    Given a page exists with my_notes: "Lorem ipsum dolor"
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

  Scenario: two and three levels
    When I am on the homepage
    When I follow "Store Multiple"
      And I fill in "page_urls" with
        """
        ##Child 1
        http://test.sidrasue.com/parts/1.html###Boo
        http://test.sidrasue.com/parts/2.html###Hiss
        http://test.sidrasue.com/parts/3.html##Child 2
        """
     And I fill in "page_title" with "Parent"
     And I press "Store"
   When I am on the page with title "Parent"
   When I view the content
     Then I should see "Boo" within "h3"
   When I am on the page with title "Child 1"
      And I follow "Manage Parts"
      And I fill in "url_list" with
        """
        http://test.sidrasue.com/parts/1.html##Boo
        ##Hiss
        http://test.sidrasue.com/parts/2.html###Critique
        http://test.sidrasue.com/parts/3.html###Blame
        """
      And I press "Update"
   When I am on the page with title "Parent"
   When I view the content
     Then I should see "Critique" within "h4"

