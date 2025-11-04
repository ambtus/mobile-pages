Feature: Keira Marcos fics

Scenario: book of chapters
  Given "Sentinel" is a "Fandom"
    And "Keira Marcos" is an "Author"
    And The Awakening exists
  When I am on the last page's page
  Then I should see "The Awakening (Book)"
    And I should see "Sentinel" within ".fandoms"
    And I should see "Keira Marcos" within ".authors"
    And I should see "Blair Sandberg/Jim Ellison" within ".notes"
    And I should see "Detective Jim Ellison doesn’t want a Guide." within ".notes"
    And I should see "full notes"
    And I should see "68,618 words (2 parts)"
    And I should see "1. Part One – Five"
    And I should see "2. Part Six – Ten"
