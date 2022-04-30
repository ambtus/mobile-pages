Feature: ao3 testing that can use local files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: bad formatting notes
  Given Bad Formatting exists
  When I am on the homepage
  Then I should see "He is theirs The clones have nothing"
    And I should NOT see "theirsThe"

Scenario: bad formatting content
  Given Bad Formatting exists
  Then the contents should include "It doesn’t always work"
    And the contents should NOT include "doesnâ€™t"

Scenario: quotes in notes download bug
  Given Quoted Notes exists
  When I am on the homepage
    And I follow "ePub"
  Then the download epub file should exist

Scenario: single of work should have work title, not chapter title
  Given Fuuinjutsu exists
  When I am on the homepage
  Then I should NOT see "Chapter 1"
    But I should see "Fuuinjutsu+Chakra+Bonds+Clones, Should not be mixed by Uzumakis"

Scenario: no author or fandom or relationships shouldn't get empty paragraph
  Given "esama" is an "Author"
    And "Harry Potter" is a "Fandom"
    And Wheel exists
  When I am on the homepage
    Then I should NOT see "; Harry has been thinking"
    But I should see "Harry has been thinking"
    And the notes should NOT include "<p></p><hr width=\"80%\"/> <p>Harry has been thinking"
    But the notes should include "<p>Harry has been thinking and Voldemort gets to be the first to hear the results.</p> <hr width=\"80%\"/>"

Scenario: bug in make_single when Single had been stored as Chapter
  Given broken Drabbles exists
  When I am on the page's page
    And I press "Uncollect"
    And I follow "Skipping Stones"
  Then I should see "Skipping Stones (Single)"
