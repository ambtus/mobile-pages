Feature: ao3 testing that can use local files
         so I don't have to constantly be fetching from
         (would need to be updated if ao3 changes it's format)

Scenario: rebuild meta shouldn't refetch
  Given I Drive Myself Crazy exists
  When I change its raw html to "junk"
    And I press "Rebuild Meta"
  Then the contents should include "junk"
    And the contents should NOT include "Traveling through galaxies"

Scenario: rebuild from raw should also rebuild meta
  Given I Drive Myself Crazy exists
    And "Sidra" is an "Author"
  When I am on the homepage
    And I follow "I Drive Myself Crazy"
    And I follow "Notes"
    And I fill in "page_notes" with "testing notes"
    And I press "Update"
    And I press "Rebuild from Raw HTML"
  Then I should see "Sidra" within ".authors"
    And I should NOT see "by Sidra" within ".notes"
    And I should see "please no crossovers" within ".notes"
    And I should NOT see "testing notes" within ".notes"

Scenario: rebuilding shouldn't change chapter titles if i've modified them
  Given Time Was exists
  When I am on the page with title "Hogwarts"
    And I change the title to "Hogwarts (abandoned)"
    And I follow "Time Was, Time Is"
    And I press "Rebuild Meta"
  Then I should see "Hogwarts (abandoned)" within "#position_2"

Scenario: rebuilding should change chapter titles if they're boring
  Given Time Was exists
  When I am on the page with title "Hogwarts"
    And I change the title to "2. Chapter 2"
    And I follow "Time Was, Time Is"
    And I press "Rebuild Meta"
  Then I should see "2. Hogwarts" within "#position_2"
    But the part titles should be stored as "Where am I? & Hogwarts"
