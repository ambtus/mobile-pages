Feature: basic notes
   What: have a notes field
   Why: a place to write information about the fic that can be read online or searched. doesn't get added to download
   Result: notes field

  Scenario: add notes to a page from start
    Given a titled page exists
    When I am on the page's page
      And I follow "Notes"
      And I fill in "page_notes" with "testing notes"
      And I press "Update"
    Then I should see "testing notes" within ".notes"

  Scenario: edit notes on a page from show
    Given a titled page exists with notes: "some basic notes"
      And I am on the page's page
    Then I should see "some basic notes" within ".notes"
    When I follow "Notes"
      And I fill in "page_notes" with "new notes"
      And I press "Update"
    Then I should see "new notes" within ".notes"
      And I should not see "some basic notes" within ".notes"
