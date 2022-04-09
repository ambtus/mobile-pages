Feature: downloads

Scenario: text isn't a download
  Given a page exists
  When I am on the page's page
    And I follow "Text"
  Then the download directory should exist
    And the download html file should exist
    And the download epub file should NOT exist

Scenario: html is a "download"
  Given a page exists
  When I am on the page's page
    And I view the content
  Then the download directory should exist
    And the download html file should exist
    And the download epub file should NOT exist

Scenario: link to page in downloaded html
  Given a page exists
  When I am on the page's page
    And I view the content
  Then "Page 1" should link to itself

Scenario: epub downloads
  Given a page exists
  When I am on the page's page
    And I download the epub
  Then the download directory should exist
    And the download html file should exist
    And the download epub file should exist

Scenario: removing downloads
  Given a page exists
  When I am on the page's page
    And I download the epub
    And I am on the page's page
    And I press "Remove Downloads"
  Then the download html file should NOT exist
    And the download epub file should NOT exist

Scenario: notes go into html downloads
  Given a page exists with notes: "Lorem ipsum dolor"
  When I am on the page's page
    And I view the content
  Then I should see "Lorem ipsum dolor"
    And I should NOT see a horizontal rule

Scenario: Update notes removes old html downloads
  Given a page exists with notes: "Lorem ipsum dolor"
  When I am on the page's page
    And I follow "Notes"
    And I fill in "page_notes" with "On Assignment for Dumbledore"
    And I press "Update"
    And I am on the page's page
    And I view the content
  Then I should NOT see "Lorem ipsum dolor"
    And I should see "On Assignment for Dumbledore"

Scenario: my notes do go in html
  Given a page exists with my_notes: "Lorem ipsum dolor"
  When I am on the page's page
     And I view the content
  Then I should see "Lorem ipsum dolor"
    And I should NOT see a horizontal rule

Scenario: update my notes removes old html downloads
  Given a page exists with my_notes: "Lorem ipsum dolor"
  When I am on the page's page
    And I follow "My Notes"
    And I fill in "page_my_notes" with "On Assignment for Dumbledore"
    And I press "Update"
    And I am on the page's page
    And I view the content
  Then I should see "On Assignment for Dumbledore"
    And I should NOT see "Lorem ipsum dolor"

Scenario: hr between notes and my notes
  Given a page exists with notes: "Lorem ipsum dolor" AND my_notes: "abc123"
  When I am on the page's page
     And I view the content
  Then I should see a horizontal rule

Scenario: epub image bug
  Given The Picture exists
  When I am on the homepage
    And I follow "ePub" within "#position_1"
  Then the epub html contents for "The Picture" should contain "Ki1qR8E.png"

Scenario: another epub image bug
  Given Prologue exists
  When I am on the homepage
    And I follow "ePub" within "#position_1"
  Then the epub html contents for "PrologueAfter the World Burns" should contain "coverhigh.jpg"

Scenario: regular hrefs should still link
  Given a page exists
  When I am on the page's page
    And I follow "Edit Raw HTML"
    And I fill in "pasted" with 'This is a <a href="http://test.sidrasue.com/parts/1.html">test</a>!'
    And I press "Update Raw HTML"
    And I view the content
  Then "test" should link to "http://test.sidrasue.com/parts/1.html"
