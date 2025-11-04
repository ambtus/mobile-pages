Feature: notes on parts

Scenario: notes on multi-page view (self)
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the first page's page
    And I follow "Part 1"
    And I follow "Notes"
    And I fill in "page_notes" with "This is a note"
    And I press "Update"
  Then I should see "This is a note" within ".notes"
    And I should see "Part 1" within ".title"

Scenario: notes on multi-page view (parent)
  Given a page exists with base_url: "http://test.sidrasue.com/parts/*.html" AND url_substitutions: "1 2"
  When I am on the first page's page
    And I follow "Part 1"
    And I follow "Notes"
    And I fill in "page_notes" with "This is a note"
    And I press "Update"
    And I follow "Page 1"
  Then I should see "This is a note" within "#position_1"

