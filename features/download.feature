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


  Scenario: my notes don’t go in html (or epub)
    Given a page exists with my_notes: "Lorem ipsum dolor"
    When I am on the page's page
     When I view the content
    Then I should not see "Lorem ipsum dolor"
    When I am on the page's page
    When I follow "My Notes"
      And I fill in "page_my_notes" with "On Assignment for Dumbledore"
      And I press "Update"
    When I am on the page's page
     When I view the content
    Then I should not see "On Assignment for Dumbledore"

