Feature: trim cruft off notes

Scenario: only get link if notes have content
  Given a page exists
  When I am on the first page's page
  Then I should NOT see "Scrub Notes"

Scenario: remove bottom when one automatically removed surrounding div
  Given a page exists with notes: "<div><div>1st</div><div>2nd</div><div>3rd</div></div></div>"
  When I am on the first page's page
    And I follow "Scrub Notes"
    And I click on "3rd" within ".bottom"
    And I press "Scrub Notes" within ".bottom"
  Then the notes should include "1st"
    And the notes should include "2nd"
    But the notes should NOT include "3rd"

Scenario: remove top when one automatically removed surrounding blockquote
  Given a page exists with notes: "<div><blockquoteclass='something'id='somethingelse'><div>1st</div><div>2nd</div><div>3rd</div></blockquote></div>"
  When I am on the first page's page
    And I follow "Scrub Notes"
    And I click on "1st" within ".top"
    And I press "Scrub Notes" within ".top"
  Then the notes should include "2nd"
    And the notes should include "3rd"
    But the notes should NOT include "1st"

Scenario: check before trimming notes removes download html
  Given a page exists with notes: "<div><div>1st</div><div>2nd</div><div>3rd</div></div></div>"
  When I read it online
  Then I should see "1st"
    And I should see "3rd"
    And the download directory should exist

Scenario: trimming notes removes download html
  Given a page exists with notes: "<div><div>1st</div><div>2nd</div><div>3rd</div></div></div>"
    And I read it online
  When I am on the first page's page
    And I follow "Scrub Notes"
    And I click on "1st" within ".top"
    And I click on "3rd" within ".bottom"
    And I press "Scrub Notes" within ".bottom"
  Then the download html file should NOT exist

Scenario: cannot recover from trimming too much
  (except if created from meta; see local_scrub_notes.feature)
  Given a page exists with notes: "<div><div>1st</div><div>2nd</div><div>3rd</div></div></div>"
  When I am on the first page's page
    And I follow "Scrub Notes"
    And I click on "1st" within ".bottom"
    And I press "Scrub Notes" within ".bottom"
    And I press "Rebuild from Raw HTML"
  Then the notes should be empty

