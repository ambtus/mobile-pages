Feature: basic notes
   What: have a notes field
   Why: a place to write information about the fic that can be read online or searched. doesn't get added to download
   Result: notes field

  Scenario: add notes to a page from start
    Given the following page
      | title                            | url                                 |
      | Grimm's Fairy Tales              | http://test.sidrasue.com/gft.html  |
    When I am on the homepage
      And I follow "Read"
      And I follow "Notes"
      And I fill in "page_notes" with "testing notes"
      And I press "Update"
    Then I should see "testing notes" in ".notes"

  Scenario: edit notes on a page from show
    Given the following page
      | title                            | url                                 | notes |
      | Grimm's Fairy Tales              | http://test.sidrasue.com/gft.html  | "some basic notes" |
      And I am on the homepage
    Then I should see "some basic notes" in ".notes"
    When I follow "Read"
      And I follow "Notes"
    When I fill in "page_notes" with "new notes"
      And I press "Update"
    Then I should see "new notes" in ".notes"
      And I should not see "some basic notes" in ".notes"
    When I am on the homepage
    Then I should see "new notes" in ".notes"
      And I should not see "some basic notes" in ".notes"
