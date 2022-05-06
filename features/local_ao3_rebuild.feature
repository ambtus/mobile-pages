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

