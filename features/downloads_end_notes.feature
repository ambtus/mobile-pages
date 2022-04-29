Feature: end notes

Scenario: hr between notes and end notes
  Given a page exists with notes: "Lorem ipsum dolor" AND end_notes: "abc123"
  When I am on the page's page
     And I view the content
  Then I should see a horizontal rule
    But I should NOT see two horizontal rules

Scenario: hr between my notes and end notes
  Given a page exists with my_notes: "Lorem ipsum dolor" AND end_notes: "abc123"
  When I am on the page's page
     And I view the content
  Then I should see a horizontal rule
    But I should NOT see two horizontal rules

Scenario: hr between all three
  Given a page exists with my_notes: "Lorem ipsum dolor" AND end_notes: "abc123" AND notes: "xyz987"
  When I am on the page's page
     And I view the content
  Then I should see two horizontal rules

Scenario: end notes go before by default
  Given a page exists with end_notes: "Lorem ipsum dolor" AND url: "http://test.sidrasue.com/test.html"
  When I am on the page's page
     And I view the content
  Then I should see "Lorem ipsum dolor" before "Retrieved from the web"
    But I should NOT see a horizontal rule

Scenario: end notes go after by choice
  Given a page exists with end_notes: "Lorem ipsum dolor" AND url: "http://test.sidrasue.com/test.html" AND at_end: true
  When I am on the page's page
     And I view the content
  Then I should see "Retrieved from the web" before "Lorem ipsum dolor"

Scenario: if they were before, and i toggle it, they should be after
  Given a page exists with end_notes: "Lorem ipsum dolor" AND url: "http://test.sidrasue.com/test.html"
  When I am on the page's page
    And I press "Toggle End Notes"
    And I view the content
  Then I should see "Retrieved from the web" before "Lorem ipsum dolor"

Scenario: if they were after, and i toggle it, they should be before
  Given a page exists with end_notes: "Lorem ipsum dolor" AND url: "http://test.sidrasue.com/test.html" AND at_end: true
  When I am on the page's page
    And I press "Toggle End Notes"
    And I view the content
  Then I should see "Lorem ipsum dolor" before "Retrieved from the web"
