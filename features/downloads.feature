Feature: downloads

Scenario: audio isn't a download
  Given a page exists with audio_url: "http://imac.local/~alice/audiobooks/Fanfic/Harry%20Potter/Mirror%20of%20Maybe/Mirror%20of%20Maybe1.m4b"
  When I am on the page's page
  Then "Listen" should link to "http://imac.local/~alice/audiobooks/Fanfic/Harry%20Potter/Mirror%20of%20Maybe/Mirror%20of%20Maybe1.m4b"
    But the download html file should NOT exist
    And the download epub file should NOT exist

Scenario: text isn't a download
  Given a page exists
  When I am on the page's page
    And I follow "Read"
  Then the download directory should exist
    And the download html file should exist
    And the download epub file should NOT exist

Scenario: html is a "download"
  Given a page exists
  When I read it online
  Then the download directory should exist
    And the download html file should exist
    And the download epub file should NOT exist

Scenario: epub downloads
  Given a page exists
  When I download its epub
  Then the download directory should exist
    And the download html file should exist
    And the download epub file should exist

Scenario: removing downloads
  Given a page exists
  When I download its epub
    And I am on the page's page
    And I press "Remove Downloads"
  Then the download html file should NOT exist
    And the download epub file should NOT exist

Scenario: notes go into html downloads
  Given a page exists with notes: "Lorem ipsum dolor"
  When I read it online
  Then I should see "Lorem ipsum dolor"
    And I should see a horizontal rule

Scenario: Update notes removes old html downloads
  Given a page exists with notes: "Lorem ipsum dolor"
  When I am on the page's page
    And I follow "Notes"
    And I fill in "page_notes" with "On Assignment for Dumbledore"
    And I press "Update"
    And I read it online
  Then I should NOT see "Lorem ipsum dolor"
    And I should see "On Assignment for Dumbledore"

Scenario: my notes do go in html
  Given a page exists with my_notes: "Lorem ipsum dolor"
  When I read it online
  Then I should see "Lorem ipsum dolor"
    And I should see a horizontal rule

Scenario: update my notes removes old html downloads
  Given a page exists with my_notes: "Lorem ipsum dolor"
  When I am on the page's page
    And I follow "My Notes"
    And I fill in "page_my_notes" with "On Assignment for Dumbledore"
    And I press "Update"
    And I read it online
  Then I should see "On Assignment for Dumbledore"
    And I should NOT see "Lorem ipsum dolor"

Scenario: hr between notes and my notes
  Given a page exists with notes: "Lorem ipsum dolor" AND my_notes: "abc123"
  When I read it online
  Then I should see two horizontal rules

Scenario: no hr between before rating (if no kudos)
  Given a page exists
  When I read it online
  Then I should NOT see a horizontal rule
