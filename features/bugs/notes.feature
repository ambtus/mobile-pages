Feature: notes bugs

Scenario: full notes link bug
  Given link in notes exists
  When I am on the first page's page
  Then I follow "full notes"

Scenario: weird formatting in end notes
  Given a page exists with end_notes: "(⸝⸝´꒳`⸝⸝♡)"
  When I download its epub
  Then the temporary epub file should exist

Scenario: if i toggle them all, they should only show if they exist
  Given a work exists with chapter end_notes at end
  When I am on the first page's page
    And I press "Put all end notes before"
    And I read it online
  Then I should see exactly 2 "Chapter Notes:"
